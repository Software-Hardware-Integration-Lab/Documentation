# Prerequisites

Before deploying SHIELD or using Discover, ensure your environment meets all license, configuration, permission, and software requirements.

This page is divided into two parts:


1. [SHIELD Core Platform Requirements](#shield-core-platform-requirements)  
2. [Discover System Requirements](#discover-system-requirements)

---

## SHIELD Core Platform Requirements

SHIELD automates secure deployment and lifecycle management using Microsoft 365 and Azure. It requires specific license levels, identity configurations, and Microsoft Defender components.

### Environment Requirements

- ✅ Deploying user must have **Global Admin Rights**  
- ✅ Microsoft Defender for Endpoint must be provisioned. See [Defend Usage Guide](../Defend/Usage-Guide/index.md), under **Defender for Endpoint Workspace Creation**
- ✅ [Security Defaults](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/concept-fundamentals-security-defaults#disabling-security-defaults) must be disabled in Entra ID  
- ✅ [Certificate Authentication](https://learn.microsoft.com/en-us/azure/active-directory/authentication/how-to-certificate-based-authentication#step-2-enable-cba-on-the-tenant) must be disabled for SHIELD’s security groups

---

### Licensing Requirements by Mode

SHIELD uses `M3` and `M5` to refer to Microsoft 365 license families, abstracting E3/E5 and similar plans.

| Mode | License | Additional Requirements |
|------|---------|--------------------------|
| **ESM** (Enterprise Security Mode) | M3 or equivalent | Devices must be Hybrid or Cloud Joined |
| **SSM** (Specialized Security Mode) | M5 or equivalent | Devices must be Hybrid or Cloud Joined |
| **PSM** (Privileged Security Mode) | M5 or equivalent | Devices must be Autopilot-registered and [Secure Core Certified](../Defend/Reference/Hardware-Selection.md) |

---

## Discover System Requirements

Discover is a component of SHIELD that audits licensing configuration, queries Microsoft APIs, and stores analysis in an Azure SQL Database. The following setup is required.

---

### System & Runtime Configuration

- ✅ Latest version of **PowerShell (64-bit)** (e.g. 7.4.0 or later)  
- ✅ Internet access with no SSL/TLS inspection for Microsoft-owned domains  
- ✅ At least **2GB of available RAM**  
- ✅ Azure SQL Database is configured and reachable (see setup below)

!!! info "Assumptions"
    These recommendations assume ~10,000 users running Discover twice a month. For larger organizations or more frequent use, increase memory and SQL capacity.

---

### Entra ID Role Permissions

Discover uses read-only Entra ID roles for configuration queries. These permissions are scoped with the principle of least privilege.

| Role | Required For |
|------|---------------|
| **Global Reader** | Basic environment access (Defender, Entra ID) |
| **Security Administrator** | Access to Defender for Endpoint & Identity APIs |
| **User Administrator** | Access to user directory properties |

**Related plugin guides:**
docs\SHIELD\Reference\Plugins\DefenderEndpoint.md
- 📄 [Defender for Endpoint](../Discover/Reference/Plugins/DefenderEndpoint.md)  
- 📄 [Defender for Identity](../Discover/Reference/Plugins/DefenderIdentity.md)  
- 📄 [Entra ID](../Discover/Reference/Plugins/EntraID.md)

!!! info "Permissions Note"
    Discover will never modify your configuration. All operations are read-only and scoped to data retrieval.

---

### Azure SQL Setup

An Azure SQL Database is required to store audit results. You can use an existing DB or provision a new one.

📖 [Deployment → Azure SQL Database Setup](../Getting-Started.md#azure-sql-database-setup)

**Required:**

- Entra ID Authentication is enabled  
- Client running Discover must have network access (e.g., VPN or VNet)

**Storage Notes:**

- Each Discover run generates ~1,676 bytes  
- Typical org = ~40KB/year  
- 2GB base DB size is sufficient in most cases

---

### Recommended SQL Configuration

These settings are optional but highly recommended for security, auditability, and reliability:

- [Use Entra ID Authentication Only](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-azure-ad-only-authentication-tutorial)  
- [Limit IP ranges](https://learn.microsoft.com/en-us/azure/azure-sql/database/firewall-configure)  
- [Enable database backups](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview)  
- [Enable Defender for SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/azure-defender-for-sql)  
- [Audit support operations](https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-overview)  
- [Send logs to SIEM](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings)  
- [Alert on low resources](https://learn.microsoft.com/en-us/azure/azure-monitor/best-practices-alerts)  
- Avoid BYOK/HYOK/CMK unless legally required

---

### Auto Permissions Assignment Tool

Discover includes a PowerShell tool to auto-configure SQL permissions via Entra security groups.

```powershell
Add-AzLicenseDb -SubscriptionId '<your-sub-id>' -ReadGroupId '<read-group-id>' -WriteGroupId '<write-group-id>'
```

To view tool options:

```powershell
Get-Help -Name 'Add-AzLicenseDb' -Full
```

!!! info
    Replace values above with your actual subscription and Entra group IDs.

---

## Related Pages

- 📄 [Hardware Requirements](../Defend/Reference/Hardware-Selection.md)  
- 📄 [Deployment Guide](../Getting-Started.md)  
- 📄 [Azure SQL Setup](../Getting-Started.md#azure-sql-database-setup)  
- 📄 [Silent Installation Instructions](../Getting-Started.md#silent-installation-script-based)  
- 📄 [Standard Installation Instructions](../Getting-Started.md#standard-installation-gui-based)