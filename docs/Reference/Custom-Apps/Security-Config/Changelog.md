# Security Config Changelog

Changes to the security config configuration app.

## 1.2.1 - LSA PPL Bug Fix

- Fix an issue where the LSA PPL was not enabled properly
- Optimize MSI component structure

## 1.2.0 - Code Sign

- Code sign MSI file
- Code sign PowerShell scripts

## 1.1.2 - Name Update

- Rename app from `Moot AIO config` to `Moot Security Config`
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
