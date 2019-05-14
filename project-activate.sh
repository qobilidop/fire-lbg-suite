. "$("$CONDA_EXE" info --root)"/etc/profile.d/conda.sh
conda activate fire2-lbg

# Locate this directory
if [ -n "$BASH_VERSION" ]; then
    this_file="${BASH_SOURCE[0]}"
elif [ -n "$ZSH_VERSION" ]; then
    this_file="${(%):-%x}"
fi
this_dir="$(dirname "$this_file")"

env_dir="$(cd "$this_dir/.." >/dev/null && pwd)"
export PATH="$env_dir/bin:$PATH"
