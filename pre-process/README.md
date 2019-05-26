# Pre-Processing

In preprocessing, we select a sample of halos from a box run, and prepare their zoom ICs.

## Reproduction Notes

The scripts and jobs are supposed to work on TSCC.

### Box Run

We are selecting our sample halos from the existing FIRE dark-matter-only box run L86 stored at `GalaxiesOnFIRE/boxes/L86`. Link `box/initial_condition` to `L86/initial_condition` and `box/output` to `L86/output` to make the IC and snapshots available for further processing.

### Sample Selection

Run AHF on the box snapshot at redshift 2:
```console
$ qsub job/box-ahf.sh
$ ls box/ahf  # to check the output
```

Select candidate halos from the produced AHF halo catalog:
```console
$ ./script/select-candidate.py
$ head data/halo/candidate.csv  # to check the output
```

Measure local environment density for these candidate halos:
```console
$ qsub job/menv.sh
$ head data/halo/candidate.csv  # to check the output
```
Note that this job adds a column `Menv` to the existing `candidate.csv` table.

Select sample from candidate halos:
```console
$ ./script/select-sample.py
$ cat data/halo/sample.csv  # to check the output
```

### Zoom IC Preparation

```console
$ ./job/ic-prep-submit-all.sh
$ ls data/zoom-region  # to check the output
```
