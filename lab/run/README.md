## z2h350
1 iteraion = 2 days

### z2h350_ref12
- Iteration 1 failed at snapshot 126 (+126):
> Sync-Point 355131, Time: 0.234602, Redshift: 3.26254, Systemstep: 2.00431e-08, Dloga: 8.54344e-08
> warning: Timestep wants to be below the limit `MinSizeTimestep'
> Part-ID=14551082  dt=6.53576e-09 dtc=1.3698e-06 ac=8.5371e+12 xyz=(29103.3|31516.2|29211.5)  hsml=0.140676  maxcsnd=2298.35 dt0=1.34612e-09 eps=0.00298378
- Iteration 2 finished at snapshot 191 (+65).

### z2h350_ref13
- Iteration 1 finished at snapshot 65 (+65).
- Iteration 2 finished at snapshot 102 (+37).
- Iteration 3 failed at snapshot 118 (+16):
> Sync-Point 1354639, Time: 0.226185, Redshift: 3.42116, Systemstep: 2.4155e-09, Dloga: 1.06793e-08
> warning: Timestep wants to be below the limit `MinSizeTimestep'
> Part-ID=128383518  dt=5.22141e-09 dtc=3.58005e-08 ac=3.09765e+12 xyz=(31539.1|32226.7|29325.9)  hsml=0.0303857  maxcsnd=19333.1 dt0=2.3566e-09 eps=0.00309481
- Iteration 4 finished at snapshot 143 (+25).
- Iteration 5 finished at snapshot 159 (+16).
- Iteration 6 failed at snapshot 167 (+8):
> Sync-Point 2617195, Time: 0.28946, Redshift: 2.45471, Systemstep: 9.89192e-08, Dloga: 3.41738e-07
> Task=27: Not enough memory in mymalloc_fullinfo() to allocate 4251.57 MB for variable 'GasGradDataResult' at hydro_gradient_calc()/hydro/gradients.c/line 760 (FreeBytes=3577.29 MB).
- Restart with number of CPUs doubled.
- Iteration 7 failed at snapshot 171 (+4):
> Sync-Point 2795571, Time: 0.297573, Redshift: 2.36051, Systemstep: 5.0846e-08, Dloga: 1.70869e-07
> Task=237: Not enough memory in mymalloc_fullinfo() to allocate 3565.18 MB for variable 'HydroDataResult' at hydro_force()/hydro/hydra_master.c/line 1117 (FreeBytes=3528.08 MB).
