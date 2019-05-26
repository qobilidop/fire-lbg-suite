#!/usr/bin/env python
"""Select candidate halos from AHF halo catalogue."""
import pandas as pd
from scipy.spatial import cKDTree


BASE_DIR = Path(__file__).parents[1].resolve()
AHF_HALOS = BASE_DIR / 'data/box/ahf/snapshot_005.AHF_halos'
CAND = BASE_DIR / 'data/halo/candidate.csv'
BOX_SIZE = 58480  # kpc/h
HUBBLE_CONSTANT = 0.68
M_MAX = 10**12.2  # Msun
M_MIN = 10**11.8  # Msun
R_ISO = 3  # Rvir


def read_ahf_halos(path):
    names = []
    with open(path) as f:
        for line in f:
            if line.startswith('#ID'):
                names += line.strip('#').strip().split('\t')
                # Remove the trailing '()' component in column names
                names = [name[:name.find('(')] for name in names]
                break
    df = pd.read_csv(
        path, comment='#', delim_whitespace=True, header=None, names=names
    )
    return df


# Read AHF halo catalog
hc = read_ahf_halos(AHF_HALOS)

# Keep host halos only
hc = hc[hc['hostHalo'] == 0]

# Keep relevant columns only
hc = hc[['Mvir', 'Rvir', 'Xc', 'Yc', 'Zc']]

# Convert mass unit from Msun/h to Msun
hc['Mvir'] /= HUBBLE_CONSTANT

# Keep massive halos only
hc = hc[hc['Mvir'] > M_MIN]

# Mark isolated halos
hc.reset_index(drop=True, inplace=True)
hc['isolated'] = True
tree = cKDTree(hc[['Xc', 'Yc', 'Zc']].values, boxsize=BOX_SIZE)
for i, row in hc.iterrows():
    # Search a spherical region around self for neighbors
    neighbors = tree.query_ball_point(
        row[['Xc', 'Yc', 'Zc']].values, row['Rvir'] * R_ISO
    )
    # Exclude self in neighbors
    neighbors.remove(i)
    for j in neighbors:
        if row['Mvir'] > hc['Mvir'][j]:
            # If neighbor is less massive, neighbor is not isolated
            hc.loc[j, 'isolated'] = False
        else:
            # Otherwise, self is not isolated
            hc.loc[i, 'isolated'] = False

# Keep not too massive halos only
hc = hc[hc['Mvir'] < M_MAX]

# Save candidate table
hc.sort_values(by='Mvir', ascending=False, inplace=True)
hc.reset_index(drop=True, inplace=True)
hc.to_csv(CAND, index=False)
