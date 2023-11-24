# Standard Installation

To install MLA, you need to have a copy of the installer, which is distributed in MSI format.
If you do not have an installer, please reach out to us [on our website](https://mootinc.com/contact/){:target="_blank"}.

## Installation Instructions

1. Install the ***latest*** version of PowerShell LTS.

    !!! note "PowerShell Deployment Options"
        We recommend to deploy the [Store](https://www.microsoft.com/store/apps/9MZ1SNWT0N5D){:target="_blank"} version of the PowerShell runtime.

        MSI, WinGet and ZIP files are all also available, see the [docs](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows){:target="_blank"} for more info.

        The `pwsh.exe` binary must registered in the Application Registration system, as described in the [Microsoft Documentation](https://learn.microsoft.com/en-us/windows/win32/shell/app-registration#registering-applications){:target="_blank"}.

        Currently only local user installs of PowerShell are supported for the desktop shortcut. For local machine installs of PowerShell, the CLI is required to run MLA.

2. Run the MLA installer.

3. On the main screen, enter the FQDN of the Azure SQL Server.

    !!! note "Naming Format"
        Replace `*.database.windows.net` with the hostname of your Azure SQL Database Server. The hostname should be the name only, without any protocol specifiers (such as `sql://` or `https://`) or virtual directories.

    ![Screenshot of the installer's main screen.](../assets/images/screenshots/Installer-Dark.png#only-dark){ loading=lazy }
    ![Screenshot of the installer's main screen.](../assets/images/screenshots/Installer-Light.png#only-light){ loading=lazy }

4. (Optional) If you want to configure the `Correlation`, `License Data`, or `Database Name`, select the drop down and chose 'Configure'

    ![Screenshot of the installer's main screen with the dropdown menu visible.](../assets/images/screenshots/Dropdown-Dark.png#only-dark){ loading=lazy }
    ![Screenshot of the installer's main screen with the dropdown menu visible.](../assets/images/screenshots/Dropdown-Light.png#only-light){ loading=lazy }

5. (Optional) Configure the options to match the results you want.

    ![Screenshot of the installer's optional configuration screen.](../assets/images/screenshots/AdvancedConfig-Dark.png#only-dark){ loading=lazy }
    ![Screenshot of the installer's optional configuration screen.](../assets/images/screenshots/AdvancedConfig-Light.png#only-light){ loading=lazy }

6. Press the Install button.

## See Also

- [Getting Started](../Getting-Started.md)
- [Silent Installation](Silent-Installation.md)
