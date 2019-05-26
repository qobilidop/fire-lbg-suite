#!/usr/bin/env python
"""Select sample halos from candidate halos."""
from pathlib import Path

import numpy as np
import pandas as pd


BASE_DIR = Path(__file__).parents[1].resolve()
CAND = BASE_DIR / 'data/halo/candidate.csv'
XBINS = BASE_DIR / 'data/halo/xbins.txt'
YBINS = BASE_DIR / 'data/halo/ybins.txt'
SAMPLE = BASE_DIR / 'data/halo/sample.csv'
M_MIN = 10**11.8  # Msun
M_MAX = 10**12.2  # Msun
RANDOM_SEED_1 = 42
RANDOM_SEED_2 = 3


# Read candidate halo catalog
hc = pd.read_csv(CAND)

# Select isolated halos
hc = hc[hc['isolated']]

# Select sample
x = np.log10(hc['Mvir'].values)
y = np.log10(hc['Menv'].values)
x_min, x_max = np.log10(M_MIN), np.log10(M_MAX)
i, xbins = pd.cut(x, np.linspace(x_min, x_max, 3), labels=False, retbins=True)
j, ybins = pd.qcut(y, 4, labels=False, retbins=True)
hc = hc.assign(i=i)
hc = hc.assign(j=j)
sample = hc.groupby(['i', 'j']).apply(
    lambda df: df.sample(random_state=RANDOM_SEED_1)
)

# Reroll the dice for h12 and h13, which are too massive to finish
# realistically with the computing resources available
sample_again = hc.groupby(['i', 'j']).apply(
    lambda df: df.sample(random_state=RANDOM_SEED_2)
)
for i in [6, 7]:
    sample.iloc[i] = sample_again.iloc[i]

# Name the halos
names = []
for i, j in zip(sample['i'], sample['j']):
    names += [f'h{i}{j}']
sample['name'] = names

# Save outputs
np.savetxt(XBINS, xbins)
np.savetxt(YBINS, ybins)
sample = sample[['name', 'Mvir', 'Menv', 'Rvir', 'Xc', 'Yc', 'Zc']]
sample.to_csv(SAMPLE, index=False)
