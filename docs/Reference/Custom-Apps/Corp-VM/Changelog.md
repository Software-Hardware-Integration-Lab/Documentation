# Corp VM Changelog

Changes over time to the Corp VM deployment system.

---

## 1.1.0

- Feature: Enable code signing on all scripts and output MSI.
- Feature: Never delete the VHDX when uninstalling/repairing the VM. This preserves the user's data during maintenance.
- Bug: The virtual hard disk was placed in the old Hyper-V folder. (Was placed in public documents instead of program data)
- Bug: If the Untrusted Guardian was not already created, CorpVM creation would fail. This fix now generates an untrusted guardian if it didn't already exist.
- Bug: The PowerShell scripts used to deploy the CorpVM's Hyper-V machine executed out of order from the file creation.

## 1.0.2

- Move shortcut generation out of the MSI's responsibility and into a powershell script since the Advanced Installer system could not handle the type of shortcut necessary.
- Misc. other bug fixes.

## 1.0.1

- Rewrite script to generate the VM instead of importing it to eliminate duplicate serial numbers and other important identifiers.

## 1.0.0

- Initial VM creation (imports VM in-place)
