# Environmental Variable Reference

Environmental variables are used to configure core behaviors/configurations of the server software.

The configurations are exposed as environmental variables rather than config files or registry keys to provide maximum support for wherever the server is hosted.
Config files don't work well in serverless environments where state should not change, and the registry is only available on Windows.
Serverless, Windows, and Linux all share a common option: Environmental Variables. This works equally well across all of them.

Below is a list of all environmental variable configurations that the server is able to use. There are data format examples and descriptions so that you are not going in blind to what a config can look like and does.

The title of the section is the name of the environmental variable.

---

## MSM_Name_Prefix

- Mandatory: `false`
- Expected string format: `String`
- Default: `MSM -`
- Description:
This will set a prefix to appear before all the names of objects created.
- Example: <code>eLabs - </code>, results in an example conditional access policy name of `eLabs - PSM - Authentication Methods`.

!!! warning "Max Length"
    The name prefix and suffix both cumulatively can't be more than 13 characters, including whitespace.

---

## MSM_Name_Suffix

- Mandatory: `false`
- Expected string format: `String`
- Description:
This will set a suffix to appear after all the names of objects created.
- Example: `- eLabs`, results in an example conditional access policy name of `PSM - Authentication Methods - eLabs`.

!!! warning "Max Length"
    The name prefix and suffix both cumulatively can't be more than 13 characters, including whitespace.

---

## MSM_User_Domain

- Mandatory: `false`
- Expected string format: `String`
- Description:
This setting configures the domain name used for new users. If not specified, the newly created user will share the same domain as the user it is based off of. You do not need to include the `@` symbol. Only the domain name is necessary.
- Example: `example.com`
- Example: `lab.mootinc.com`

---

## MSM_Username_Prefix

- Mandatory: `false`
- Expected string format: `String`
- Description:
This setting puts a set of text before the username of a newly created user. The default setting is `priv-` but this can be set to anything allowed by [Azure AD's user principal name property](<https://learn.microsoft.com/en-us/microsoft-365/enterprise/prepare-for-directory-synchronization?view=o365-worldwide#2-directory-object-and-attribute-preparation>).
- Example: `red-`
- Example: `msm_`

!!! note
    If you would like no prefix, set the environmental variable but leave it's value empty.

---

## MSM_Headless

- Mandatory: `false`

- Expected string format: `Boolean`
- Description:
This setting allows the host to specify if the server will operate in headless mode (API only).
Technically, this setting toggles the server to host up the static UI folder or not. If the toggle is set to `true` the server will ignore the UI folder. If the value is anything but `true` the UI folder will be served as normal. The default behavior is to serve the UI folder.
It is generally more secure to run without a UI as it reduces surface area for attack, but this will dramatically reduce the user experience and this project's mission is to improve user experience.
- Example:
`true`

---

## MSM_Scope_Tag

- Mandatory: `false`
- Expected string format: `String`
- Default: `Moot-Security-Management`
- Description:
This is the Intune Scope tag that the app will be used to store the app's configurations (in the description) and to isolate its configurations from other scopes to enforce least privilege.
If the scope tag does not exist, it will be created automatically.
- Example:
`MSM-App`

!!! note "Prefix and Suffix"
    The core scope tag will ignore the name prefix and suffix configuration. If you want a suffix or prefix for the core scope tag, please put them in here manually.
    Other scope tags will respect the prefix and suffix config.

---

## MSM_Client_GUID

- Mandatory: `true`, unless using a `Managed Identity`
- Expected string format: `GUID`, no braces
- Description:
The Client GUID is the Application (client) ID of the application registration in Azure AD.
- Example:
`123e4567-e89b-12d3-a456-426614174000`

---

## MSM_Client_Secret

- Mandatory: `true`, unless specifying the `MSM_KeyVault_Name` and `MSM_KeyVault_Secret` values or using a `Managed Identity`
- Expected string format: `String`
- Description:
The Client Secret variable is the password that was generated in the application registration.
This value is not required when using the Key Vault name and Key Vault Secret configurations as the application will automatically pull the secret from key vault and use it.
- Example:
`Lz5T42u0.PMMAZg2wn-yy.6I.5EV4n6KYc`

---

## MSM_ClientAuth_ClientId

- Mandatory: `true`
- Expected string format: `String`
- Description:
The Client ID variable is the identifier that was generated in the Client Authentication application registration.
This specific client ID value is not for authenticating the server, but for authenticating the end user. This value is used by the server for user account validation in MSAL.
- Example:
`cad571f8-b24b-4184-8197-a28e2d48e966`

---

## MSM_ClientAuth_ClientSecret

- Mandatory: `true`
- Expected string format: `String`
- Description:
The Client Secret variable is the password that was generated in the Client Authentication application registration.
This specific client secret value is not for authenticating the server, but for authenticating the end user. This value is used by the server for user account validation in MSAL.
- Example:
`Lz5T42u0.PMMAZg2wn-yy.6I.5EV4n6KYc`

---

## MSM_ClientAuth_TenantId

- Mandatory: `true`
- Expected string format: `String`
- Description:
The Client Authentication Tenant Id is the ID used of the tenant that will be gate keeping the users to be allowed to log into the app.
This specific configuring is not for authenticating the server, but for authenticating the end user. This value is used by the server for user account validation in MSAL.
- Example:
`a3f7304d-5cba-42cf-a3d9-e852e45c7e6a`

---

## MSM_Tenant_ID

- Mandatory: `true`, unless using a `Managed Identity`
- Expected string format: `GUID`, no braces
- Description:
This is the ID of the tenant that the application registration is registered in.
- Example:
`123e4567-e89b-12d3-a456-426614174000`

---

## MSM_Managed_ID_GUID

- Mandatory: `false`
- Expected string format: `GUID`, no braces
- Description:
This is the Client ID, not the Object ID.
This variable is only necessary if you would like to use a user assigned managed identity. This variable is not necessary for system assigned managed identities.
If it is not specified, the application will attempt to retrieve a system managed identity authentication token.
If this variable is specified, the system will attempt to retrieve a access token using a user assigned managed identity.
- Example:
`123e4567-e89b-12d3-a456-426614174000`

---

## MSM_KeyVault_Name

- Mandatory: `false`

- Expected string format: `String`
- Description:
The unique name of the Azure Key Vault that contains the app registration secret that you want the app to authenticate with. If you configure the `MSM_Client_Secret` and the `MSM_KeyVault_Name` at the same time, the application will throw an error as this it is a security risk to have a plain text secret stored in the app configs when a perfectly good Azure Key Vault is available. Environmental variables are not meant for storing secret materials, Key Vaults are meant for storing secret materials.
This configuration is not necessary if using Managed Identity to authenticate. Managed Identity is the best way to authenticate as there is no secret material for a malicious entity to steal.
- Example:
`org-key-vault-hsm`

---

## MSM_KeyVault_Secret

- Mandatory: `false`

- Expected string format: `String`
- Description:
The name of the secret in the Azure Key Vault that you specified in the `MSM_KeyVault_Name` option. This option is only evaluated if the `MSM_KeyVault_Name` is configured.
- Example:
`app-reg-secret`

---

## MSM_AuthorityHost

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

## MSM_Debug

- Mandatory: `false`
- Expected string format: Boolean
- Description:
Enables debugging features such as additional http routes.
See [Debug Mode](./Debug-Mode) for more information on what is enabled when this is toggled to true.
- Example:
`true`
