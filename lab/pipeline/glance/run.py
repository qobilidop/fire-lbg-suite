#!/usr/bin/env python
from argparse import ArgumentParser

import numpy as np
import yt
from yt.frontends.gizmo.api import GizmoDataset


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('snap')
    args = parser.parse_args()

    ds = GizmoDataset(args.snap)
    ad = ds.all_data()

    hdm_type = 'PartType1'
    hdm_pos = ad[hdm_type, 'particle_position']
    hdm_mass = ad[hdm_type, 'particle_mass']
    hdm_com = np.average(hdm_pos, weights=hdm_mass, axis=0)

    p = yt.ParticlePlot(
        ds,
        (hdm_type, 'particle_position_x'),
        (hdm_type, 'particle_position_y'),
        (hdm_type, 'particle_mass'),
        center=hdm_com, width=(10, 'Mpccm'),
        data_source=ad,
    )
    p.set_buff_size(1000)
    p.set_axes_unit('Mpccm')
    p.set_unit('particle_mass', 'Msun')
    p.annotate_timestamp(redshift=True, draw_inset_box=True)
    p.annotate_scale(draw_inset_box=True)
    p.save('hdm.png')
    p.frb.save_as_dataset('hdm.h5')

    gas_type = 'PartType0'

    p = yt.ParticlePhasePlot(
        ad,
        (gas_type, 'H_nuclei_density'),
        (gas_type, 'temperature'),
        (gas_type, 'particle_mass'),
        x_bins=600,
        y_bins=600,
    )
    p.set_unit('H_nuclei_density', 'cm**-3')
    p.set_unit('temperature', 'K')
    p.set_unit('particle_mass', 'Msun')
    p.set_xlim(1e-9, 1e3)
    p.set_ylim(1e1, 1e7)
    p.annotate_title(f'z = {ds.current_redshift:.2f}')
    p.save('gas-phase.png')

    p = yt.ProjectionPlot(
        ds, 'z', (gas_type, 'density'),
        center=hdm_com, width=(10, 'Mpccm'),
        data_source=ad,
    )
    p.set_buff_size(1000)
    p.set_axes_unit('Mpccm')
    p.set_unit('density', 'Msun/kpc**2')
    p.annotate_timestamp(redshift=True, draw_inset_box=True)
    p.annotate_scale(draw_inset_box=True)
    p.save('gas-column.png')
    p.frb.save_as_dataset('gas-column.h5')

    for field in ['temperature', 'metallicity']:
        p = yt.ProjectionPlot(
            ds, 'z',
            (gas_type, field), weight_field=(gas_type, 'density'),
            center=hdm_com, width=(10, 'Mpccm'),
            data_source=ad,
        )
        p.set_buff_size(1000)
        p.set_axes_unit('Mpccm')
        p.annotate_timestamp(redshift=True, draw_inset_box=True)
        p.annotate_scale(draw_inset_box=True)
        p.save(f'gas-{field}.png')
        p.frb.save_as_dataset(f'gas-{field}.h5')
