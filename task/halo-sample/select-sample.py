#!/usr/bin/env python
"""Select halo sample."""
import os
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import yt

os.chdir(Path(__file__).resolve().parent)

# Load candidates
cand = pd.read_csv('candidates.csv')

# Select sample
x = np.log10(cand['Mvir'])
y = np.log10(cand['Menv'])
cand['i'], xbins = pd.cut(x, [11.8, 12, 12.2], labels=False, retbins=True)
cand['j'], ybins = pd.qcut(y, 4, labels=False, retbins=True)
sample = cand.groupby(['i', 'j']).apply(lambda df: df.sample(random_state=42))
label = []
for i, j in zip(sample['i'], sample['j']):
    label += [f'h{i}{j}']
sample['label'] = label
sample = sample[['label', 'Mvir', 'Menv', 'Rvir', 'Xc', 'Yc', 'Zc']]
sample.to_csv('sample.csv', index=False)
sample = pd.read_csv('sample.csv')

# Plot sample selection
xlim = xbins[[0, -1]]
ylim = ybins[[0, -1]]
plt.scatter(x, y, alpha=0.8, zorder=1)
x = np.log10(sample['Mvir'])
y = np.log10(sample['Menv'])
plt.scatter(x, y, zorder=2)
plt.vlines(xbins, *ylim, color='grey', zorder=0)
plt.hlines(ybins, *xlim, color='grey', zorder=0)
plt.xlim(*xlim)
plt.ylim(*ylim)
plt.xlabel('$\log{M_{vir}}\,\mathrm{[M_\odot]}$')
plt.ylabel('$\log{M(<1.8\,\mathrm{Mpc})}\,\mathrm{[M_\odot]}$')
plt.savefig('sample-selection.png', dpi=200)

# Plot sample location
ds = yt.load('../box/output/snapdir_005/snapshot_005.0.hdf5', n_ref=1024)
p = yt.ParticleProjectionPlot(ds, 'z', 'particle_mass')
p.hide_axes()
p.hide_colorbar()
p.set_cmap('particle_mass', 'magma')
p.annotate_scale()
p.annotate_timestamp(redshift=True)
p.save('result/box.png')
for row in sample.itertuples():
    center = ds.arr([row.Xc, row.Yc, row.Zc], 'kpccm/h')
    r_vir = ds.quan(row.Rvir, 'kpccm/h').to('code_length')
    # p.annotate_text(center, row.label, inset_box_args={'alpha': 0})
    p.annotate_sphere(center, r_vir)
    p.annotate_sphere(center, r_vir*3,
        circle_args={'ls': 'dashed', 'color': 'white'})
    p.annotate_sphere(center, (1.8, 'Mpc'),
        circle_args={'ls': 'dotted', 'color': 'white'})
p.save('sample-location.png')
