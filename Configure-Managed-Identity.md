# Overview
[Managed Identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) (MI) is the preferred method for this project to authenticate to the Microsoft Graph API.   
MI ends credentials/secrets in code, vaults, and environmental variables while preventing a stolen app instance from being abused in an attacker's environment all at the same time as reducing complexity for authentication and supplying deployment scalability.   
It is like your own DRM for your app, only running in your own Azure environment while following your rules.   
Best of all, it is free! No need to spend a single penny on it 😁.

The Managed Identity can be created in one of two formats:
- `User Assigned Managed Identity`
- `System Assigned Managed Identity`

Both have benefits for different architectures.   
A `System Assigned Managed Identity` is good for a single instance of an app and requires less configurations but it is less scalable.   
A `User Assigned Managed Identity` is good for when you want to scale the app to many instances in separate app services but keep a single identity for all app service instances.

See this article for a complete comparison of the two deployment methods:   
https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types

# Create a Managed Identity
To create any type of Managed Identity, follow this guide:   
https://docs.microsoft.com/en-us/azure/app-service/overview-managed-identity

If you decide to use a `User Assigned Managed Identity`, you will need to tell the app that you are using one as the Azure fabric exposes it differently to the resource compared to a `System Assigned Managed Identity`.   
Configure the [Environmental Variable: Managed Identity GUID](./Environmental-Variables-Reference#psm_managed_id_guid) on the App Service so that the web app can use the `User Assigned Managed Identity`.

# Assign Permissions to the Managed Identity
Now that you have been created a Managed Identity, now we need to grant it the Graph API permissions.   
Normally this is exceedingly difficult as you must manually call graph API commands to assign the permissions.   
No fear, PowerShell is here! Check out this PowerShell app:
https://github.com/elliot-huffman/Powershell-Doodads/blob/main/Apps/Azure%20AD/Grant-MIGraphPermission.ps1

The PowerShell app will graphically list all the managed identities, let you select one, then graphically list all the Graph API permissions you can assign it.   
Assign the permissions listed here:   
[Required Graph API Permissions](./Required-Graph-API-Permissions)

For more information on how the PowerShell app works, check out this MS Docs article:   
https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-assign-app-role-managed-identity-powershell