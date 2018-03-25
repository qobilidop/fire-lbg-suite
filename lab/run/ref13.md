# ref13

## Log

Each iteraion is 2 days.

- Iteration 1 finished at snapshot 65 (+65).
- Iteration 2 finished at snapshot 102 (+37).
- Iteration 3 failed at snapshot 118:
> Sync-Point 1354639, Time: 0.226185, Redshift: 3.42116, Systemstep: 2.4155e-09, Dloga: 1.06793e-08
> warning: Timestep wants to be below the limit `MinSizeTimestep'
> Part-ID=128383518  dt=5.22141e-09 dtc=3.58005e-08 ac=3.09765e+12 xyz=(31539.1|32226.7|29325.9)  hsml=0.0303857  maxcsnd=19333.1 dt0=2.3566e-09 eps=0.00309481
- Iteration 4 finished at snapshot 143 (+25).
- Iteration 5 finished at snapshot 159 (+16).
- Iteration 6 failed at snapshot 167 (+8):
> Sync-Point 2617195, Time: 0.28946, Redshift: 2.45471, Systemstep: 9.89192e-08, Dloga: 3.41738e-07
> Task=27: Not enough memory in mymalloc_fullinfo() to allocate 4251.57 MB for variable 'GasGradDataResult' at hydro_gradient_calc()/hydro/gradients.c/line 760 (FreeBytes=3577.29 MB).
- Iteration 7 failed at snapshot 168 (+1)
TURB_DIFF_METALS_LOWORDER turned on, PartAllocFactor 3 -> 2.5, TreeDomainUpdateFrequency 0.005 -> 0.003
> task 208: endrun called with an error level of 116608
