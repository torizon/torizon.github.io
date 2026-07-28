# Architecture & Migration

Torizon OS used to be built from a single Yocto layer, `meta-toradex-torizon`.
That layer has been **split into two** — `meta-torizon` and `meta-torizon-bsp` —
and its documentation moved to **this centralized site**. This page explains why,
what changed, and how to migrate an existing build.

## Why two layers

`meta-toradex-torizon` had grown to hold two different concerns in one place:

- the definition of **Torizon OS** (distro policy, image composition, OTA, containers); and
- the **board bring-up** needed to run it on each vendor's BSP.

## The two layers and their git lineage

| Layer | Role | Git lineage |
| :-- | :-- | :-- |
| **`meta-torizon`** | The **distro**: what Torizon OS *is*. | The *direct continuation* of `meta-toradex-torizon`: same repository, history continued. All previous branches and tags are intact (e.g. `scarthgap-7.x.y`), so checking out any pre-split ref still gives the monolithic original layer. The BSP content was removed in an ordinary forward commit, no history rewrite. |
| **`meta-torizon-bsp`** | The **BSP adaptations**: what makes a board boot Torizon. | A *pruned clone* of the original: only `master` is kept, its history filtered down to the BSP files (so `git log` on any file still shows its real history), then the distro content dropped. **Depends on `meta-torizon`.** |

No recipe, class, or conf lives in both layers — the **union of the two equals
the pre-split layer**.

## What moved where

| Concern | `meta-torizon` | `meta-torizon-bsp` |
| :-- | :-- | :-- |
| Distro config | `conf/distro/` (all) | — |
| OS policy / composition classes | `torizon.bbclass`, `image_type_*`, `*-signed`, OTA helpers | `toradex-kernel-{config,localversion}.bbclass` |
| Images & init | `recipes-images/`, `recipes-core/images/` | — |
| OTA / SOTA stack | `recipes-sota/` | — |
| Containers | `recipes-containers/` | — |
| OS userland | `recipes-connectivity/`, `-extended/`, `-networking/`, `-devtools/`, `-core/`, most of `-support/` | — |
| Vendor integration | — | `dynamic-layers/` (per-vendor recipes) |
| Machine tuning & templates | — | `conf/machine/`, `conf/template/` |
| Bootloader & kernel | — | `recipes-bsp/`, `recipes-kernel/` |
| Build tooling & wic | — | `scripts/` (`setup-environment`), `files/wic/` |
| Vendor tools & guides | — | `recipes-support/syna-usb-tool`, per-vendor `docs/README-*.md` |

!!! tip "Rule of thumb"
    If it decides *what Torizon OS is*, it's in **`meta-torizon`**. If it adapts a
    *board/BSP* to boot Torizon, it's in **`meta-torizon-bsp`**. A few items that
    look like distro but are board-coupled (WIC layouts, the kernel-version helper
    classes, the Synaptics tool, the vendor guides) deliberately live in the BSP layer.

## How they fit together in a build

```text
        meta-torizon-bsp            (BSP adaptation layer)
               │  LAYERDEPENDS = "meta-torizon"
               │  BBFILES_DYNAMIC → vendor BSP collections
               ▼
          meta-torizon              (distro layer)
               │  LAYERDEPENDS = "sota virtualization-layer"
               ▼
   meta-updater · meta-virtualization · meta-toradex-distro · poky
```

- **`meta-torizon`** — collection `meta-torizon`, priority `90`, depends on
  `sota` + `virtualization-layer`.
- **`meta-torizon-bsp`** — collection `meta-torizon-bsp`, priority `91`, depends
  on `meta-torizon`, and carries the `BBFILES_DYNAMIC` block that activates the
  per-vendor appends.
- Together they **replace** the single `meta-toradex-torizon` entry in
  `bblayers.conf`. The dependency direction is one-way: `meta-torizon-bsp →
  meta-torizon` (the distro never references the BSP layer).

## Migrating your build

Moving an existing `meta-toradex-torizon` build to the split layout:

1. **Clone two repos instead of one.** Wherever you cloned `meta-toradex-torizon`,
   clone both `meta-torizon` and `meta-torizon-bsp`. See
   [Building Torizon OS](building-torizon.md) for the full commands. Note that
   `setup-environment` now lives in **`meta-torizon-bsp/scripts`**.
2. **List both layers in `conf/bblayers.conf`**, replacing the single
   `meta-toradex-torizon` entry.
3. **Update collection-name references** — this is the breaking change. Anything
   that referenced `meta-toradex-torizon` (`bblayers.conf`, `bitbake-layers
   add-layer`, `LAYERDEPENDS`/`LAYERRECOMMENDS` in downstream layers, CI configs,
   TorizonCore Builder) must now point to **`meta-torizon`** and/or
   **`meta-torizon-bsp`**.
4. **Or just use the manifest.** The `toradex-manifest` (`repo init … && repo
   sync`) already fetches both layers in the correct layout.
