#!/usr/bin/env python

import ahfriend
import yt

from src.path import repo_dir


if __name__ == '__main__':
    data_dir = repo_dir / 'data'
    snap_path = data_dir / 'box/L86/output/snapdir_005/snapshot_005.0.hdf5'
    ds = yt.load(str(snap_path))
    # See http://popia.ft.uam.es/AHF/files/AHF.pdf
    # Search "sample AHF.input"
    custom_config = dict(
        # Grid resolution
        # box size = 86 Mpc = 58.48 Mpc/h
        # h = 0.68
        LgridDomain=128,  # grid size = 0.67 Mpc
        LgridMax=2**30,  # grid size = 0.08 pc
        NperDomCell=5.0,
        NperRefCell=5.0,
    
        # Effectively disable unbinding
        VescTune=1e10,
    
        # Don't keep small halos in the output to reduce file size
        NminPerHalo=1e4,  # min m_halo / Msun = 2.36e11 = 1e11.37
    
        # Use critical density as virial density
        RhoVir=0,

        # Let AHF calculate virial overdensity using spherical top-hat collapse
        Dvir=-1,
    
        # Maximum object size in Mpc/h
        MaxGatherRad=3.0,

        # MPI options
        LevelDomainDecomp=4,  # 86 / 2**4 = 5.375 Mpc = 3.655 Mpc/h
        NcpuReading=8,
    )
    work_dir = data_dir / 'box-halo/ahf'
    ahf_job = ahfriend.create_job(ds, custom_config, work_dir)
    ahf_job.setup()
