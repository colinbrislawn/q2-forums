#!/usr/bin/env bash
# Polls the two background reproducer jobs and appends status lines to watch.log.
# Stops once both jobs are gone.
#
# Run from 34243/ (the directory containing this script):
#   ( nohup bash watcher.sh </dev/null >>watch.log 2>&1 & )
#
# Jobs are found by process pattern (not hardcoded PID), so this is reusable
# across runs. Both jobs are expected to be logging to run.log / ess-run.log
# in the same directory.
set -u

cd "$(dirname "$0")"

LOG=watch.log
ER_LOG=run.log
ESS_LOG=ess-run.log

# Output artifacts watched for completion:
ER_OUT=silva-138.2-99-V3V4.qza
ESS_OUT=silva-138.2-99-V3V4-segments.qza

echo "=== WATCHER START $(date) ===" >> "$LOG"

er_reported=0
ess_reported=0

while true; do
  ts=$(date '+%H:%M:%S')

  # --- extract-reads job ---
  er_proc=$(pgrep -f "feature-classifier extract-reads" | head -1)
  if [[ -n "${er_proc:-}" ]]; then
    er_stat=$(ps -p "$er_proc" -o pcpu=,etime=,stat= | tr -s ' ')
    er_out="no"
    [[ -f "$ER_OUT" ]] && er_out="yes"
    printf '[%s] ER  pid=%s alive (%s) output=%s\n' "$ts" "$er_proc" "$er_stat" "$er_out" >> "$LOG"
  elif [[ "$er_reported" -eq 0 ]]; then
    er_exit=$(grep -E "EXIT .* END" "$ER_LOG" 2>/dev/null | tail -1)
    printf '[%s] ER  DONE — %s\n' "$ts" "${er_exit:-no-exit-line}" >> "$LOG"
    er_reported=1
  fi

  # --- extract-seq-segments job: track the vsearch worker if present (real
  #     CPU), else the qiime/python proc, else the pixi/bash wrapper. ---
  ess_proc=$(pgrep -f "vsearch.*usearch_global" | head -1)
  ess_kind="vsearch"
  if [[ -z "${ess_proc:-}" ]]; then
    ess_proc=$(pgrep -f "qiime rescript extract-seq-segments" | head -1)
    ess_kind="qiime"
  fi
  if [[ -z "${ess_proc:-}" ]]; then
    ess_proc=$(pgrep -f "rescript extract-seq-segments" | head -1)
    ess_kind="wrapper"
  fi
  if [[ -n "${ess_proc:-}" ]]; then
    ess_stat=$(ps -p "$ess_proc" -o pcpu=,etime=,stat= | tr -s ' ')
    ess_out="no"
    [[ -f "$ESS_OUT" ]] && ess_out="yes"
    printf '[%s] ESS %s pid=%s alive (%s) segments_out=%s\n' "$ts" "$ess_kind" "$ess_proc" "$ess_stat" "$ess_out" >> "$LOG"
  elif [[ "$ess_reported" -eq 0 ]]; then
    ess_exit=$(grep -E "ESS EXIT .* END" "$ESS_LOG" 2>/dev/null | tail -1)
    printf '[%s] ESS DONE — %s\n' "$ts" "${ess_exit:-no-exit-line}" >> "$LOG"
    ess_reported=1
  fi

  # stop when both reported done
  if [[ "$er_reported" -eq 1 && "$ess_reported" -eq 1 ]]; then
    echo "=== WATCHER END $(date) — both jobs finished ===" >> "$LOG"
    break
  fi

  sleep 30
done
