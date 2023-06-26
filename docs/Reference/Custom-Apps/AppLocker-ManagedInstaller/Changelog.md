# Managed Installer Config Changelog

List of changes to the Managed Installer configuration app.

## 1.2.0 - Migrate to Intune API Based Managed Installer

- Remove Intune from the list of managed installers since intune handles itself now
- Remove service management since Intune now does that too

## 1.1.1 - Maintenance

- Update the version number for the Intune's Managed Installer
- Update the friendly names for all managed installers to make them easier to understand

## 1.1.0 - Teams and Edge Updaters

- Add Microsoft Teams Updater as a Managed Installer
- Add Microsoft Edge Updater as a Managed Installer

## 1.0.0 - Initial Release

- Intune set as managed installer
- On uninstall, remove all managed installer configurations
