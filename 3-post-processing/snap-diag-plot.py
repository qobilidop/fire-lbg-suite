#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import numpy as np
import yt
from yt.frontends.gizmo.api import GizmoDataset


AXIS = 'z'
FOV = (1, 'Mpccm')
RES = (1000, 1000)
FIELDS = [
    (('gas', 'H_nuclei_density'), 'cm**-3', 1e-5, 1e0, 'cividis', True),
    (('gas', 'temperature'), 'K', 1e2, 1e7, 'hot', True),
    (('gas', 'metallicity'), 'dimensionless', 1e-4, 1e1, 'cool', True),
    (('gas', 'radial_velocity'), 'km/s', -200, 200, 'coolwarm', False),
]


def virial_overdensity(ds):
    cosmo = ds.cosmology
    z = ds.current_redshift
    Om = cosmo.omega_matter
    E = cosmo.expansion_factor(z)
    x = Om * (1 + z) ** 3 / E ** 2 - 1
    od_vir = (18 * np.pi ** 2) + (82 * x) + (39 * x ** 2)
    return ds.quan(od_vir, '')


def virial_radius(ds, m, p, center):
    r = yt.units.yt_array.unorm(p - center, axis=-1)
    r_order = r.v.argsort()
    m_enc = np.empty_like(m)
    m_enc[r_order] = m[r_order].cumsum()
    v_enc = 4*np.pi*r**3 / 3
    od = m_enc / v_enc / ds.critical_density
    od_vir = virial_overdensity(ds)
    r_vir = r[od < od_vir].min()
    return r_vir


def plot_field(dobj, center, width, v_vir, finfo, axis, weight='density'):
    field, unit, zmin, zmax, cmap, log = finfo
    ptype, fname = field
    p = yt.ProjectionPlot(
        dobj.ds, axis, field,
        weight_field=(ptype, weight),
        center=center, width=width, buff_size=RES,
        data_source=dobj
    )
    p.set_unit(field, unit)
    p.set_zlim(field, zmin, zmax)
    p.set_cmap(field, cmap)
    p.set_log(field, log)
    p.set_axes_unit(FOV[1])
    p.annotate_sphere(center, r_vir,
        circle_args={'color': 'white', 'alpha': 0.5})
    p.annotate_timestamp(redshift=True)
    p.annotate_scale()

    p.save(f'{fname}.png', mpl_kwargs={'dpi': 300})
    p.frb.save_as_dataset('frb.h5')


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument(
        '--snapshot', '-s',
        default='~/data/yt/FIRE_M12i_ref11/snapshot_600.hdf5'
    )
    args = parser.parse_args()

    ds = GizmoDataset(Path(args.snapshot).expanduser().resolve())
    _, center = ds.find_min(('PartType1', 'Potential'))
    width = ds.quan(*FOV)
    box = ds.box(center - width / 2, center + width / 2)

    sp = ds.sphere(center, (10, 'kpc'))
    m = sp['all', 'particle_mass']
    v = sp['all', 'particle_velocity']
    box.set_field_parameter('bulk_velocity', np.average(v, weights=m, axis=0))

    m = box['all', 'particle_mass']
    p = box['all', 'particle_position']
    r_vir = virial_radius(ds, m, p, center)

    for finfo in FIELDS:
        plot_field(box, center, width, r_vir, finfo, AXIS)

    sp = ds.sphere(center, r_vir)
    p = yt.ParticlePhasePlot(
        box,
        ('gas', 'H_nuclei_density'),
        ('gas', 'temperature'),
        ('gas', 'mass'),
        x_bins=500,
        y_bins=500,
    )
    p.set_unit('H_nuclei_density', 'cm**-3')
    p.set_unit('temperature', 'K')
    p.set_unit('mass', 'Msun')
    p.set_xlim(1e-5, 1e0)
    p.set_ylim(1e2, 1e7)
    p.annotate_title(f'z = {ds.current_redshift:.2f}')
    p.save('gas-phase.png', mpl_kwargs={'dpi': 300})
