# Readme

[x-ref](https://forum.qiime2.org/t/very-long-runtime-20-hours-for-feature-classifier-extract-reads-with-silva-138-2-in-qiime-2-2026-4/34243)

Manual download https://www.transfernow.net/en/cld?utm_source=20260714Sk3Mei0p&utm_medium=FyLaxaIC

:warning: link now probably dead!

## Dataset

Reproducer for `qiime feature-classifier extract-reads` running ~20 hours on SILVA 138.2.

Environment:

- QIIME 2 2026.4.0 (Python 3.12.13), pixi workspace `q2-forums` (env name reported by user: `rachis-qiime2-2026.4`)
- Reporter CPU: Intel i9-14900KF, 32 threads (WSL2 on Windows)
- Reproduce CPU (this run): Apple Silicon, 10 cores, ~26 GB RAM, macOS

Commands run by the reporter (see `dataset/command.txt`):

```sh
qiime rescript get-silva-data --p-version 138.2 --p-target SSURef_NR99 \
  --o-silva-sequences silva-138.2-seqs.qza --o-silva-taxonomy silva-138.2-tax.qza
qiime tools peek silva-138.2-seqs.qza
qiime rescript reverse-transcribe --i-rna-sequences silva-138.2-seqs.qza \
  --o-dna-sequences silva-138.2-dna-seqs.qza
qiime feature-classifier extract-reads --i-sequences silva-138.2-dna-seqs.qza \
  --p-f-primer CCTACGGGNGGCWGCAG --p-r-primer GACTACHVGGGTATCTAATCC \
  --p-max-length 600 --o-reads silva-138.2-99-V3V4.qza
```

### Layout

Input data lives in `dataset/` (gitignored — `*.qza` are not stored in git, see
the repo-root `.gitignore`). Generated outputs and scripts live directly under
`34243/` (also gitignored as `*.qza` / `*.log`). Only the small text metadata in
`dataset/` and the scripts/README here are tracked.

Inputs (`dataset/`, not in git):

| file | size | md5 |
|------|------|-----|
| `silva-138.2-seqs.qza` | 192M | `818554f86c8afa54ec962235c5788352` |
| `silva-138.2-dna-seqs.qza` | 174M | `53a6ccab7d885d33f7278ece06ff1812` |

Reporter metadata (`dataset/`, tracked — the "key parts"):

| file | size | notes |
|------|------|-------|
| `command.txt` | 1.0K | exact commands run |
| `conda-list.txt` | 50K | full reporter env listing |
| `qiime-info.txt` | 1.1K | `qiime info` output |
| `cpu-info.txt` | 3.2K | reporter CPU/WSL info |
| `md5sum.txt` | 114B | md5s of the input qzas |

md5 verified locally — matches `md5sum.txt`.

Generated outputs (`34243/`, not in git — `*.qza`):

| file | size | how |
|------|------|-----|
| `silva-138.2-99-V3V4.qza` | 53.8M | `feature-classifier extract-reads` |
| `silva-138.2-99-V3V4-segments.qza` | 47.0M | `rescript extract-seq-segments` |
| `silva-138.2-99-unmatched.qza` | 2.4M | `rescript extract-seq-segments` (unmatched) |

Scripts (`34243/`, tracked):

| file | notes |
|------|-------|
| `watcher.sh` | polls the background `extract-reads` and `extract-seq-segments` jobs, writes `watch.log`, self-stops when both finish |

## Replicate

The slow step is `extract-reads` on `dataset/silva-138.2-dna-seqs.qza` (already in
this dataset, so no need to re-download from SILVA).

This repo is a pixi workspace (see `pixi.toml` at the repo root) with QIIME 2
2026.4 already pinned. All commands below use `pixi run` so the environment is
resolved automatically — no `conda create` / `conda activate` needed. Run them
from `34243/` with `--manifest-path ../pixi.toml`.

1. Install (resolve) the pixi environment once:

   ```sh
   cd /path/to/q2-forums          # repo root, where pixi.toml lives
   pixi install
   pixi run qinfo                 # sanity check: prints qiime info
   ```

2. Verify the input file:

   ```sh
   cd 34243
   md5sum dataset/silva-138.2-dna-seqs.qza   # expect 53a6ccab7d885d33f7278ece06ff1812
   pixi run --manifest-path ../pixi.toml qiime tools peek dataset/silva-138.2-dna-seqs.qza
   ```

3. Run the slow command (time it):

   ```sh
   time pixi run --manifest-path ../pixi.toml qiime feature-classifier extract-reads \
     --i-sequences dataset/silva-138.2-dna-seqs.qza \
     --p-f-primer CCTACGGGNGGCWGCAG \
     --p-r-primer GACTACHVGGGTATCTAATCC \
     --p-max-length 600 \
     --o-reads silva-138.2-99-V3V4.qza
   ```

4. Compare runtime. Original report: ~20 hours on i9-14900KF (32 threads, WSL2).

To rebuild the input from scratch (slower, downloads from SILVA):

```sh
pixi run --manifest-path ../pixi.toml qiime rescript get-silva-data --p-version 138.2 --p-target SSURef_NR99 \
  --o-silva-sequences dataset/silva-138.2-seqs.qza --o-silva-taxonomy dataset/silva-138.2-tax.qza
pixi run --manifest-path ../pixi.toml qiime rescript reverse-transcribe --i-rna-sequences dataset/silva-138.2-seqs.qza \
  --o-dna-sequences dataset/silva-138.2-dna-seqs.qza
```

### Observed runtime (this reproduce, 10-core macOS)

| method | wall-time | output | notes |
|--------|-----------|--------|-------|
| `feature-classifier extract-reads` (primer-based, 1 thread) | **~4m45s** | `silva-138.2-99-V3V4.qza` (53.8M) | exit 0, valid archive |
| `rescript extract-seq-segments` (VSEARCH, 10 threads) | **~5m58s** | `silva-138.2-99-V3V4-segments.qza` (47.0M) + `…-unmatched.qza` (2.4M) | vsearch at ~950% CPU, only 2.4M unmatched |

Both methods are fast on this box (~5–6 min) versus the reported ~20 h on
Windows/WSL2. That ~240× gap strongly suggests the original slowness is dominated
by WSL2/Windows I/O pathology, not the algorithm itself. Worth confirming with a
native-Linux or native-Windows run on comparable hardware.

## Alternative: `rescript extract-seq-segments`

`feature-classifier extract-reads` is primer-based and can be very slow on a large
full-length database like SILVA 138.2 (the ~20 h case above). RESCRIPT ships an
alternative, [`rescript extract-seq-segments`](https://amplicon-docs.qiime2.org/en/stable/references/plugins/rescript/#q2-action-rescript-extract-seq-segments),
which uses **VSEARCH** to extract matching shorter segments from
`input-sequences` given a pool of `reference-segment-sequences` that already span
the region of interest (e.g. a curated set of V3V4 amplicons). This is the
recommended route when degenerate primers bind poorly across the full-length
targets and primer-pair searching is expensive or unreliable.

Inputs / outputs (see `pixi run qiime rescript extract-seq-segments --help`):

| flag | type | notes |
|------|------|-------|
| `--i-input-sequences` | `FeatureData[Sequence]` | the full-length sequences to mine (e.g. `dataset/silva-138.2-dna-seqs.qza`) |
| `--i-reference-segment-sequences` | `FeatureData[Sequence]` | a pool of sequences spanning the region to extract |
| `--p-perc-identity` | `Range(0,1]` | VSEARCH `--id`; default `0.7` |
| `--p-target-coverage` | `Range(0,1]` | min fraction of reference segment that must align; default `0.9` |
| `--p-min-seq-len` / `--p-max-seq-len` | `Int` | filter reference segments by length; defaults `32` / `50000` |
| `--p-threads` | `Range(1,256)` | VSEARCH threads; default `1` |
| `--o-extracted-sequence-segments` | `FeatureData[Sequence]` | extracted matching segments (required) |
| `--o-unmatched-sequences` | `FeatureData[Sequence]` | input seqs with no matching segment (required) |

### Building a reference-segment pool

`extract-seq-segments` needs a `reference-segment-sequences` pool that already
spans V3V4. The recipe used here: subsample the full SILVA dna sequences, run
`extract-reads` on just the subsample (fast), and use that as the reference pool
for the full `extract-seq-segments` run.

```sh
cd 34243

# 1. export the full dna seqs and subsample ~10k records (every 51st of 510,495)
pixi run --manifest-path ../pixi.toml qiime tools export \
  --input-path dataset/silva-138.2-dna-seqs.qza --output-path /tmp/silva-export
awk 'NR%2==1{h=$0; next} {n++; if(n%51==0){print h; print $0}}' \
  /tmp/silva-export/dna-sequences.fasta > /tmp/silva-subsample.fasta
pixi run --manifest-path ../pixi.toml qiime tools import \
  --input-path /tmp/silva-subsample.fasta --output-path /tmp/silva-subsample.qza \
  --input-format DNAFASTAFormat --type 'FeatureData[Sequence]'

# 2. extract V3V4 from the subsample -> reference pool (10k seqs, ~20s)
pixi run --manifest-path ../pixi.toml qiime feature-classifier extract-reads \
  --i-sequences /tmp/silva-subsample.qza \
  --p-f-primer CCTACGGGNGGCWGCAG --p-r-primer GACTACHVGGGTATCTAATCC \
  --p-max-length 600 --o-reads /tmp/v3v4-ref-pool.qza
# -> 9,714 V3V4 reference segments
```

Other options for obtaining a reference pool:

- Import an externally curated set of V3V4 amplicons (e.g. from a prior
  classifier-training build) with `qiime tools import`.
- Inspect the action's expected input format with `--example-data`:

  ```sh
  pixi run --manifest-path ../pixi.toml qiime rescript extract-seq-segments --example-data ./ess-example
  ```

### Running `extract-seq-segments` on the full database

```sh
cd 34243
time pixi run --manifest-path ../pixi.toml qiime rescript extract-seq-segments \
  --i-input-sequences dataset/silva-138.2-dna-seqs.qza \
  --i-reference-segment-sequences /tmp/v3v4-ref-pool.qza \
  --p-perc-identity 0.7 \
  --p-target-coverage 0.9 \
  --p-threads 10 \
  --o-extracted-sequence-segments silva-138.2-99-V3V4-segments.qza \
  --o-unmatched-sequences silva-138.2-99-unmatched.qza
```

Compare runtime and yield against the primer-based `extract-reads` run above —
`extract-seq-segments` with VSEARCH + many threads sidesteps degenerate-primer
binding entirely and scales with core count (see the observed runtimes table;
on a 32-thread box it should scale better than the single-threaded `extract-reads`).

### Running in the background with a watcher

Both jobs can be launched as detached background processes that survive shell
timeouts, with `watcher.sh` polling them:

```sh
cd 34243

# extract-reads in the background, logging to run.log
nohup bash -c '
  pixi run --manifest-path ../pixi.toml qiime feature-classifier extract-reads \
    --i-sequences dataset/silva-138.2-dna-seqs.qza \
    --p-f-primer CCTACGGGNGGCWGCAG --p-r-primer GACTACHVGGGTATCTAATCC \
    --p-max-length 600 --o-reads silva-138.2-99-V3V4.qza
' >> run.log 2>&1 &

# extract-seq-segments in the background, logging to ess-run.log
nohup bash -c '
  pixi run --manifest-path ../pixi.toml qiime rescript extract-seq-segments \
    --i-input-sequences dataset/silva-138.2-dna-seqs.qza \
    --i-reference-segment-sequences /tmp/v3v4-ref-pool.qza \
    --p-perc-identity 0.7 --p-target-coverage 0.9 --p-threads 10 \
    --o-extracted-sequence-segments silva-138.2-99-V3V4-segments.qza \
    --o-unmatched-sequences silva-138.2-99-unmatched.qza
' >> ess-run.log 2>&1 &

# start the watcher (writes watch.log, self-stops when both jobs finish)
( nohup bash watcher.sh </dev/null >>watch.log 2>&1 & )

tail -f watch.log        # follow progress
```

## LLM usage

This reproducer environment and README were assembled with help from an LLM
coding agent ([pi](https://github.com/earendil-works/pi-coding-agent)). The
agent session that produced this README ran on model
`accounts/fireworks/routers/glm-fast-latest` — **GLM 5.2 Fast** at **medium
reasoning effort** — served via the [Fireworks AI](https://fireworks.ai)
provider, as recorded in the agent's session log.

The model identity was recovered from the local pi session log at
`~/.pi/agent/sessions/` (the agent cannot self-introspect its model name at
runtime).
