# Azure SQL Database Configuration

MLA requires a database to be present in order to record its findings. This database is not hosted by or maintained in any way by Moot, and is the sole responsibility of your organization.

The database requirements are light, which gives you the flexibility to host it however you want in Azure.

You can use an existing database, or create a new one. We highly recommend to create a new one to reduce potential table name conflicts and improve segmentation. You can name your MLA tables whatever you want in the client configuration.

Regardless of if you create a new one or use an existing one, you need to have Entra ID authentication enabled and configured for the users that run MLA.

## Required DB Configurations

- [X] Azure SQL Database (Recommended) or Managed Instance :material-information-outline:{ title="Any SQL Host that supports Entra ID Authentication" }
- [X] Entra ID Authentication is configured
- [X] The end user has connectivity to the DB host :material-information-outline:{ title="Weather that is through a VPN or directly, or some other way that native Windows networking is compatible with" }

## Storage

The MLA engine is extremely efficient with its storage use, for most organizations, this should not exceed the 2GB minimum database size even with repeated use.

Each run of the MLA tool generates `X bytes` (Coming soon), which results in a total usage of `X bytes` (Coming soon) per year if using the recommended, twice monthly run per tenant.

## Recommended DB Configurations

- [ ] [Allow only Entra ID Authentication](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-azure-ad-only-authentication-tutorial){:target="_blank"} :material-information-outline:{ title="No SQL User Auth" }
- [ ] [Reduce IPs allowed to connect to only the set of authorized users](https://learn.microsoft.com/en-us/azure/azure-sql/database/firewall-configure){:target="_blank"} :material-information-outline:{ title="This is a low priority recommendation if Entra ID only authentication is enabled, as most risks are negated when the DB is in that auth mode." }
- [ ] [Configure Database Backups](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview){:target="_blank"} :material-information-outline:{ title="Store a copy of the data to prevent tamper/loss" }
- [ ] [Enable Defender for Cloud](https://learn.microsoft.com/en-us/azure/azure-sql/database/azure-defender-for-sql){:target="_blank"}
- [ ] [Enable Support Operations Auditing](https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-overview){:target="_blank"}
- [ ] [Enable SQL Auditing](https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-overview){:target="_blank"}
- [ ] [Integrate all telemetry into your SIEM](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings){:target="_blank"}
- [ ] Do not enable BYOK/HYOK/CMK unless you are legally required to do so :material-information-outline:{ title="More info is available via call/meeting with us on this topic." }
- [ ] [Set up Azure Monitor to alert on low storage space and compute](https://learn.microsoft.com/en-us/azure/azure-monitor/best-practices-alerts){:target="_blank"}

## See Also

- [Standard Installation](../Deployment/Standard-Install.md)
- [Silent Installation](../Deployment/Silent-Installation.md)
