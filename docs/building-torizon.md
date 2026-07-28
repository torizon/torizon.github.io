# Building Torizon OS

Torizon OS builds in two flavors — **Torizon** (on Toradex hardware) and
**Common Torizon** (on third-party BSPs). Each can be built either with the
`repo` tool and Toradex's manifest (the recommended path) or by cloning the
layers manually. Toradex's own layers — `meta-torizon` and `meta-torizon-bsp` —
are built from the `master` branch.

## Torizon (on Toradex hardware)

### Using `repo` (recommended)

```bash
$ mkdir torizon; cd torizon
$ repo init -u https://git.toradex.com/toradex-manifest.git -b master -m torizon/default.xml
$ repo sync -j 10
```

Then set up the environment and build:

```bash
$ MACHINE=<machine> . setup-environment
$ bitbake torizon-docker
```

For the full walkthrough, see the knowledge-base article:
<https://developer.toradex.com/knowledge-base/build-torizoncore>

### Manual clone

1. Clone the Torizon layers (on `master`) and their dependencies:

    ```bash
    $ git clone https://github.com/torizon/meta-torizon.git -b master
    $ git clone https://github.com/torizon/meta-torizon-bsp.git -b master
    $ git clone https://github.com/uptane/meta-updater.git -b master
    $ git clone https://git.yoctoproject.org/git/meta-virtualization -b master
    ```

    You also need the Toradex BSP layers (`meta-toradex-bsp-common`,
    `meta-toradex-nxp`/`-ti`, poky, meta-openembedded, …). The full set is
    easiest to obtain via the manifest above — see the
    [knowledge-base article](https://developer.toradex.com/knowledge-base/build-torizoncore)
    for the complete list.

2. Source the `setup-environment` script shipped in `meta-torizon-bsp/scripts`
   (the BSP layer owns the build tooling and machine selection).
3. Add **both** `meta-torizon` and `meta-torizon-bsp` (and their dependencies)
   to `conf/bblayers.conf`, set your `MACHINE` in `conf/local.conf`, and set
   `DISTRO='torizon'`.
4. Build an image: `bitbake torizon-docker` (or `torizon-minimal`).

## Common Torizon (on third-party BSPs)

Start with the [machine-specific guide](index.md#building) for your board — each
one lists the exact manifest and flashing steps. The generic paths are below.

### Using `repo` (recommended)

```bash
$ mkdir common-torizon; cd common-torizon
$ repo init -u https://git.toradex.com/toradex-manifest.git -b master -m common-torizon/<vendor>/default.xml
$ repo sync -j 10
```

Replace `<vendor>` with your SoC vendor (e.g. `nxp`, `ti`, `x86`); see the
per-vendor guide for the precise manifest.

### Manual clone

1. Clone the Torizon layers (on `master`) and their dependencies:

    ```bash
    $ git clone https://github.com/torizon/meta-torizon.git -b master
    $ git clone https://github.com/torizon/meta-torizon-bsp.git -b master
    $ git clone https://github.com/uptane/meta-updater.git -b master
    $ git clone https://git.yoctoproject.org/git/meta-virtualization -b master
    ```

    plus your board's vendor BSP layers (see the per-vendor guide).

2. Source `meta-torizon-bsp/scripts/setup-environment` (the BSP layer owns the
   build tooling and machine selection).
3. Add **both** `meta-torizon` and `meta-torizon-bsp` (and their dependencies)
   to `conf/bblayers.conf`, set your `MACHINE`, and set `DISTRO='common-torizon'`.
4. Build one of the available images:

    - `torizon-docker`
    - `torizon-minimal`
    - `torizon-podman` (**experimental**)
