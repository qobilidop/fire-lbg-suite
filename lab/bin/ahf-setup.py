#!/usr/bin/env python
"""Set up an AHF job.

This script creates an AHF input file, and converts input snapshot to binary
format.
"""
from argparse import ArgumentParser
from pathlib import Path

import yt
from giztool import ahf


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument(
        '-s', '--snap-file', type=Path,
        help='The input snapshot.'
    )
    parser.add_argument(
        '-w', '--work-dir', type=Path, default='.',
        help='The directory where the AHF command would be run.'
    )
    parser.add_argument(
        '-c', '--cpus', type=int, default=4,
        help='The number of CPUs used in reading snapshot.'
    )
    args = parser.parse_args()

    ds = yt.load(str(args.snap_file))
    # See http://popia.ft.uam.es/AHF/files/AHF.pdf
    # Search "sample AHF.input"
    ahf.create_input(
        ds, work_dir=args.work_dir,

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
        NcpuReading=args.cpus,
    )
