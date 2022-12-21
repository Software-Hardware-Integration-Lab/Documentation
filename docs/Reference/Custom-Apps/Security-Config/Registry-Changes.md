# Registry Changes

The security config app changes registry keys on the local computer.

Below are the list of changes and why they are changed:

=== "PowerShell"
    | Key Path | Reason for Change |
    |----------|-------------------|
    | `HKLM:\Software\Microsoft\Cryptography\Wintrust\Config` | Prevent users from popping a shell by using `Shift+F10` or dropping into audit mode via `Ctrl+Shift+F3` during OOBE/Autopilot |

=== "Registry Editor (Regedit)"
    | Key Path | Reason for Change |
    |----------|-------------------|
    | `HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Wintrust\Config` | Prevent users from popping a shell by using `Shift+F10` or dropping into audit mode via `Ctrl+Shift+F3` during OOBE/Autopilot |
