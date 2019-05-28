# Pre-Processing

In preprocessing, we select a sample of halos from a box run, and prepare their zoom ICs.

## Reproduction Notes

The scripts and jobs are supposed to work on TSCC.

### Box Run

We are selecting our sample halos from the existing FIRE dark-matter-only box run L86 stored at `GalaxiesOnFIRE/boxes/L86`. Link `box/output` to `L86/output`, which should include `snapdir_000` (z = 99) and `snapdir_005` (z = 2) at the least, to make the snapshots available for further processing.

### Sample Selection

Run AHF on the box snapshot at z = 2:
```console
$ qsub job/box-ahf.sh  # takes ~ 0.5h
$ ls box/ahf/*.AHF_halos  # to check the output
```

AHF is run in MPI mode, with output files split into several parts. We need to combine them into a single file before moving on.
```
$ cat box/ahf/*.AHF_halos > box/ahf/snapshot_005.AHF_halos
$ head box/ahf/snapshot_005.AHF_halos  # to check the output
```

Select candidate halos from the produced AHF halo catalog:
```console
$ ./script/select-candidate.py
$ head data/halo/candidate.csv  # to check the output
```

Measure local environment density for these candidate halos:
```console
$ qsub job/menv.sh  # takes ~ 2.5h
$ head data/halo/candidate.csv  # to check the output
$ rm data/halo/menv-*  # to clear cache files
```
Note that this job adds a column `Menv` to the existing `candidate.csv` table.

Select sample from candidate halos:
```console
$ ./script/select-sample.py
$ cat data/halo/sample.csv  # to check the output
```

### Zoom IC Preparation

```console
$ ./job/ic-prep-submit-all.sh  # each job takes ~ 1h
$ ls data/zoom-region  # to check the output
```
