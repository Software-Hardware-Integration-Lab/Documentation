# File Changes

The security config app changes files on the local computer.

Below are the list of changes and why they are changed:

| File Path | Reason for Change |
|-----------|-------------------|
| `WindowsFolder\Setup\Scripts\DisableCMDRequest.TAG` | Prevent users from popping a shell by using `Shift+F10` or dropping into audit mode via `Ctrl+Shift+F3` during OOBE/Autopilot |
