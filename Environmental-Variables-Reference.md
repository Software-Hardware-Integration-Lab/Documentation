### The environmental variables that are used to configure the web app are as follows:

* [PSM_Headless](#PSM_Headless)
* [PSM_Scope_Tag](#PSM_Scope_Tag)
* [PSM_Client_GUID](#PSM_Client_GUID)
* [PSM_Client_Secret](#PSM_Client_Secret)
* [PSM_Tenant_ID](#PSM_Tenant_ID)
* [PSM_Managed_ID_GUID](#PSM_Managed_ID_GUID)
* [PSM_KeyVault_Name](#PSM_KeyVault_Name)
* [PSM_KeyVault_Secret](#PSM_KeyVault_Secret)
* [PSM_AuthorityHost](#PSM_AuthorityHost)
* [PSM_Debug](#PSM_Debug)

---

## PSM_Headless
* Mandatory: `false`
* Expected string format: `Boolean`
* Description:   
This setting allows the host to specify if the server will operate in headless mode (API only).   
Technically, this setting toggles the server to host up the static UI folder or not. If the toggle is set to `true` the server will ignore the UI folder. If the value is anything but `true` the UI folder will be served as normal. The default behavior is to serve the UI folder.   
It is generally more secure to run without a UI as it reduces surface area for attack, but this will dramatically reduce the user experience and this project's mission is to improve user experience.
* Example:   
`true`


---

## PSM_Scope_Tag

* Mandatory: `false`
* Expected string format: `String`
* Description:   
This is the Endpoint Manager Scope tag that the app will be used to store the app's configurations (in the description) and to isolate its configurations from other scopes to enforce least privilege.   
If the scope tag does not exist, it will be created automatically.   
The default value if not specified is `Privileged-Security-Management`.
* Example:   
`PSM-App`

---

## PSM_Client_GUID

* Mandatory: `true`, unless using a `Managed Identity`
* Expected string format: `GUID`, no braces
* Description:   
The Client GUID is the Application (client) ID of the application registration in Azure AD.
* Example:   
`123e4567-e89b-12d3-a456-426614174000`

---

## PSM_Client_Secret

* Mandatory: `true`, unless specifying the `PSM_KeyVault_Name` and `PSM_KeyVault_Secret` values or using a `Managed Identity`
* Expected string format: `String`
* Description:   
The Client Secret variable is the password that was generated in the application registration.   
This value is not required when using the Key Vault name and Key Vault Secret configurations as the application will automatically pull the secret from key vault and use it.
* Example:   
`Lz5T42u0.PMMAZg2wn-yy.6I.5EV4n6KYc`

---

## PSM_Tenant_ID

* Mandatory: `true`, unless using a `Managed Identity`
* Expected string format: `GUID`, no braces
* Description:   
This is the ID of the tenant that the application registration is registered in.
* Example:   
`123e4567-e89b-12d3-a456-426614174000`

---

## PSM_Managed_ID_GUID

* Mandatory: `false`
* Expected string format: `GUID`, no braces
* Description:   
This is the Client ID, not the Object ID.   
This variable is only necessary if you would like to use a user assigned managed identity. This variable is not necessary for system assigned managed identities.   
If it is not specified, the application will attempt to retrieve a system managed identity authentication token.   
If this variable is specified, the system will attempt to retrieve a access token using a user assigned managed identity.
* Example:   
`123e4567-e89b-12d3-a456-426614174000`

---

## PSM_KeyVault_Name
* Mandatory: `false`
* Expected string format: `String`
* Description:   
The unique name of the Azure Key Vault that contains the app registration secret that you want the app to authenticate with. If you configure the `PSM_Client_Secret` and the `PSM_KeyVault_Name` at the same time, the application will throw an error as this it is a security risk to have a plain text secret stored in the app configs when a perfectly good Azure Key Vault is available. Environmental variables are not meant for storing secret materials, Key Vaults are meant for storing secret materials.   
This configuration is not necessary if using Managed Identity to authenticate. Managed Identity is the best way to authenticate as there is no secret material for a malicious entity to steal.
* Example:   
`org-key-vault-hsm`

---

## PSM_KeyVault_Secret
* Mandatory: `false`
* Expected string format: `String`
* Description:   
The name of the secret in the Azure Key Vault that you specified in the `PSM_KeyVault_Name` option. This option is only evaluated if the `PSM_KeyVault_Name` is configured.
* Example:   
`app-reg-secret`

---

## PSM_AuthorityHost
**Coming soon!**
* Mandatory: `false`
* Expected string format: `String`
* Allowed values: `AzureChina`, `AzureGermany`, `AzureGovernment`, `AzurePublicCloud`
* Description:   
**This feature is not implemented.**   
This setting will eventually allow you to select which sovereign cloud to authenticate and operate against.   
See this page for more details on what each option means: [https://docs.microsoft.com/en-us/javascript/api/@azure/identity/azureauthorityhosts?view=azure-node-latest](https://docs.microsoft.com/en-us/javascript/api/@azure/identity/azureauthorityhosts?view=azure-node-latest)
* Example:   
`AzureGovernment`

**Coming soon!**

---

## PSM_Debug

* Mandatory: `false`
* Expected string format: Boolean
* Description:   
Enables debugging features such as additional http routes.   
See [Debug Mode](./Debug-Mode) for more information on what is enabled when this is toggled to true.
* Example:   
`true`