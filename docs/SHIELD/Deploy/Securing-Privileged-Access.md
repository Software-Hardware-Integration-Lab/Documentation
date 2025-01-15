---
hide:
  - toc
---
# Securing Privileged Access (SPA)

Microsoft's Securing Privileged Access (SPA) is a comprehensive solution designed to help organizations protect their critical assets from unauthorized access or data breaches. SPA provides a unified platform for managing and monitoring privileged access across an organization's entire infrastructure, including on-premises, cloud, and hybrid environments.

Below is a diagram that represents the architecture from a top down view.

``` mermaid
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
