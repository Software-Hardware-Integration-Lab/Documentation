# Deployment

This page outlines how to deploy the Discover engine and configure the local environment needed to run plugin-based audits and store results in Azure SQL.

All installation methods rely on a lightweight MSI and PowerShell-driven configuration. This module runs entirely on the client side and requires no backend installation.

---

## Standard Installation (GUI-Based)

Use the GUI-based MSI for interactive setup. This is recommended for most environments.

### Installation Steps

1. Download the MSI installer
2. Launch the installer
3. Enter the **FQDN** of your Azure SQL Database  
   📌 Example: shi-example.database.windows.net
4. (Optional) Click **Configure** to customize:
   - Table names for correlation and license data
   - Database name
5. Click **Install**

### Screenshots

#### Main Installer Screen

![Installer - Light](assets/images/screenshots/Installer-Light.png#only-light){ loading=lazy }
![Installer - Dark](assets/images/screenshots/Installer-Dark.png#only-dark){ loading=lazy }

#### Dropdown Menu

![Dropdown - Light](assets/images/screenshots/Dropdown-Light.png#only-light){ loading=lazy }
![Dropdown - Dark](assets/images/screenshots/Dropdown-Dark.png#only-dark){ loading=lazy }

#### Advanced Configuration

![Advanced Config - Light](assets/images/screenshots/AdvancedConfig-Light.png#only-light){ loading=lazy }
![Advanced Config - Dark](assets/images/screenshots/AdvancedConfig-Dark.png#only-dark){ loading=lazy }

!!! note "Shortcut Behavior"
    Machine-wide installs of PowerShell require launching Discover via CLI. Desktop shortcuts are only supported for user-scoped installs.

---

## Silent Installation (Script-Based)

Use silent install mode for automation and unattended deployments.

### Required Properties

| Property | Required | Default | Description |
|----------|----------|---------|-------------|
| AZSQL_SERVER_FQDN | ✅ | None | FQDN of the Azure SQL Server |
| CORRELATION_TABLE_NAME | ❌ | Correlation | Name of correlation table |
| DATABASE_NAME | ❌ | Results | Target database name |
| LICENSE_COUNT_TABLE_NAME | ❌ | LicenseData | License records table |

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
    The FQDN should not include protocols (sql://) or directory paths (/db). Use only the raw hostname.

---

## Azure SQL Configuration

Before installation, ensure your Azure SQL database is provisioned:

- Entra ID authentication is enabled
- Your user has permission to create and write to the DB
- [Auto-permissions tool](Reference.md#azure-sql-configuration) is available for bulk role assignment

📖 See full details in the [Reference Guide](Reference.md#azure-sql-configuration)

---

## Related Pages

- [Discover Overview](index.md)
- [Discover Usage Guide](Usage-Guide.md)
- [Reference](Reference.md)
- [Troubleshooting](Troubleshooting.md)