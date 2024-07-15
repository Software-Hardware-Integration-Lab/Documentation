# Environmental Variable Reference

Environmental variables are used to configure core behaviors/configurations of the server software.

The configurations are exposed as environmental variables rather than config files or registry keys to provide maximum support for wherever the server is hosted.
Config files don't work well in serverless environments where the state should not change, and the registry is only available on Windows.
Serverless, Windows, and Linux all share a common option: Environmental Variables. This works equally well across all of them.

Below is a list of all environmental variable configurations that the server can use. There are data format examples and descriptions so that you are not going blind to what a config can look like and does.

The title of the section is the name of the environmental variable.

For authentication configuration, please see here for more environmental variables that are supported by the SOP via the Microsoft Authentication Library for Node.JS (@azure/identity):
<https://www.npmjs.com/package/@azure/identity#environment-variables>

---

## `SOP_AuthorityHost`

**Coming soon!**

- Mandatory: `false`
- Expected string format: `String`
- Allowed values: `AzureChina`, `AzureGermany`, `AzureGovernment`, `AzurePublicCloud`
- Description:
**This feature is not implemented.**
This setting will eventually allow you to select which sovereign cloud to authenticate and operate against.
See this page for more details on what each option means: [https://docs.microsoft.com/en-us/javascript/api/@azure/identity/azureauthorityhosts?view=azure-node-latest](https://docs.microsoft.com/en-us/javascript/api/@azure/identity/azureauthorityhosts?view=azure-node-latest)
- Example:
`AzureGovernment`

**Coming soon!**

---

## `SOP_Debug`

- Mandatory: `false`
- Expected string format: Boolean
- Description:
Enables debugging features such as additional http routes.
See [Debug Mode](./Debug-Mode.md) for more information on what is enabled when this is toggled to true.
- Example:
`true`

!!! danger "SECURITY RISK!!!"
    This setting (if enabled) will shut off most self defense of the application and leave it vulnerable. Please be careful with using this option to prevent breach.
    It is advised that this setting should only be enabled if a SHI employee or authorized partner asks you to.

    Usage of this setting should be avoided at all costs.

---

## `SOP_Headless`

- Mandatory: `false`

- Expected string format: `Boolean`
- Description:
This setting allows the host to specify if the server will operate in headless mode (API only).
Technically, this setting toggles the server to host up the static UI folder or not. If the toggle is set to `true` the server will ignore the UI folder. If the value is anything but `true` the UI folder will be served as normal. The default behavior is to serve the UI folder.
It is more secure to run without a UI as it reduces surface area for attack, but this will dramatically reduce the user experience and this project's mission is to improve user experience.
- Example:
`true`

---

## `SOP_MS_Cloud_Type`

- Mandatory: `false`
- Expected string format: `String`
- Description:
This is a configuration flag that enables or disables certain features that are available on certain Microsoft sovereign clouds.
The default value is `Public`, which means if you need to set this value, don't it is already set internally as the default.
Allowed values are: `Public`, `GCC`, `GCCH`, and `China`
- Examples:
    - `GCC`
    - `GCCH`
    - `China`

---

## `SOP_Name_Prefix`

- Mandatory: `false`
- Expected string format: `String`
- Default: `SOP -`
- Description:
This will set a prefix to appear before all the names of objects created.
- Example: <code>eLabs - </code>, results in an example conditional access policy name of `eLabs - PSM - Authentication Methods`.

!!! warning "Max Length"
    The name prefix and suffix both cumulatively can't be more than thirteen characters, including whitespace.

---

## `SOP_Name_Suffix`

- Mandatory: `false`
- Expected string format: `String`
- Description:
This will set a suffix to appear after all the names of objects created.
- Example: `- eLabs`, results in an example conditional access policy name of `PSM - Authentication Methods - eLabs`.

!!! warning "Max Length"
    The name prefix and suffix both cumulatively can't be more than thirteen characters, including whitespace.

---

## `SOP_Scope_Tag`

- Mandatory: `false`
- Expected string format: `String`
- Default: `SHI-Security-Management`
- Description:
This is the Intune Scope tag that the app will be used to store the app's configurations (in the description) and to isolate its configurations from other scopes to enforce least privilege.
If the scope tag does not exist, it will be created automatically.
- Example:
`SOP-App`

!!! note "Prefix and Suffix"
    The core scope tag will ignore the name prefix and suffix configuration. If you want a suffix or prefix for the core scope tag, please put them in here manually.
    Other scope tags will respect the prefix and suffix config.

---

## `SOP_Subscription_ID`

- Mandatory: `false`
- Expected string format: `String`
- Description:
This value needs to be provided if SHIELD is not hosted on an Azure Web App (App Service). This value is used to tell the Core Infrastructure, Lifecycle Management, and Marketplace engines where to operate from.
This is the base subscription of the SHIELD orchestration platform and will be used to deploy and manage solutions like Sentinel and Marketplace offerings that are hosted in azure such as Azure Virtual Desktop.

---

## `SOP_User_Domain`

- Mandatory: `false`
- Expected string format: `String`
- Description:
This setting configures the domain name used for newly created users. If not specified, the newly created user will share the same domain as the user it is based off. You do not need to include the `@` symbol. Only the domain name is necessary.
- Example: `example.com`
- Example: `lab.shilab.com`

---

## `SOP_Username_Prefix`

- Mandatory: `false`
- Expected string format: `String`
- Description:
This setting puts a set of text before the username of a newly created user. The default setting is `priv-` but this can be set to anything allowed by [Entra ID's user principal name property](<https://learn.microsoft.com/en-us/microsoft-365/enterprise/prepare-for-directory-synchronization?view=o365-worldwide#2-directory-object-and-attribute-preparation>).
- Example: `red-`
- Example: `sop_`

!!! note
    If you would like no prefix, set the environmental variable but leave its value empty.
