# Deployment

This page outlines how to deploy SHIELD and Discover, including manual installation, silent installs, SQL configuration, and the upcoming Azure Marketplace integration.

---

## Manual Deployment (SHIELD)

You can deploy the SHIELD orchestration server manually using a local PowerShell script and the official SOP `.zip` bundle.

!!! info "Access Requirements"
    Manual deployment is only available to SHI employees or partners who have access to the installation package.

### Steps

1. **Download** the PowerShell installer:  
   👉 [Install-SOP.ps1](0-Getting-Started/Deployment/Scripts/Install-Sop.ps1)

2. **Prepare your environment**:
   - Note your Azure Subscription ID
   - Place the `.zip` file in the same directory as the script

3. **Run the deployment**:
   ```powershell
   Install-SOP.ps1 -SubscriptionId "{Your Azure Subscription ID}" -Path ".\{Your ZIP File Name}.zip" -CompanyName "{YourCompanyNameHere}"
   ```

4. **Need help?**  
   Run:
   ```powershell
   Get-Help .\Install-Sop.ps1 -Full
   ```

!!! danger "Best Practice"
    Deploy SHIELD in a fresh, isolated Azure subscription for optimal permission boundaries.

---

## Azure Marketplace Deployment

Coming soon! SHIELD will soon be available as a 1-click deploy option from the Azure Marketplace.

---

## Discover Deployment Options

Discover is a standalone component used for licensing analysis and compliance tracking. It supports both GUI and script-based installations depending on your environment.

---

## Standard Installation (GUI-Based)

Use the MSI installer for a guided, visual installation of Discover.

### Installation Instructions

1. Install the **latest version** of PowerShell LTS.

    !!! note "PowerShell Deployment Options"
        We recommend using the [Microsoft Store version](https://www.microsoft.com/store/apps/9MZ1SNWT0N5D){:target="_blank"}.  
        You can also use MSI, WinGet, or ZIP downloads listed in [Microsoft's documentation](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows){:target="_blank"}.

        The `pwsh.exe` binary must be registered via [Application Registration](https://learn.microsoft.com/en-us/windows/win32/shell/app-registration#registering-applications){:target="_blank"}.

2. Run the Discover installer.

3. On the main screen, enter the **FQDN** of your Azure SQL Server.  
   📌 Example: `shi-example.database.windows.net`

4. (Optional) Click **Configure** to customize:
   - Correlation table name
   - License data table name
   - SQL database name

5. (Optional) Review the config summary.

6. Click **Install**.

### Screenshots

#### Main Installer Screen

![Installer - Light](Discover/assets/images/screenshots/Installer-Light.png#only-light){ loading=lazy }
![Installer - Dark](Discover/assets/images/screenshots/Installer-Dark.png#only-dark){ loading=lazy }

#### Configuration Dropdown

![Dropdown - Light](Discover/assets/images/screenshots/Dropdown-Light.png#only-light){ loading=lazy }
![Dropdown - Dark](Discover/assets/images/screenshots/Dropdown-Dark.png#only-dark){ loading=lazy }

#### Advanced Configuration

![Advanced Config - Light](Discover/assets/images/screenshots/AdvancedConfig-Light.png#only-light){ loading=lazy }
![Advanced Config - Dark](Discover/assets/images/screenshots/AdvancedConfig-Dark.png#only-dark){ loading=lazy }

!!! note "Shortcut Behavior"
    Desktop shortcuts are only created for user-scoped installs. Machine-wide installs must be launched via CLI.

---

## Silent Installation (Script-Based)

This method allows for fully automated or unattended installation using MSI flags.

### Configuration Reference

| Name | Required | Default | Description |
|------|----------|---------|-------------|
| `AZSQL_SERVER_FQDN` | ✅ | *(none)* | SQL Server FQDN |
| `CORRELATION_TABLE_NAME` | ❌ | `Correlation` | Table for correlation data |
| `DATABASE_NAME` | ❌ | `Results` | SQL database name |
| `LICENSE_COUNT_TABLE_NAME` | ❌ | `LicenseData` | Table for license usage data |

### Examples

```cmd
License-Analytics.msi /qn AZSQL_SERVER_FQDN=shi-example.database.windows.net
```

```cmd
License-Analytics.msi /qn AZSQL_SERVER_FQDN=shi-example.database.windows.net DATABASE_NAME=CustomerTracker
```

```cmd
License-Analytics.msi /qn AZSQL_SERVER_FQDN=shi-example.database.windows.net CORRELATION_TABLE_NAME=RunTracker
```

```cmd
License-Analytics.msi /qn AZSQL_SERVER_FQDN=shi-example.database.windows.net LICENSE_COUNT_TABLE_NAME=CustomerTracker
```

!!! note "Naming Format"
    Do not include protocols (e.g., `sql://`) or paths in the FQDN.

---

## Azure SQL Database Setup

Discover requires a dedicated Azure SQL Database (or managed instance) to store all usage and audit data.

### Required Configuration

- ✅ SQL DB or Managed Instance
- ✅ Entra ID authentication enabled
- ✅ Network connectivity from client to DB

### Storage Requirements

- ~1,676 bytes per Discover run
- ~40KB per year for typical usage
- Easily fits within the Azure SQL 2GB tier

### Recommended Configuration

| Setting | Why |
|---------|-----|
| Use Entra ID Auth Only | Prevent SQL login usage |
| Limit Allowed IPs | Restrict DB access |
| Enable Backups | Avoid data loss |
| Enable Defender for SQL | Threat detection |
| Audit Admin Activity | Compliance & visibility |
| Enable SQL Auditing | Track all changes |
| Send Logs to SIEM | Centralize log collection |
| Avoid BYOK/HYOK/CMK | Unless legally required |
| Set Azure Monitor Alerts | Detect low storage/CPU |

---

### Auto Permission Assignment Tool

You can use Discover’s PowerShell utility to auto-configure SQL access via Entra ID security groups.

#### Example Command

```powershell
Add-AzLicenseDb -SubscriptionId 'your-sub-id' -ReadGroupId 'read-group-id' -WriteGroupId 'write-group-id'
```

#### Get Help

```powershell
Get-Help -Name 'Add-AzLicenseDb' -Full
```

!!! info "Replace IDs"
    Use your real Azure subscription and Entra group IDs.

---

## See Also

- [Standard Installation](#standard-installation-gui-based)
- [Silent Installation](#silent-installation-script-based)
- [Azure SQL Setup (from Prerequisites)](Prerequisites.md#azure-sql-setup)

