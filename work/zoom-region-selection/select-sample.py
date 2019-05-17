#!/usr/bin/env python
"""Process AHF halos to filter out a short list of interested halos."""
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

import lib.mplstyle


CAND_FILE = 'data/halo/candidate.csv'
MENV_FILE = 'data/halo/menv.csv'
OUTPUT = 'data/halo/sample.csv'
PLOT = 'asset/sample-selection.pdf'
M_MAX = 10**12.2  # Msun
M_MIN = 10**11.8  # Msun
RANDOM_SEED_1 = 42
RANDOM_SEED_2 = 3


if __name__ == '__main__':
    # Read input
    host = pd.read_csv(CAND_FILE)
    menv = pd.read_csv(MENV_FILE)
    host['Menv'] = menv['Menv']

    # Keep isolated halos only
    isolated = host[host['isolated']]

    # Select sample
    x = np.log10(isolated['Mvir'].values)
    y = np.log10(isolated['Menv'].values)
    x_min, x_max = np.log10(M_MIN), np.log10(M_MAX)
    i, xbins = pd.cut(x, np.linspace(x_min, x_max, 3), labels=False, retbins=True)
    j, ybins = pd.qcut(y, 4, labels=False, retbins=True)
    isolated = isolated.assign(i=i)
    isolated = isolated.assign(j=j)
    sample = isolated.groupby(['i', 'j']).apply(
        lambda df: df.sample(random_state=RANDOM_SEED_1)
    )

    # Reroll the dice for h12 and h13, which are too massive to finish
    # realistically with the computing resources we have
    sample_again = isolated.groupby(['i', 'j']).apply(
        lambda df: df.sample(random_state=RANDOM_SEED_2)
    )
    for i in [6, 7]:
        sample.iloc[i] = sample_again.iloc[i]

    # Name the halos
    names = []
    for i, j in zip(sample['i'], sample['j']):
        names += [f'h{i}{j}']
    sample['name'] = names

    # Save output
    sample = sample[['name', 'Mvir', 'Menv', 'Rvir', 'Xc', 'Yc', 'Zc']]
    sample.to_csv(OUTPUT, index=False)

    # Make plot
    plt.scatter(
        np.log10(host['Mvir']), np.log10(host['Menv']),
        label='host', marker='+', color='k', alpha=0.5, zorder=1
    )
    plt.scatter(
        np.log10(isolated['Mvir']), np.log10(isolated['Menv']),
        label='isolated', marker='o', facecolors='none', edgecolors='k',
        alpha=0.5, zorder=2
    )
    plt.scatter(
        np.log10(sample['Mvir']), np.log10(sample['Menv']),
        label='sample', marker='x', color='r', zorder=3
    )
    xlim = xbins[[0, -1]]
    ylim = ybins[[0, -1]]
    plt.vlines(xbins, *ylim, color='grey', zorder=0)
    plt.hlines(ybins, *xlim, color='grey', zorder=0)
    plt.xlim(*xlim)
    plt.ylim(*ylim)
    plt.xlabel('$\log{M_{vir}/M_\odot}$')
    plt.ylabel('$\log{M(<1.8\,\mathrm{Mpc})/M_\odot}$')
    plt.legend()
    plt.savefig(PLOT)
