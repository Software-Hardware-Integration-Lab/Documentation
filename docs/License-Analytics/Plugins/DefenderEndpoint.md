# Defender for Endpoint

When interpreting the MDE plugin's results in the `License Data` table, a result that has a 0 count of available licenses could mean that no license is present even if a record is present that represents the license.
This is because the license data is coming from MDE and not the licensing system. We do this because MDE could be enabled without a corresponding license. E.g. Defender for Cloud for Servers.

## Licenses Checked

- Defender for Business (SMB)
- Defender for Endpoint P1
- Defender for Endpoint P2
- Defender Vulnerability Management Standalone
- Defender Vulnerability Management Addon
