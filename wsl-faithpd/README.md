# Readme

[forum x-ref](https://forum.qiime2.org/t/core-diversity-analysis-error/30608/8)

```sh
conda activate qiime2-amplicon-2023.9

cd wsl-faithpd/data
wget https://data.qiime2.org/2024.5/tutorials/moving-pictures/sample_metadata.tsv
wget https://docs.qiime2.org/2024.5/data/tutorials/moving-pictures/table.qza
wget https://docs.qiime2.org/2024.5/data/tutorials/moving-pictures/rooted-tree.qza
cd ..

qiime diversity core-metrics-phylogenetic \
    --i-phylogeny data/rooted-tree.qza \
    --i-table data/table.qza \
    --p-sampling-depth 10 \
    --m-metadata-file data/sample_metadata.tsv \
    --output-dir diversity-core-metrics-phylogenetic \
    --verbose

/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/numpy/core/getlimits.py:542: UserWarning: Signature b'\x00\xd0\xcc\xcc\xcc\xcc\xcc\xcc\xfb\xbf\x00\x00\x00\x00\x00\x00' for <class 'numpy.longdouble'> does not match any known type: falling back to type probe function.
This warnings indicates broken support for the dtype!
  machar = _get_machar(dtype)
/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/skbio/util/_warning.py:60: UserWarning: observed_otus is deprecated as of 0.6.0.
  warn(f"{func.__name__} is deprecated as of {ver}.")
/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/skbio/stats/ordination/_principal_coordinate_analysis.py:146: RuntimeWarning: The result contains negative eigenvalues. Please compare their magnitude with the magnitude of some of the largest positive eigenvalues. If the negative ones are smaller, 
it's probably safe to ignore them, but if they are large in magnitude, the results won't be useful. See the Notes section for more details. The smallest eigenvalue is -0.07072978847090462 and the largest is 2.73126067720777.
  warn(
Running external command line application. This may print messages to stdout and/or stderr.
The command being run is below. This command cannot be manually re-run as it will depend on temporary files that no longer exist.

Command:

faithpd -i /tmp/qiime2/biouser/data/b5422b0e-f5f4-4f52-8adb-7850c69b8b09/data/feature-table.biom -t /tmp/qiime2/biouser/data/6fabdcaf-090e-42e9-9f5f-525b6cbb34ab/data/tree.nwk -o /tmp/q2-AlphaDiversityFormat-fej214br

/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd: line 43: /home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd_nv_avx2: cannot execute binary file: Exec format error
/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd: line 43: /home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd_nv_avx2: Success
Traceback (most recent call last):
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2cli/commands.py", line 520, in __call__
    results = self._execute_action(
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2cli/commands.py", line 586, in _execute_action
    results = action(**arguments)
  File "<decorator-gen-183>", line 2, in core_metrics_phylogenetic
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/qiime2/sdk/action.py", line 342, in bound_callable
    outputs = self._callable_executor_(
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/qiime2/sdk/action.py", line 657, in _callable_executor_
    outputs = self._callable(scope.ctx, **view_args)
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2_diversity/_core_metrics.py", line 65, in core_metrics_phylogenetic       
    faith_pd_vector, = faith_pd(table=cr.rarefied_table,
  File "<decorator-gen-815>", line 2, in faith_pd
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/qiime2/sdk/context.py", line 143, in deferred_action
    return action_obj._bind(
  File "<decorator-gen-846>", line 2, in faith_pd
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/qiime2/sdk/action.py", line 342, in bound_callable
    outputs = self._callable_executor_(
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/qiime2/sdk/action.py", line 576, in _callable_executor_
    output_views = self._callable(**view_args)
  File "<decorator-gen-121>", line 2, in faith_pd
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2_diversity_lib/_util.py", line 75, in _validate_tables
    return wrapped_function(*args, **kwargs)
  File "<decorator-gen-120>", line 2, in faith_pd
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2_diversity_lib/_util.py", line 118, in _validate_requested_cpus
    return wrapped_function(*bound_arguments.args, **bound_arguments.kwargs)
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2_diversity_lib/alpha.py", line 63, in faith_pd
    _omp_cmd_wrapper(threads, cmd)
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2_diversity_lib/_util.py", line 134, in _omp_cmd_wrapper
    return _run_external_cmd(cmd, verbose=verbose, env=env)
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/site-packages/q2_diversity_lib/_util.py", line 128, in _run_external_cmd
    return subprocess.run(cmd, check=True, env=env)
  File "/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/lib/python3.9/subprocess.py", line 528, in run
    raise CalledProcessError(retcode, process.args,
subprocess.CalledProcessError: Command '['faithpd', '-i', '/tmp/qiime2/biouser/data/b5422b0e-f5f4-4f52-8adb-7850c69b8b09/data/feature-table.biom', '-t', '/tmp/qiime2/biouser/data/6fabdcaf-090e-42e9-9f5f-525b6cbb34ab/data/tree.nwk', '-o', '/tmp/q2-AlphaDiversityFormat-fej214br']' returned non-zero exit status 126.

Plugin error from diversity:

  Command '['faithpd', '-i', '/tmp/qiime2/biouser/data/b5422b0e-f5f4-4f52-8adb-7850c69b8b09/data/feature-table.biom', '-t', '/tmp/qiime2/biouser/data/6fabdcaf-090e-42e9-9f5f-525b6cbb34ab/data/tree.nwk', '-o', '/tmp/q2-AlphaDiversityFormat-fej214br']' returned non-zero exit status 126.

See above for debug info.

```

Run the binary directly to get the same error:

```sh
(qiime2-amplicon-2024.5) biouser@home-PC:~/bin/github-repos/q2-forums/wsl-faithpd$ faithpd
/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd: line 43: /home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd_nv_avx2: cannot execute binary file: Exec format error
/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd: line 43: /home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd_nv_avx2: Success

```

## CPU info (one core only)

```text
processor       : 15
vendor_id       : AuthenticAMD
cpu family      : 25
model           : 80
model name      : AMD Ryzen 7 5700G with Radeon Graphics
stepping        : 0
microcode       : 0xffffffff
cpu MHz         : 3800.000
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 7
cpu cores       : 8
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 25
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm pni pclmulqdq ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave osxsave avx f16c rdrand hypervisor lahf_lm cmp_legacy cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw wdt topoext fsgsbase bmi1 avx2 smep bmi2 erms cqm rdt_a rdseed adx smap clflushopt clwb sha_ni umip vaes vpclmulqdq rdpid
bogomips        : 7600.00
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:
```

```sh
(qiime2-amplicon-2024.5) biouser@home-PC:~/bin/github-repos/q2-forums$ conda package --which /home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd
/home/biouser/miniconda3/envs/qiime2-amplicon-2024.5/bin/faithpd  bioconda/linux-64::unifrac-binaries-1.4-h1d423cb_0
```

The broken binary is from [bioconda/linux-64::unifrac-binaries](https://bioconda.github.io/recipes/unifrac-binaries/README.html).
