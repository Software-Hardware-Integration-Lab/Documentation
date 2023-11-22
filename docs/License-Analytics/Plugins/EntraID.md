# Entra ID - P1 & P2

Queries the Entra ID system and retrieves the configuration for each of its features that fall into the P1 or P2 license levels.

## Features Checked

- Conditional Access
- Identity Protection
- Entitlement Management
- Access Reviews - Basic[^1]
- Group Naming Restrictions
- Group Expirations
- Dynamic Groups
- Privileged Identity Management
- Applications - Group Assignment
- Applications - Entra ID App Proxy
- Self Service Password Reset - On-prem sync[^2]
- HR User Provisioning
- Entra ID Connect - Health
- Entra ID Connect - Group Writeback
- On-Prem/SCIM Provisioning

## Footnotes

[^1]:
    This plugin only checks the P1 access review features.
    Not the Entra ID Governance license advanced features.
[^2]:
    Cloud only users are excluded as they get SSPR at no additional charge.
