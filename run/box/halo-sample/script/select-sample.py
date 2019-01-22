#!/usr/bin/env python
"""Select halo sample."""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

import config

RANDOM_SEED = 42


def remove_boundary_halos(hc, padding=3672, boundary=58480):
    # 3672 = 1800 * 0.68 * (1 + 2)
    for axis in 'XYZ':
        col = f'{axis}c'
        hc = hc[(hc[col] > padding) & (hc[col] < boundary - padding)]
    return hc


# Select sample
candidate = pd.read_csv(config.CANDIDATE)
candidate = remove_boundary_halos(candidate)
x = np.log10(candidate['Mvir'])
y = np.log10(candidate['Menv'])
candidate['i'], xbins = pd.cut(x, [11.8, 12, 12.2], labels=False, retbins=True)
candidate['j'], ybins = pd.qcut(y, 4, labels=False, retbins=True)
sample = candidate.groupby(['i', 'j']).apply(
    lambda df: df.sample(random_state=RANDOM_SEED)
)
label = []
for i, j in zip(sample['i'], sample['j']):
    label += [f'h{i}{j}']
sample['label'] = label
sample = sample[['label', 'Mvir', 'Menv', 'Rvir', 'Xc', 'Yc', 'Zc']]
sample.to_csv(config.SAMPLE, index=False)

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
plt.savefig(config.SELECTION_PLOT, dpi=200)
