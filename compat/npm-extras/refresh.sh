#!/usr/bin/env bash
set -euo pipefail

SCRIPT="$(cat <<EOH
node2nix --nodejs-14 --input ./node_modules.json
EOH
)"

cd "${BASH_SOURCE[0]%/*}"

nix-shell -p nodePackages.node2nix --run "$SCRIPT"


