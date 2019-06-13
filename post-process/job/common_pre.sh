set -e
module list
eval "$ENV_ACTIVATE"
set -x
pwd
date
date_start="$(date)"
