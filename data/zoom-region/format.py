import numpy as np
import pandas as pd


for i in range(2):
    for j in range(4):
        path = f'h{i}{j}-box-rad4.txt'
        df = pd.read_csv(path, delim_whitespace=True, names=['x', 'y', 'z'])
        pos = df.to_numpy()
        np.savetxt(path, pos, fmt='%.8f')
