# Azure SQL Database Configuration

SLA requires a database to be present in order to record its findings. This database is not hosted by or maintained in any way by SHI, and is the sole responsibility of your organization.

The database requirements are light, which gives you the flexibility to host it however you want in Azure.

You can use an existing database, or create a new one. We highly recommend to create a new one to reduce potential table name conflicts and improve segmentation. You can name your SLA tables whatever you want in the client configuration.

Regardless of if you create a new one or use an existing one, you need to have Entra ID authentication enabled and configured for the users that run SLA.

## Required DB Configurations

- [X] Azure SQL Database (Recommended) or Managed Instance :material-information-outline:{ title="Any SQL Host that supports Entra ID Authentication" }
- [X] Entra ID Authentication is configured
- [X] The end user has connectivity to the DB host :material-information-outline:{ title="Weather that is through a VPN or directly, or some other way that native Windows networking is compatible with" }

## Storage

The SLA engine is extremely efficient with its storage use, for most organizations, this should not exceed the 2GB minimum database size even with repeated use.

Each run of the SLA tool generates ~`1,676 bytes`, which results in a total usage of ~`40 Kilobytes` per year if using the recommended run frequency (twice monthly) per tenant.

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

## Auto Permissions Assignment Tool

SLA comes with a security group permissions management auto configuration tool to make it easier to permission an Azure SQL DB for Entra ID auth at scale.

This tool will take the specified security groups (as identified by their object IDs) and grant them read and write permissions in the DB through Entra ID authentication.

To use authorization auto config tool:

1. Deploy the client software to the computer that you are going to run the commands from.
2. Run the below command

```PowerShell title="SQL Authorization Auto Configuration"
Add-AzLicenseDb -SubscriptionId 'c82e42ee-4dea-450e-8f24-52ff699a8f99' -ReadGroupId '16ffec1f-4062-4dd2-8d73-b4882fcc9bb8' -WriteGroupId '3a48f409-5847-47bf-bad9-7235a7c38e3c'
```

!!! info "Note on IDs in Example Code"
    Replace the IDs with your environment's specific IDs.

!!! question "In-depth docs"
    For more information about available options, please run the below for the complete set of information on the auto config tool

    ```PowerShell title="Help Docs for Auto Config Tool"
    Get-Help -Name 'Add-AzLicenseDb' -Full
    ```

## See Also

- [Standard Installation](../Deployment/Standard-Install.md)
- [Silent Installation](../Deployment/Silent-Installation.md)
