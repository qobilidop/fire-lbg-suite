# Only Bash and Zsh are supported
if [ -n "$BASH_VERSION" ]; then
    this_file="${BASH_SOURCE[0]}"
elif [ -n "$ZSH_VERSION" ]; then
    this_file="${(%):-%x}"
fi
export PROJECT_ACTIVATE="$this_file"
this_dir="$(dirname "$this_file")"
PROJECT_ROOT="$(cd "$this_dir/.." >/dev/null && pwd)"

source ~/gizenv/bin/gizenv-activate.sh
export PATH="$PROJRCT_ROOT/script:$PATH"
