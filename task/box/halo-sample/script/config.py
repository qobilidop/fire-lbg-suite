from pathlib import Path

WORK_DIR = Path(__file__).resolve().parent.parent

# External paths
HALO_CATALOG = WORK_DIR / '../ahf/snapshot_005.AHF_halos'
IC = WORK_DIR / '../initial_condition/ic_L86_ref10.0'
SNAPSHOT = WORK_DIR / '../output/snapdir_005/snapshot_005.0.hdf5'

# Internal paths
CANDIDATE = WORK_DIR / 'candidate.csv'
LOCATION_PLOT = WORK_DIR / 'sample-location.png'
SAMPLE = WORK_DIR / 'sample.csv'
SELECTION_PLOT = WORK_DIR / 'sample-selection.png'
ZOOM_REGION = WORK_DIR / 'zoom-region'

# Parameters
ZOOM_REGION_RADIUS = 3
