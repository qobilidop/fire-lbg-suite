#!/usr/bin/env python

import ahfriend
import yt

from src.path import repo_dir


if __name__ == '__main__':
    data_dir = repo_dir / 'data'
    snap_path = data_dir / 'raw/L86/output/snapdir_005/snapshot_005.0.hdf5'
    ds = yt.load(str(snap_path))
    # See http://popia.ft.uam.es/AHF/files/AHF.pdf
    # Search "sample AHF.input"
    custom_config = dict(
        # Grid resolution
        # box size = 86 Mpc
        LgridDomain=128,  # grid size = 0.67 Mpc
        LgridMax=2**30,  # grid size = 0.08 pc
        NperDomCell=5.0,
        NperRefCell=5.0,
    
        # Effectively disable unbinding
        VescTune=1e10,
    
        # Set this to a large number to reduce output file size
        NminPerHalo=1e4,  # min m_halo / Msun = 2.36e11 = 1e11.37
    
        # Define virial density as critical density
        RhoVir=0,

        # Let AHF calculate virial overdensity using spherical top-hat collapse
        Dvir=-1,
    
        # Non-essential
        MaxGatherRad=3.0,
        LevelDomainDecomp=6,
        NcpuReading=1,
    )
    work_dir = data_dir / 'box-ahf'
    ahf_job = ahfriend.create_job(ds, 'AHF-dmo', custom_config, work_dir)
    ahf_job.run()
