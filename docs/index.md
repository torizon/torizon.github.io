# Torizon OS Layer Documentation

Torizon OS is an embedded Linux distribution for the Torizon platform. It
features, among other essential services, a container runtime and components
for secure remote over-the-air (OTA) updates.

The metadata to build Torizon OS is maintained across two Yocto layers:

| Layer | Role | Repository |
| :-- | :-- | :-- |
| **`meta-torizon`** | The **distro**: distro config, image recipes, OTA/SOTA stack, container runtime, OS policy. | <https://github.com/torizon/meta-torizon> |
| **`meta-torizon-bsp`** | The **BSP adaptations**: machine tuning, bootloader/kernel integration, per-vendor `bbappend`s, wic layouts, setup scripts. Depends on `meta-torizon`. | <https://github.com/torizon/meta-torizon-bsp> |

Together they build two distinct Torizon OS flavors:

- **Torizon** — built on top of Toradex's BSP.
- **Common Torizon** — built on top of BSPs from third parties.

New here, or upgrading from the single `meta-toradex-torizon` layer? See
[Architecture & Migration](architecture-migration.md).

## Building

- To build **Torizon OS** on Toradex hardware, see [Building Torizon OS](building-torizon.md).
- To build **Common Torizon OS** on a third-party board, start from the
  machine-specific guide below.

| SoC Vendor         | Platform / Board                        | Guide                                             | Pre-built images |
| :----------------- | :-------------------------------------- | :------------------------------------------------ | :--------------- |
| Intel              | x86-64                                  | [x86](common-torizon/README-x86.md)               | [Common Torizon OS for x86 Machines](https://developer.toradex.com/software/toradex-embedded-software/toradex-download-links-torizon-linux-bsp-wince-and-partner-demos/#torizon-os-for-x86-machines) |
| NVIDIA             | Jetson Orin Nano                        | [NVIDIA](common-torizon/README-nvidia.md)         | N/A |
| NXP                | i.MX 95 Verdin EVK and FRDM i.MX 93     | [NXP](common-torizon/README-nxp.md)               | One-off images for [i.MX 95 Verdin EVK](https://artifacts.toradex.com/artifactory/legacy-oe-prod-frankfurt/i.MX95_EVKImage-Torizon_OS_7.0.0/) and [FRDM i.MX 93](https://artifacts.toradex.com/artifactory/legacy-oe-prod-frankfurt/i.MX93_FRDM-Torizon_OS_7.5.0/) |
| Renesas            | RZ/V2L EVKIT                            | [Renesas RZ/V2L](common-torizon/README-rzv2l.md)  | N/A |
| STMicroelectronics | STM32MP1 / STM32MP2                     | [STM32MP](common-torizon/README-stm32mp.md)       | N/A |
| Synaptics          | Astra SL1680 / Luna SL1680             | [Synaptics](common-torizon/README-syn.md)         | N/A |
| Texas Instruments  | AM62x/AM62L/AM62P SK EVM and BeagleY-AI | [Texas Instruments](common-torizon/README-ti.md)  | [Common Torizon OS for TI Machines](https://developer.toradex.com/software/toradex-embedded-software/toradex-download-links-torizon-linux-bsp-wince-and-partner-demos/#torizon-os-for-ti-machines) |

## More

- [Contributing](contributing.md)
- [Development Process](development-process.md)
- [Reporting Issues](reporting-issues.md)
- [License](license.md)
