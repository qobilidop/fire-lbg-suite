#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path
from subprocess import run

import gadgeteer


ahf_input_template = """
[AHF]
ic_filename       = {ic_filename}
ic_filetype       = 60
outfile_prefix    = {outfile_prefix}
LgridDomain       = 128
LgridMax          = 1073741824  # 2^30
NperDomCell       = 5.0
NperRefCell       = 5.0
VescTune          = 1.5
NminPerHalo       = 100
RhoVir            = 0
Dvir              = -1
MaxGatherRad      = 3.0
LevelDomainDecomp = 6
NcpuReading       = 1

[GADGET]
GADGET_LUNIT      = 1e-3
GADGET_MUNIT      = 1e10
"""


def main():
    # Parse arguments
    parser = ArgumentParser()
    parser.add_argument('snapshot', type=Path,
                        default='output/snapdhot_190.hdf5')
    parser.add_argument('--dm', action='store_true')
    args = parser.parse_args()
    snap = args.snapshot

    work_dir = Path('ahf')
    work_dir.mkdir(parents=True, exist_ok=True)
    snap_name = snap.stem
    snap_bin = work_dir / snap_name

    gadgeteer.convert(snap, 'hdf5', snap_bin, 'bin2')

    ahf_input = work_dir / f'{snap_name}.input'
    ahf_input.write_text(ahf_input_template.format(
        ic_filename=snap_name,
        outfile_prefix=snap_name
    ))
    if args.dm:
        cmd = 'AHF_dm'
    else:
        cmd = 'AHF'
    print(cmd)
    run([cmd, ahf_input.relative_to(work_dir)], cwd=work_dir)


if __name__ == '__main__':
    main()
