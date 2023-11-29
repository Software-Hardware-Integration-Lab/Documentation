# Entra ID - P1 & P2

Queries the Entra ID system and retrieves the configuration for each of its features that fall into the P1 or P2 license levels.

Because Entra ID is so expansive, a list of features are also provided in addition to the license list.

## Features Checked

- Conditional Access
- Identity Protection
- Entitlement Management
- Access Reviews - Basic[^1]
- *Global Secure Access* (preview)[^2]
- Group Naming Restrictions
- Group Expirations
- Dynamic Groups
- Privileged Identity Management
- Applications - Group Assignment
- Applications - Entra ID App Proxy
- Self Service Password Reset (SSPR) - On-prem sync[^3]
- HR User Provisioning
- Entra ID Connect - Health
- Entra ID Connect - Group Writeback
- On-Prem/SCIM Provisioning

## Licenses Checked

- Entra ID P1
- Entra ID P2
- ~~Entra ID Governance~~ (Coming Soon)
- ~~Entra ID Workload Identity~~ (Coming Soon)

## Permissions/Roles Required

- [X] Global Reader
    - Used to retrieve all data except for the below items
- [X] User Administrator
    - Group Expiration configuration state

## Footnotes

[^1]:
    This plugin only checks the P1 access review features. It does not check the advanced features of the Entra ID Governance license.
[^2]: Global Secure Access is currently in a mixture of public and private preview. Because of this, license detection reliability is limited.
[^3]:
    Cloud only users are excluded as they get SSPR at no additional charge.
