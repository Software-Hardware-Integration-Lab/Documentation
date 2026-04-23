# SHI Environment Lockdown & Defense

## Overview


SHIELD is a hybrid SaaS solution with a customer-installed app in their Azure tenant. The Shield app service is an orchestration tool that simplifies the deployment, management, and maintenance of Microsoft's Secure Privileged Access architecture. With SHIELD, you can automate the deployment of complex security infrastructures, device management, and user management while adhering to security best practices. SHIELD helps organizations to reduce the time and expertise required for deployment from a year or more to just a few minutes. 


SHI operates a centralized SaaS service in its own Azure tenant known as the Data Gateway. This is a SaaS component shared by multiple customers using tenant isolation via access token claims cryptographically signed by Microsoft EntraID. It provides storage, analysis, and reporting services for Shield data. The SHIELD app service collects and processes data within the customer tenant before providing abstracted & fully anonymized data results back to the Data Gateway for reporting and analysis. 


!!! info "Security Considerations"
    SHI does not manage or access the SHIELD app service runtime. Where authorized by the customer, the Shield app service may initiate configuration changes in the customer's tenant using delegated or application permissions explicitly consented to by the customer.  All requirements can be set up by the delivery team or customer prior to engagement. Note that these configuration changes are deployed as security policies which will need further customer action to associate them with users. 


## Architecture Topology

The following diagram shows the high-level SHIELD deployment and trust boundaries between the customer tenant, SHI's SaaS tenant, and Microsoft Entra ID. Shield components that are deployed to customer environments are outlined in red.  

![This diagram illustrates a multi-tenant Microsoft Azure topology showing a vendor (Shi) tenant and a customer tenant within the Microsoft Azure Global boundary. Key components: the Shi tenant contains a Data Gateway and ShiLab.com; Microsoft EntraID is shown as the identity service bridging or present in the environment; the Customer Tenant contains a Shield Resource Group which houses SHIELD, auxiliary components (Shield VNet, PS Proxy service, Key Vault, network interfaces, DNS zones) and customer resources. The relationships indicate the logical grouping of resources by tenant and resource group and highlight where identity and gateway components reside relative to the customer SHIELD deployment.](../assets/images/Overview/Overview.png)


## Audience

This documentation is primarily intended for technical users who are responsible for the deployment, management, and maintenance of security infrastructures. However, the documentation is designed to be accessible to non-technical users as well.

## Key Features and Benefits

SHIELD comes with a range of features that simplify the deployment and management of complex security infrastructures. Some of the key features and benefits of SHIELD are:

- Automate the deployment of complex security infrastructures
- Manage devices, users, intermediaries, and server/interfaces with ease
- Adhere to security best practices
- Reduce maintenance efforts

## SHIELD in the Security Landscape

SHIELD is an orchestration tool in the larger security landscape. It does not bring new security functionality, but instead automates the tools that already exist. SHIELD operates as an orchestrator for the rest of the security landscape, simplifying the deployment and management of complex security infrastructures.

## Prerequisites

Check out this page for more details: [Getting Started - Prerequisites](Prerequisites/index.md)

## Installation

The Shield installer ('Shield Desktop') is downloaded to the customer tenant and executed by an administrator. During installation, the administrator is required to authenticate interactively to the customers' Azure tenant. The installer uses this authenticated session to provision an Azure App Service and associated resources directly into the tenant under the customers' ownership and governance. No resources are deployed without explicit customer action and consent, and the resulting App Service operates entirely within the customers' Azure subscription. 
The installer provisions the Shield UI web application and associated components to the customer's tenant.

## Shield Module Overview

Depending on licensing, the following components will be available from the UI:

[Shield Discover](https://docs.shilab.com/SHIELD/Discover/) The Discover module enables advanced licensing intelligence and compliance reporting for Microsoft 365 services

```mermaid
flowchart LR
	subgraph m365["Primary Inputs"]
		graphApi[Microsoft Graph API]
		defenderApi[Microsoft Defender API]
		purviewApi[Microsoft Purview API]
	end

	subgraph discover["Shield Discover Module"]
		collect[Data Collection Engine]
		normalize[Normalization and Correlation]
		analyze[Licensing Report Generation]
	end

	subgraph outputs["Discover Outputs"]
		licenseReport[Licensing Report]
		gateway[Data Gateway]
	end

	style m365 fill:#f3f8ff,stroke:#2f6db3,stroke-width:2px,color:#111827
	style discover fill:#eefaf0,stroke:#2e8540,stroke-width:2px,color:#111827
	style outputs fill:#fff7ec,stroke:#b4690e,stroke-width:2px,color:#111827

	classDef source fill:#dbeafe,stroke:#1d4ed8,color:#0b1f44,stroke-width:1.5px
	classDef process fill:#dcfce7,stroke:#15803d,color:#102a1f,stroke-width:1.5px
	classDef result fill:#ffedd5,stroke:#c2410c,color:#3a1c06,stroke-width:1.5px

	class graphApi,defenderApi,purviewApi source
	class collect,normalize,analyze process
	class licenseReport,gateway result

	graphApi --> collect
	defenderApi --> collect
	purviewApi --> collect
	collect --> normalize
	normalize --> analyze
	analyze --> licenseReport
	licenseReport --> gateway
```

[Shield Defend](https://docs.shilab.com/SHIELD/Defend/)  The Defend module is responsible for all lifecycle operations within the SHIELD platform. It provides user and device onboarding, offboarding, access enforcement, and enforcement of privileged workflows in alignment with the SPA model deployed by the Deploy module.

Click this link to see more on [Secure Privileged Access](https://learn.microsoft.com/en-us/security/privileged-access-workstations/overview)






```mermaid
flowchart TD
	subgraph sources["Defend"]
        
		entra[Microsoft Entra ID]
		intune[Microsoft Intune Policies]

        entra-->userLifecycle
        entra-->deviceLifecycle
        intune-->userLifecycle
        intune-->deviceLifecycle
	end

    subgraph userLifecycle["User Lifecycle Activities"]
        
		signInMgmt[Manage Who Can Sign In to Privileged Devices]
		intuneRewrite[Rewrite Intune Policy Payloads]
		userSync[Sync SHIELD Settings for User Records]
	end

	subgraph deviceLifecycle["Device Lifecycle Activities"]
        
		commission[Commission Devices into SHIELD]	
		decommission[Decommission Devices Cleanly]
		deviceSync[Sync SHIELD Settings for Device Records]
		privDevices[Privileged Devices]
        managedDevices[Managed Devices]
        unmanagedDevices[Unmanaged Devices]
	end

	
	style sources fill:#f3f8ff,stroke:#2f6db3,stroke-width:2px,color:#111827
	style userLifecycle fill:#fff7ec,stroke:#b4690e,stroke-width:2px,color:#111827
	style deviceLifecycle fill:#eefaf0,stroke:#2e8540,stroke-width:2px,color:#111827

	classDef action fill:#ffedd5,stroke:#c2410c,color:#3a1c06,stroke-width:1.5px
	classDef process fill:#dcfce7,stroke:#15803d,color:#102a1f,stroke-width:1.5px
	classDef system fill:#dbeafe,stroke:#1d4ed8,color:#0b1f44,stroke-width:1.5px
	class commission,decommission,signInMgmt action
	class graphBatch,intuneRewrite,userSync,deviceSync process
	class entra,intune,privDevices,managedDevices,unmanagedDevices system

    
	
	
```

[Shield Deploy](https://docs.shilab.com/SHIELD/Deploy/)  SHIELD's Deploy module provides the foundation for a secure environment using Microsoft's Securing Privileged Access (SPA) architecture. This module automates the provisioning of security-critical components such as identity boundaries, privileged access zones, Conditional Access policies, and more. 


```mermaid
flowchart LR
	subgraph policySet["Known Policy Sets"]
		commonSet[Common Policy Set]
		enterpriseSet[Enterprise Policy Set]
		privilegedSet[Privileged Policy Set]
		specialisedSet[Specialised Policy Set]
	end

	subgraph deploy["Shield Deploy Module"]
		orchestrator[Deployment Orchestrator]
		apply[Policy Deployment Engine]
	end

	subgraph outcomes["Customer Tenant"]
		outTieredGroups[Tiered Security Groups]
		outScopeTags[Intune Scope Tags]
		outAdminUnits[Entra ID Administrative Units]
		outDeviceProfiles[Device Onboarding and Configuration Profiles]
		outCAPolicies[Conditional Access Policies]
		outRBAC[Role-Based Access Control for Privileged Systems]
	end

	style policySet fill:#f3f8ff,stroke:#2f6db3,stroke-width:2px,color:#111827
	style deploy fill:#eefaf0,stroke:#2e8540,stroke-width:2px,color:#111827
	style outcomes fill:#fff7ec,stroke:#b4690e,stroke-width:2px,color:#111827

	classDef input fill:#dbeafe,stroke:#1d4ed8,color:#0b1f44,stroke-width:1.5px
	classDef process fill:#dcfce7,stroke:#15803d,color:#102a1f,stroke-width:1.5px
	classDef output fill:#ffedd5,stroke:#c2410c,color:#3a1c06,stroke-width:1.5px

	class commonSet,enterpriseSet,privilegedSet,specialisedSet input
	class orchestrator,apply process
	class outTieredGroups,outScopeTags,outAdminUnits,outDeviceProfiles,outCAPolicies,outRBAC output

	commonSet --> orchestrator
	enterpriseSet --> orchestrator
	privilegedSet --> orchestrator
	specialisedSet --> orchestrator
	orchestrator --> apply
	apply --> outTieredGroups
	apply --> outScopeTags
	apply --> outAdminUnits
	apply --> outDeviceProfiles
	apply --> outCAPolicies
	apply --> outRBAC
```


## Recommended Environment

While not mandatory, it is highly recommended to use SHIELD in the following environment:

- An `Azure Subscription` for hosting the application, as it is a security best practice to run the app in Azure
- All objects to be managed by SHIELD (devices, users, apps, etc.) synced/connected to Entra ID, the primary identity provider used by SHIELD

By following these recommendations, you can speed up the adoption process for SHIELD.

## Summary

In the rest of the documentation, we will provide detailed instructions on how to install, configure, and use SHIELD to achieve these benefits.

## See Also

- [Usage Guides](Usage-Guide.md)
- Change Log - Coming Soon!
- [SHIELD Architecture](Reference/Architecture/index.md)
- [API Documentation](Reference/Development/OpenAPI.md)
- [Troubleshooting](Deploy/Troubleshooting.md)
- [Contact Us](https://shilab.com/contact)
