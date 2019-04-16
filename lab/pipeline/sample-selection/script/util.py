import pandas as pd
import yt

import config


def load_ic(**yt_load_kwargs):
    # Add some padding to bbox to avoid domain overflow issue
    eps = 1e-10
    boundary = 58480
    bbox = [[-eps, boundary + eps]] * 3
    return yt.load(str(config.IC), bounding_box=bbox, **yt_load_kwargs)


def load_snapshot(**yt_load_kwargs):
    return yt.load(str(config.SNAPSHOT), **yt_load_kwargs)


def sample_halos(ds):
    sample = pd.read_csv(config.SAMPLE)
    for row in sample.itertuples():
        label = row.label
        center = ds.arr([row.Xc, row.Yc, row.Zc], 'kpccm/h')
        r_vir = ds.quan(row.Rvir, 'kpccm/h')
        yield label, center, r_vir
