#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import numpy as np
import pandas as pd
import yt

import config
import util


ds = util.load_snapshot(n_ref=1024)
ds.index

p = yt.ParticleProjectionPlot(ds, 'z', 'particle_mass')
p.hide_axes()
p.hide_colorbar()
p.set_cmap('particle_mass', 'magma')
p.annotate_scale()
p.annotate_timestamp(redshift=True)

for label, center, r_vir in util.sample_halos(ds):
    print('Plotting', label)
    p.annotate_text(sp.center, label, inset_box_args={'alpha': 0})
    r_vir = r_vir.to('code_length')
    p.annotate_sphere(center, r_vir)
    p.annotate_sphere(center, r_vir * config.ZOOM_REGION_RADIUS,
        circle_args={'ls': 'dashed', 'color': 'white'})
    p.annotate_sphere(center, (1.8, 'Mpc'),
        circle_args={'ls': 'dotted', 'color': 'white'})

p.save(config.LOCATION_PLOT)
