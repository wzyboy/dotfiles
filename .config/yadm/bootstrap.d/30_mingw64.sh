#!/bin/bash -

set -euo pipefail

if [[ "${MSYSTEM:-}" != "MINGW64" ]]; then
  exit 0
fi

PAIRS=(
  "$HOME/.config/nvim|$HOME/AppData/Local/nvim"
  "$HOME/.config/yazi|$HOME/AppData/Roaming/yazi/config"
  "$HOME/.config/ruff|$HOME/AppData/Roaming/ruff"
)

for pair in "${PAIRS[@]}"; do
  IFS='|' read -r _target _link <<< "$pair"

  target=$(cygpath -w $_target)
  link=$(cygpath -w $_link)

  if [[ -e "$link" ]]; then
    echo "[skip] $link already exists"
    continue
  fi

  mkdir -p "$(dirname "$link")" "$target"
  echo "[mklink] $link -> $target"
  cmd //c mklink //J $link $target
done
