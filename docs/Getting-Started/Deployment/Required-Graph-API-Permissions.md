# Required Graph API Permissions

The below Microsoft Graph API permissions are necessary for the operation of this web app.  

!!! note
    To grant these permissions, you will need to have [Global Administrator](https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#groups-administrator) rights in Azure AD.  

## Permission List

| Permission Name | What it is used for |
|-----------------|---------------------|
| `Application.ReadWrite.All` | Used to create and maintain the app registration used to authenticate users to the API. |
| `User.ReadWrite.All` | Used to create, list, manage, and remove privileged users and retrieve a list of all non-users (and their properties) so that they can be added to security groups and device configurations. |
| `Group.ReadWrite.All` | Used to Manage security group existence and their membership in Azure AD. |
| `AdministrativeUnit.ReadWrite.All` | Used to manage the privileged restricted administrative unit automatically. |
| `Device.ReadWrite.All` | Used to list all AAD devices so that end users can select from a list instead of having to manually put in a GUID. Also used for tagging the extension attribute of the privileged device so that CA can pick it up properly on the hardware enforcement side of things.|
| `DeviceManagementManagedDevices.Read.All` | Used to list all AAD devices so that end users can select from a list instead of having to manually put in a GUID. |
| `DeviceManagementConfiguration.ReadWrite.All` | Used to manage configuration profiles and their assignments in MS Endpoint manager. |
| `DeviceManagementServiceConfig.ReadWrite.All` | Used to manage Autopilot Profiles and read Autopilot device data |
| `DeviceManagementManagedDevices.PrivilegedOperations.All` | Used to issue Wipe commands to devices |
| `DeviceManagementRBAC.ReadWrite.All` | Used to manage the scope tag that the app uses as well as store the app's config in the specified scope tag to eliminate the need for a DB. |
| `RoleManagement.ReadWrite.Directory` | Used to manage role assigned security groups (SGs that can have AAD Roles assigned to them). |
| `Policy.Read.All` and `Policy.ReadWrite.ConditionalAccess` | Used to manage the conditional access policies for individual users during the lifecycle management and for when the initial deployment occurs to implement health checks, and identity partitioning. |

!!! note
    `Policy.Read.All` is necessary due to a known issue with the current Graph API, in the future `Policy.ReadWrite.ConditionalAccess` is all that will be necessary.  
    See this link for Microsoft's official statement: [Microsoft Learn](https://learn.microsoft.com/en-us/graph/known-issues#conditional-access-policy-requires-consent-to-permission)

## `Grant-MIGraphPermission` Usage

The Grant MI Graph Permission PowerShell script is an easy way to bulk apply permissions to managed identities using either the command line or a graphical picker.  
You can find the script here at the [PowerShell gallery](https://www.powershellgallery.com/packages/Grant-MIGraphPermission).
You will need global admin rights or a role/rights that include the following MS GraphAPI permissions to apply the proper permissions to the Managed Identity:

- `Directory.Read.All`
- `AppRoleAssignment.ReadWrite.All`
- `Application.ReadWrite.All`

CLI usage for complete permissions assignment to a MI:

``` PowerShell linenums="1"
.\Grant-MIGraphPermission.ps1 -CLIMode -ObjectID '885c119e-caa1-4148-bc58-20e28ff4f3ce' -PermissionName 'Application.ReadWrite.All', 'User.ReadWrite.All', 'Group.ReadWrite.All', 'AdministrativeUnit.ReadWrite.All', 'Device.ReadWrite.All', 'DeviceManagementManagedDevices.Read.All', 'DeviceManagementConfiguration.ReadWrite.All', 'DeviceManagementServiceConfig.ReadWrite.All', 'DeviceManagementManagedDevices.PrivilegedOperations.All', 'DeviceManagementRBAC.ReadWrite.All', 'RoleManagement.ReadWrite.Directory', 'Policy.Read.All', 'Policy.ReadWrite.ConditionalAccess'
```

Where the parameter `ObjectID`'s value is your Managed Identities' Object ID (GUID).  
`885c119e-caa1-4148-bc58-20e28ff4f3ce` is not a real value, please replace it.

For more information about script usage, please run:

``` PowerShell linenums="1"
Get-Help .\Grant-MIGraphPermission.ps1
```
