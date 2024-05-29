# Changelog

Changes to the security config configuration app.

## 1.4.1

- PowerShell commands are now executed using a Constrained Language mode friendly launch sequence
- Update UI to use new App Installer (MSIX) style UI for system consistency
- Fix a bug where the Execute Disable enforcement was not being set in the boot loader configuration due to missing config binary path

## 1.4.0

- Add SecureBIO enablement for DeviceGuard/Windows Hello
- Add Data Execution Prevention enforcement (execute disable) to boot loader config

## 1.3.1 - Optimize Feature Removal

- Optimize the time that it takes to remove windows features by skipping features that are not currently installed

## 1.3.0 - Windows Feature Removal

- Add Windows Feature Removal automation

## 1.2.1 - LSA PPL Bug Fix

- Fix an issue where the LSA PPL was not enabled properly
- Optimize MSI component structure

## 1.2.0 - Code Sign

- Code sign MSI file
- Code sign PowerShell scripts

## 1.1.2 - Name Update

- Rename app from `SHI AIO config` to `SHI Security Config`
- Move files around in the project to be easier to understand/better organized (internal change)
- Update help/docs link

## 1.1.1 - Firmware Save Bug

- Fix a bug where firmware settings were not being saved correctly

## 1.1.0 - Lenovo Firmware

- Reset firmware to defaults on uninstall
- Disable Thunderbolt support on supported Lenovo devices
- Add Lenovo Firmware Support:
    - ThinkPad P14s Gen 2a

## 1.0.0 - Initial Release

- Autopilot/OOBE system console & Audit Mode disabler flag
- MDE Tagging
- Run LSA as PPL flag
- Strict code sign enforcement (EnableCertPaddingCheck)
- Junk APPX removal (provisioned & user)
- Lenovo Firmware Support:
    - ThinkPad X1 Carbon Gen 10
    - ThinkPad X1 Nano Gen 2
- Enable Windows Features:
    - Hyper-V
    - Windows Sandbox
