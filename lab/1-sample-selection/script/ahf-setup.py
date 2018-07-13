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

        # m_part = 2.36e7 Msun
        NminPerHalo=100,  # This number is chosen rather arbitrarily

        # Use critical density as virial density
        RhoVir=0,

        # Let AHF calculate virial overdensity using spherical top-hat collapse
        Dvir=-1,

        # Maximum object size in Mpc/h
        # max Rvir = 766 kpc/h as I have experimented
        MaxGatherRad=1.0,

        # MPI options
        LevelDomainDecomp=6,  # 86 / 2**6 = 1.34 Mpc = 0.91 Mpc/h
        NcpuReading=16,  # There are 16 MPI tasks
    )
    work_dir = data_dir / 'box-halo/ahf'
    ahf_job = ahfriend.create_job(ds, custom_config, work_dir)
    ahf_job.setup()
