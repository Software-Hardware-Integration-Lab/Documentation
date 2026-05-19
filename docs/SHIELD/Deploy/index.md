# Overview

The Deploy module ensures your security architecture stays consistent and compliant with Microsoft's Zero Trust principles by separating enterprise and privileged systems.  

The diagram below shows the Deploy module functional components and their relationships.

``` mermaid
flowchart TD
    B[Deploy Module]
   
    B --> Seg["Environment Segmentation<br/>& Separation"]
    
    Seg --> Priv["Privileged Systems<br/>Restricted Access"]
    Seg --> Ent["Enterprise Systems<br/>Standard Access"]
    
    Priv --> D1["Provision Privileged Layer"]
    Ent --> D2["Provision Enterprise Layer"]
    
    D1 --> G["Entra ID & Roles<br/>Least Privilege"]
    D1 --> H["Intune Policies<br/>Hardened Controls"]
    D1 --> I["Azure Resources<br/>Isolated Infrastructure"]
    
    D2 --> G
    D2 --> H
    D2 --> I
   
```

<br>
<br>

SHIELD's Deploy module provides the foundation for a secure environment using Microsoft's **Securing Privileged Access (SPA)** architecture. This module automates the provisioning of security-critical components such as identity boundaries, privileged access zones, Conditional Access policies, and more. 



## What Is SPA?

Microsoft's **Securing Privileged Access (SPA)** model is a layered defense framework designed to protect your most critical systems from identity compromise. SPA separates access tiers between everyday business operations and sensitive administrative functions.

The diagram below illustrates SPA's architecture and how privileged vs enterprise identity flows interact with the environment.

```mermaid
flowchart LR
    privInterface <--> businessAssets
    entInterface <--> businessAssets

    subgraph businessAssets [Business Systems and Assets]
        subgraph Technology
            ITSM
            Databases
            DCs("Domain Controllers")
            ADFS("AD FS")
            ADCS("AD CS")
            cloud("Cloud Hosts (Azure, AWS, GCP, etc.)")
        end

        subgraph misc [Other Departments]
            Executive
            Legal
            HR
            Finance
        end
    end

    subgraph Privileged [Privileged Access]
        privIdent --- privInterface
        privDev("Devices") --- privIdent("Identities") -.- privIntermediary("Intermediaries") -.- privInterface("Interfaces")
    end

    subgraph Enterprise [Enterprise Access]
        entIdent --- entInterface
        entDev("Devices") --- entIdent("Identities") -.- entIntermediary("Intermediaries") -.- entInterface("Interfaces")
    end
```

---

## What Does Deploy Include?

The Deploy module provisions all infrastructure required to enforce this separation of trust boundaries, including:

- Tiered security groups
- Intune scope tags
- Entra ID administrative units
- Device onboarding and configuration profiles
- Conditional Access policies
- Role-based access control for privileged systems

These objects form the **Privileged Access Boundary** and are deployed via the SHIELD app in a few clicks.

---

## Why It Matters

By centralizing and automating the deployment of SPA, the Deploy module:

- Eliminates human error in policy setup
- Reduces deployment time from months to minutes
- Enables a repeatable, auditable security baseline
- Ensures identity boundaries are established before user/device onboarding

---

## Related Pages

- [Deployment Guide](../Getting-Started)
- [Deploy Usage Guide](Usage-Guide)
- [Deploy Reference](Reference/)
- [Troubleshooting Deploy Module](Troubleshooting)
