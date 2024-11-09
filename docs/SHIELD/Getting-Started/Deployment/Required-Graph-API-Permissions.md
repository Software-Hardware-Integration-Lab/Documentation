# Required Graph API Permissions

The below Microsoft Graph API permissions are necessary for the operation of this web app.

!!! note
    The permission marked with '✅' are assigned by SHIELD to itself. Permissions marked as '❌' have to be assigned by an admin ahead of time.

## Entra ID Role Permission List

| Permission Name | Self Auto Granted | What it is used for |
|-----------------|-------------------|---------------------|
|`User Administrator` | ✅ | Used to delete privileged users as they have a privileged role lockout. The Graph API requires a [sensitive permission](https://learn.microsoft.com/en-us/graph/api/resources/users?view=graph-rest-beta#who-can-perform-sensitive-actions) assigned to the principal [doing the API call](https://learn.microsoft.com/en-us/graph/api/user-delete?view=graph-rest-1.0&tabs=http#permissions). |

## Graph API Permission List

| Permission Name | Self Auto Granted | What it is used for |
|-----------------|-------------------|---------------------|
| `AdministrativeUnit.ReadWrite.All` | ✅ | Used to manage the privileged restricted administrative unit automatically. |
| `AppRoleAssignment.ReadWrite.All` | ❌ | Used by the update/health engine to update the permissions of the Azure App Service's Managed Identity to support new functionality in future updates. All permissions assigned will align with this page. If they do not and you are on the latest version, stop the app and contact us. |
| `Application.ReadWrite.All` | ❌ | Used to create and maintain the app registration used to authenticate users to the API. |
| `Device.ReadWrite.All` | ✅ | Used to list all Entra ID devices so that end users can select from a list instead of having to manually put in a GUID. Also used for tagging the extension attribute of the privileged device so that CA can pick it up properly on the hardware enforcement side of things.|
| `DeviceManagementApps.ReadWrite.All` | ✅ | Used to set Intune as a Managed Installer for WDAC for all devices managed by Intune. |
| `DeviceManagementConfiguration.ReadWrite.All` | ✅ | Used to manage configuration profiles and their assignments in Intune. |
| `DeviceManagementManagedDevices.PrivilegedOperations.All` | ✅ | Used to issue Wipe commands to devices |
| `DeviceManagementManagedDevices.ReadWrite.All` | ✅ | Used to list all Entra ID devices so that end users can select from a list instead of having to manually put in a GUID. Also used in Intermediary management to remove old session hosts for AVD. |
| `DeviceManagementRBAC.ReadWrite.All` | ✅ | Used to manage the scope tag that the app uses as well as store the app's config in the specified scope tag to eliminate the need for a DB. |
| `DeviceManagementServiceConfig.ReadWrite.All` | ✅ | Used to manage Autopilot Profiles and read Autopilot device data |
| `Group.ReadWrite.All` | ✅ | Used to Manage security group existence and their membership in Entra ID. |
| `Policy.Read.All` and `Policy.ReadWrite.ConditionalAccess` | ✅ | Used to manage the conditional access policies for individual users during the lifecycle management and for when the initial deployment occurs to implement health checks, and identity partitioning. |
| `RoleManagement.ReadWrite.Directory` | ✅ | Used to manage role assigned security groups (SGs that can have Entra ID Roles assigned to them). |
| `User.ReadWrite.All` | ✅ | Used to create, list, manage, and remove privileged users and retrieve a list of all non-users (and their properties) so that they can be added to security groups and device configurations. |

## SHI Data Gateway Permissions List

| Permission Name | Self Auto Granted | What it is used for |
|-----------------|-------------------|---------------------|
| `LicenseReport.ReadWrite` | ✅ | Used to store the license report after a run of License Analytics has completed. |
| `Telemetry.Sop.ReadWrite` | ✅ | Used by SOP to store its monthly telemetry report and keep it isolated from other tenants. |

## SHI Orchestration Platform - Authenticator Permissions List

| Permission Name | Self Auto Granted | What it is used for |
|-----------------|-------------------|---------------------|
| `Authenticator.Attest` | ✅ | Used to prove that the SOP is not a threat actor and to home to the correct tenant when requesting SCC auth credentials. |

!!! note
    `Policy.Read.All` is necessary due to a known issue with the current Graph API, in the future `Policy.ReadWrite.ConditionalAccess` will be all that is necessary.
    See this link for Microsoft's official statement: [Graph API Known Issues Portal](https://developer.microsoft.com/en-us/graph/known-issues/?search=13671)

## `Grant-MIGraphPermission` Usage

The Grant MI Graph Permission PowerShell script is an easy way to bulk apply permissions to managed identities using either the command line or a graphical picker.
You can find the script here at the [PowerShell gallery](https://www.powershellgallery.com/packages/Grant-MIGraphPermission).
You will need global admin rights or a role/rights that include the following MS GraphAPI permissions to apply the proper permissions to the Managed Identity:

- `Directory.Read.All`
- `AppRoleAssignment.ReadWrite.All`
- `Application.ReadWrite.All`

CLI usage for complete permissions assignment to a MI:

``` PowerShell title="PowerShell"
.\Grant-MIGraphPermission.ps1 -CLIMode -ObjectID '885c119e-caa1-4148-bc58-20e28ff4f3ce' -PermissionName 'Application.ReadWrite.All', 'AppRoleAssignment.ReadWrite.All'
```

Where the parameter `ObjectID`'s value is your Managed Identities' Object ID (GUID).  
`885c119e-caa1-4148-bc58-20e28ff4f3ce` is not a real value, please replace it.

For more information about script usage, please run:

``` PowerShell title="PowerShell"
Get-Help .\Grant-MIGraphPermission.ps1
```
