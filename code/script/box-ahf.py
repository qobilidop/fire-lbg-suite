#!/usr/bin/env python

import ahfriend
import yt

from src.path import repo_dir


if __name__ == '__main__':
    data_dir = repo_dir / 'data'
    ds = yt.load(data_dir / 'raw/L86/output/snapdir_005/snapshot_005.0.hdf5')
    custom_config = dict(
        LgridDomain=128,
        LgridMax=16777216,
        NperDomCell=5.0,
        NperRefCell=5.0,
        VescTune=1.5,
        NminPerHalo=20,
        RhoVir=0,
        Dvir=200,
        MaxGatherRad=3.0,
        LevelDomainDecomp=6,
        NcpuReading=1,
    }
    work_dir = data_dir / 'box-ahf'
    ahf_job = ahfriend.create_job(ds, 'AHF-dmo', custom_config, work_dir)
    ahf_job.run()
