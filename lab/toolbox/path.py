from itertools import product
from pathlib import Path


PROJECT_DIR = Path(__file__).parents[1].resolve()
RUN_DIR = PROJECT_DIR / 'run'


class Simulation:
    def __init__(self, name):
        self.name = name
        self.dir = RUN_DIR / f'z2m12_{name}_ref13_pilot'
        self.snaps = [Snapshot(self, snap_id)
                      for snap_id in reversed(range(173))]


class Snapshot:
    def __init__(self, sim, snap_id):
        self.sim = sim
        self.id = snap_id
        self.file = (
            sim.dir / 'output' / f'snapdir_{snap_id:03d}' /
            f'snapshot_{snap_id:03d}.0.hdf5'
        )


SIMS = [Simulation(f'h{i}{j}') for i, j in product(range(2), range(4))]
