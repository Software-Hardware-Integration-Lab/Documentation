# Managed Installer Config Changelog

List of changes to the Managed Installer configuration app.

## 1.3.1 - Internal Update

- PowerShell commands are now executed using a Constrained Language mode friendly launch sequence
- Update UI to use new App Installer (MSIX) style UI for system consistency
- Prep work in code to support safe uninstalls
    - Feature not yet available, uninstalls will remove all AppLocker configs

## 1.3.0 - Merge Policy

- Configuring App Locker, merge the policy instead of replacing the policy.
    - This allows for 3rd party configuration without conflict.
- Cycle the IDs of the configured policies so that they are guaranteed unique.
- Update Version numbers for managed installer tracked binaries.

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
