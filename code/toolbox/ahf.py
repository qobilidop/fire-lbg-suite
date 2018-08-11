import pandas as pd


def read_ahf_csv(path):
    """Read .AHF_halos or halo history .dat files."""
    names = []
    with open(path) as f:
        for line in f:
            if 'redshift' in line:
                # For halo history .dat files, the first column is redshift
                names += ['redshift']
            if line.startswith('#ID'):
                names += line.strip('#').strip().split('\t')
                # Remove the trailing '()' component in column names
                names = [name[:name.find('(')] for name in names]
                break
    df = pd.read_csv(path, comment='#', delim_whitespace=True, header=None,
                     names=names)
    return df
