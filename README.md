# Torizon OS docs

Test deployment of the **unified Torizon OS layer documentation** site. It
renders as the real Torizon docs but is hosted on a personal GitHub Pages user
site: <https://torizon.github.io/>

The production design lives across three repos:

- [`meta-torizon`](https://github.com/torizon/meta-torizon) — the distro layer
- [`meta-torizon-bsp`](https://github.com/torizon/meta-torizon-bsp) — the BSP adaptations
- a dedicated docs repo (this one, in production `torizon-docs`) that owns the
  shared prose and aggregates each layer's own docs into one site.

## Test vs. production

- **This test repo is self-contained.** The per-vendor Common Torizon guides
  under `docs/common-torizon/` are a **committed snapshot** so the site builds
  and deploys without depending on the layer repos.
- **In production**, those guides stay canonical in `meta-torizon-bsp/docs/` and
  are pulled in at build time (git submodules + `scripts/sync-external-docs.sh`),
  so nothing is duplicated in version control. The sync script is kept here for
  regenerating the snapshot locally.

## Build locally

```bash
python3 -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
mkdocs serve            # http://127.0.0.1:8000
```

To regenerate the per-vendor snapshot from sibling clones of the layer repos:

```bash
./scripts/sync-external-docs.sh   # reads ../meta-torizon-bsp/docs, etc.
```

`mkdocs build --strict` is what CI runs; it fails on any broken link or missing
nav target.
