#!/usr/bin/env python
import numpy as np

from giztool.sim.misc import trace_region_chull

import config
import util


ds_ic = util.load_ic()
ds_ic.index
ic = ds_ic.all_data()
ds = util.load_snapshot()
ds.index

config.ZOOM_REGION.mkdir(parents=True, exist_ok=True)
for label, center, r_vir in util.sample_halos(ds):
    print('Processing', label)
    radius = config.ZOOM_REGION_RADIUS
    sp = ds.sphere(center, r_vir * radius)
    vertices = trace_region_chull(sp, ic)
    path = config.ZOOM_REGION / f'{label}_rad{radius}.txt'
    np.savetxt(path, vertices)
