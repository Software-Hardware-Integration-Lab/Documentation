# Required Permissions

The below permissions are necessary for the operation of this web app.

## End User Permissions

The below permissions are required to be assigned to the user that is doing the installation of SHIELD itself.
The permission(s) are not assigned to the service principal.

| Permission Name        | What it is used for                                                                                                                                                                           |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Global Administrator` | To use the SHIELD installer link and install SHIELD into the Azure tenant. For more information, see [Setup Steps/Requirements](/SHIELD/Prerequisites/Installation/#setup-stepsrequirements). |

---

## SHIELD's Service Principal

Permissions listed below are assigned directly to the service principal that SHIELD uses to orchestrate/audit.

!!! info
    A service principal is a non-human user, such as managed identity or app registration. It is highly recommended to use a Managed Identity.

Permissions that can't be self auto granted are automatically granted by SHIELD - Desktop's installer module.

!!! note
    The permission marked with '✅' are assigned by SHIELD to itself. Permissions marked as '❌' have to be assigned by an admin ahead of time.

### Entra ID Role Assignments

=== "Normal Mode"
    | Permission Name | Self Auto Granted | What it is used for |
    |-----------------|-------------------|---------------------|
    | [`Privileged Authentication Administrator`](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#privileged-authentication-administrator){:target="_blank"} | ✅ | Used to delete privileged users as they have a privileged role lockout. The Graph API requires a [sensitive permission](https://learn.microsoft.com/en-us/graph/api/resources/users?view=graph-rest-beta#who-can-perform-sensitive-actions) assigned to the principal [doing the API call](https://learn.microsoft.com/en-us/graph/api/user-delete?view=graph-rest-1.0&tabs=http#permissions). |

=== "Discover"
    None required

=== "Discover Self Delete"
Coming Soon!

### Microsoft Graph API

=== "Normal Mode"
    | Permission Name | Self Auto Granted | What it is used for |
    |-----------------|-------------------|---------------------|
    | [`AppRoleAssignment.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#approleassignmentreadwriteall){:target="_blank"} | ❌ | Used by the settings and update engine to update the permissions of the Azure App Service's Managed Identity to support new functionality in future updates or on initial startup. All permissions assigned will align with this page. If they do not and you are on the latest version, stop the app and contact us. |
    | [`Application.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#applicationreadwriteall){:target="_blank"} | ❌ | Used to create and maintain the app registration used to authenticate users to the API. Additionally used by the settings and update engine on permission assignment to convert app id and template IDs to tenant localized object IDs. |
    | [`AccessReview.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#accessreviewreadall){:target="_blank"} | ✅ | Used in Discover to read the access reviews that are configured in the tenant. |
    | [`AdministrativeUnit.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#administrativeunitreadwriteall){:target="_blank"} | ✅ | Used to manage the privileged restricted administrative unit automatically. |
    | [`Device.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#devicereadwriteall){:target="_blank"} | ✅ | Used to list all Entra ID devices so that end users can select from a list instead of having to manually put in a GUID. Also used for tagging the extension attribute of the privileged device so that CA can pick it up properly on the hardware enforcement side of things.|
    | [`DeviceManagementApps.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#devicemanagementappsreadwriteall){:target="_blank"} | ✅ | Used to set Intune as a Managed Installer for App Control for Business for all devices managed by Intune. |
    | [`DeviceManagementConfiguration.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#devicemanagementconfigurationreadwriteall){:target="_blank"} | ✅ | Used to manage configuration profiles and their assignments in Intune. |
    | [`DeviceManagementManagedDevices.PrivilegedOperations.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#devicemanagementmanageddevicesprivilegedoperationsall){:target="_blank"} | ✅ | Used to issue Wipe commands to devices |
    | [`DeviceManagementManagedDevices.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#devicemanagementmanageddevicesreadwriteall){:target="_blank"} | ✅ | Used to list all Entra ID devices so that end users can select from a list instead of having to manually put in a GUID. Also used in Intermediary management to remove old session hosts for AVD. |
    | [`DeviceManagementRBAC.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#devicemanagementrbacreadwriteall){:target="_blank"} | ✅ | Used to manage the scope tag that the app uses as well as store the app's config in the specified scope tag to eliminate the need for a DB. |
    | [`DeviceManagementServiceConfig.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#devicemanagementserviceconfigreadwriteall){:target="_blank"} | ✅ | Used to manage Autopilot Profiles and read Autopilot device data |
    | [`Directory.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#directoryreadall){:target="_blank"} | ✅ | Used to be able to read directory objects such as users, group, devices, service principals, and their configurations. |
    | [`EntitlementManagement.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#entitlementmanagementreadall){:target="_blank"} | ✅ | Used in Discover to read the entitlement lifecycle management system's configurations such as access packages. |
    | [`Group.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#groupreadwriteall){:target="_blank"} | ✅ | Used to Manage security group existence and their membership in Entra ID. |
    | [`IdentityRiskEvent.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#identityriskeventreadall){:target="_blank"} | ✅ | Used in Discover to evaluate the license liability for Entra ID Identity Protection. |
    | [`IdentityRiskyUser.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#identityriskyuserreadall){:target="_blank"} | ✅ | Used in Discover to evaluate the license liability for Entra ID Identity Protection. |
    | [`Policy.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#policyreadall){:target="_blank"} and [`Policy.ReadWrite.ConditionalAccess`](https://learn.microsoft.com/en-us/graph/permissions-reference#policyreadwriteconditionalaccess){:target="_blank"} | ✅ | Used to manage the conditional access policies for individual users during the lifecycle management and for when the initial deployment occurs to implement health checks, and identity partitioning. |
    | [`SecurityIdentitiesAccount.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#securityidentitiesaccountreadall){:target="_blank"} | ✅ | Used in Discover to measure the Defender for Identity license lability. |
    | [`RoleManagement.ReadWrite.Directory`](https://learn.microsoft.com/en-us/graph/permissions-reference#rolemanagementreadwritedirectory){:target="_blank"} | ✅ | Used to manage role assigned security groups (SGs that can have Entra ID Roles assigned to them). |
    | [`User.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadwriteall){:target="_blank"} | ✅ | Used to create, list, manage, and remove privileged users and retrieve a list of all non-users (and their properties) so that they can be added to security groups and device configurations. |

=== "Discover"
    | Permission Name | Self Auto Granted | What it is used for |
    |-----------------|-------------------|---------------------|
    | [`AppRoleAssignment.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#approleassignmentreadwriteall){:target="_blank"} | ❌ | Used by the settings and update engine to update the permissions of the Azure App Service's Managed Identity to support new functionality in future updates or on initial startup. All permissions assigned will align with this page. If they do not and you are on the latest version, stop the app and contact us. |
    | [`Application.ReadWrite.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#applicationreadwriteall){:target="_blank"} | ❌ | Used to create and maintain the app registration used to authenticate users to the API. Additionally used by the settings and update engine on permission assignment to convert app id and template IDs to tenant localized object IDs. |
    | [`AccessReview.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#accessreviewreadall){:target="_blank"} | ✅ | Used in Discover to read the access reviews that are configured in the tenant. |
    | [`Directory.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#directoryreadall){:target="_blank"} | ✅ | Used in Discover to be able to read directory objects such as users, group, devices, service principals, and their configurations. |
    | [`EntitlementManagement.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#entitlementmanagementreadall){:target="_blank"} | ✅ | Used in Discover to read the entitlement lifecycle management system's configurations such as access packages. |
    | [`IdentityRiskEvent.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#identityriskeventreadall){:target="_blank"} | ✅ | Used in Discover to evaluate the license liability for Entra ID Identity Protection. |
    | [`IdentityRiskyUser.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#identityriskyuserreadall){:target="_blank"} | ✅ | Used in Discover to evaluate the license liability for Entra ID Identity Protection. |
    | [`Policy.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#policyreadall){:target="_blank"} and [`Policy.Read.ConditionalAccess`](https://learn.microsoft.com/en-us/graph/permissions-reference#policyreadwriteconditionalaccess){:target="_blank"} | ✅ | Used to read conditional access policy configurations. Conditional access policy reading is not included in `Directory.Read.All` |
    | [`RoleAssignmentSchedule.ReadWrite.Directory`](https://learn.microsoft.com/en-us/graph/permissions-reference#roleassignmentschedulereadwritedirectory){:target="_blank"} | ✅ | Used for reading PIM-based long term role assignments. Also needs `RoleManagement.Read.All` as a supporting permission otherwise permission errors occur. |
    | [`RoleEligibilitySchedule.ReadWrite.Directory`](https://learn.microsoft.com/en-us/graph/permissions-reference#roleeligibilityschedulereadwritedirectory){:target="_blank"} | ✅ | Used for reading eligible PIM role assignments. Also needs `RoleManagement.Read.All` as a supporting permission otherwise permission errors occur. |
    | [`RoleManagement.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#rolemanagementreadall){:target="_blank"} | ✅ | Used for reading all PIM roles. |
    | [`RoleManagementPolicy.Read.Directory`](https://learn.microsoft.com/en-us/graph/permissions-reference#rolemanagementpolicyreaddirectory){:target="_blank"} | ✅ | Used to read approver configurations in PIM. |
    | [`SecurityIdentitiesAccount.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#securityidentitiesaccountreadall){:target="_blank"} | ✅ | Used in Discover to measure the Defender for Identity license lability. |

=== "Discover Self Delete"
Coming Soon!

!!! note
    `Policy.Read.All` is necessary due to a known issue with the current Graph API, in the future `Policy.ReadWrite.ConditionalAccess`/`Policy.Read.ConditionalAccess` will be all that is necessary.
    See this link for Microsoft's official statement: [Graph API Known Issues Portal](https://developer.microsoft.com/en-us/graph/known-issues/?search=13671)

### SHI - Data Gateway

=== "Normal Mode"
    | Permission Name | Self Auto Granted | What it is used for |
    |-----------------|-------------------|---------------------|
    | `LicenseReport.ReadWrite` | ✅ | Used to store the license report after a run of Discover has completed.  |
    | `Telemetry.Shield.ReadWrite` | ✅ | Used by SHIELD to store its monthly telemetry report and keep it isolated from other tenants. |
    | `UpdateShield.Check` | ✅ | Used by SHIELD to check for updates. |

=== "Discover"
    | Permission Name           | Self Auto Granted | What it is used for                                                      |
    |---------------------------|-------------------|--------------------------------------------------------------------------|
    | `LicenseReport.ReadWrite` | ✅                | Used to store the license report after a run of Discover has completed.  |
    | `UpdateShield.Check`      | ✅                | Used by SHIELD to check for updates.                                     |

=== "Discover Self Delete"
Coming Soon!

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

---

## See Also

- [Discover Only mode](../Reference/Settings/Environmental-Variables-Reference.md#shield_operationmode)
