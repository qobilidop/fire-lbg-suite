## "not enough memory" issue

Andrew:

> are you running with TURB_DIFF_METALS? if so, you might try adding TURB_DIFF_METALS_LOWORDER to the config, which uses a lower-order solver that requires less memory.

Phil:

> You can restart from a restartfile. Also, this is pretty common, and not really a bug, just an inevitable consequence of load-balancing in big, high-dynamic-range runs

> Increasing maxmemsize beyond what is actually available won't help you -- it will make the problem worse, in fact. in addition to andrew's suggestion [in order of decreasing 'easy-ness'] you can lower PartAllocFactor, lower the buffersize, decrease the value of TreeDomainUpdateFrequency (do tree-builds more frequently), increase the ratio of OpenMP to MPI tasks (remembering to modify the memory parameters accordingly), run on more processors (with more OpenMP as well if needed), turn off ALLOW_IMBALANCED_GASPARTICLELOAD, and restart from snapshot files to rebuild the tree from scratch.
