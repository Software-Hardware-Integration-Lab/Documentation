# Uninstall Procedure

Removing SHIELD from an Azure tenant is a two step process:
Removing the hosting environment and removing the configurations put in place by the orchestration software.

!!! Danger "Data Loss Warning!!!"
    If you uninstall the architecture, **you will clear out any managed objects and those configurations**, this procedure should only be followed if a SHI employee tells you to do so.
    All data is stored in the architecture itself in the form of Intune Scope Tag, or Entra ID Security Group descriptions.

!!! note
    The Server software doesn't store any data (stateless) and should be safe to reinstall at the same or a newer version.
    Frequently, all that is needed to be done if troubleshooting an existing fresh installation is to uninstall the architecture and run the infrastructure deployment process again.

## Process

It is recommended that the server software be stopped before completing any of the below so that new configurations are not generated during the removal process.

---

### Architecture

The core architecture is the set of settings across all of the managed systems (E.G. M365, Entra ID, Intune, etc.)

1. Download the SHIELD Architecture Uninstall script:
[Uninstall-ShieldArchitecture.ps1](Assets/Scripts/Uninstall-ShieldArchitecture.ps1)

2. Make sure to have no other `Microsoft.Graph` PowerShell Modules installed:

    ``` PowerShell title="Uninstall all Microsoft 365 Graph API PowerShell Modules"
    Get-Module -Name '*Microsoft.Graph*' -ListAvailable | Uninstall-Module
    ```

    !!! note
        You may have to run the above command twice because the order of operations tries to uninstall a dependency first rather than last. Running it the second time will remove the remaining dependency.

3. Install the `Microsoft.Graph.Beta` PowerShell Module:

    ``` PowerShell title="Install Microsoft 365 Graph API Beta Modules"
    Install-Module -Name 'Microsoft.Graph.Beta' -RequiredVersion '2.1.0' -Scope 'AllUsers'
    ```

---

### Server

1. Delete the `SHI-Host` resource group in Azure.

    !!! note
        The resource group may have been renamed during deployment, the default name is `SHI-Host`.

2. Delete the Server's User Login App Registration from Entra ID:
`SHI Orchestration Platform - User Login`

3. (Optional) Delete the Server's Orchestration App Registration from Entra ID:
`SHI Orchestration Platform - Server` or `SHI Orchestration Platform - Self Host`

    !!! note
        The only time step three needs to be done is if you are cleaning up a dev copy or an on-prem hosted version of the app. This doesn't need to be done for an Azure hosted copy since a Managed Identity tied to the App Server is used.
        The Managed Identity would have been deleted along with the server host and software in step 1.
