#!/usr/bin/env bash
#
# Aggregate the layer-specific docs from the meta-torizon / meta-torizon-bsp
# submodules into the MkDocs tree. The copied files are BUILD ARTIFACTS and are
# git-ignored (see .gitignore) -- the canonical source stays in each layer repo,
# so there is a single source of truth and nothing to drift.
#
# Sources are resolved in this order:
#   1. $BSP_DIR / $DISTRO_DIR env overrides
#   2. ./external/<name>            (git submodules, used in CI)
#   3. ../<name>                    (sibling clones, convenient for local dev)
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

resolve() {
  local name="$1" override="$2"
  if [ -n "$override" ]; then echo "$override"; return; fi
  if [ -d "$ROOT/external/$name/docs" ]; then echo "$ROOT/external/$name"; return; fi
  if [ -d "$ROOT/../$name/docs" ]; then echo "$ROOT/../$name"; return; fi
  echo "ERROR: could not locate '$name' (checked external/ and ../). " \
       "Run 'git submodule update --init --recursive' or set ${name}_DIR." >&2
  exit 1
}

BSP="$(resolve meta-torizon-bsp "${BSP_DIR:-}")"
DISTRO="$(resolve meta-torizon "${DISTRO_DIR:-}")"

# Per-vendor Common Torizon guides live in the BSP layer.
mkdir -p "$ROOT/docs/common-torizon"
cp "$BSP"/docs/README-*.md "$ROOT/docs/common-torizon/"

# Any distro-specific build notes that later land in meta-torizon/docs get
# pulled in here too (optional; ignored if absent).
if [ -f "$DISTRO/docs/building-torizon.md" ]; then
  cp "$DISTRO/docs/building-torizon.md" "$ROOT/docs/building-torizon.md"
fi

echo "Synced per-vendor guides from: $BSP/docs"
echo "Distro source: $DISTRO/docs"
