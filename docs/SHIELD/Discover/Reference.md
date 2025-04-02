# Reference

This page provides a complete reference for the Discover module, including plugins, schema, licensing models, and core configuration expectations.

---

## Plugin Overview

Discover uses a plugin architecture to retrieve data from Microsoft 365 services. Each plugin is executed independently, and the results are standardized before being uploaded to the Azure SQL database.

### Included Plugins

| Plugin | Description |
|--------|-------------|
| **EntraID** | Retrieves directory settings, user roles, and licensing scope |
| **Defender for Endpoint** | Collects device configurations and security compliance mappings |
| **Defender for Identity** | Evaluates privileged identity policies, alerts, and audit logic |

📖 Plugin logic is described in the [Execution Flow Diagram](index.md#execution-process)

---

## Database Schema

All data collected by Discover is stored in an Azure SQL Database. The core tables include:

| Table | Description |
|-------|-------------|
| `Correlation` | Top-level run metadata and timestamp linkage |
| `LicenseData` | All license configuration results |
| `Results` | Engine output for each plugin and validation step |

For full structure and table relationships, see the [Schema Documentation](Database-Schema.md)

---

## Supported Licenses

Discover analyzes how Microsoft 365 licenses are configured and applied. This includes SKUs across all verticals:

- Enterprise (E1, E3, E5)
- Education (A1, A3, A5)
- Government (G1, G3, G5)
- Frontline (F1, F3)

📖 License breakdown and mappings: [Supported Licenses](Supported-Licenses.md)

---

## Reserved Principals

Some Entra ID accounts are marked as reserved and should not be altered by automation. Discover recognizes these automatically and excludes them from plugin evaluations.

📖 See list of principals in: [Reserved Principals](Reserved-Principals.md)

---

## Azure SQL Configuration

Discover requires an Azure SQL Database for storing its results. Refer to [Deployment → Azure SQL Setup](Deployment.md#azure-sql-configuration) for setup steps.

To automatically configure permissions via PowerShell:

```powershell
Add-AzLicenseDb -SubscriptionId '<sub-id>' -ReadGroupId '<read-group-id>' -WriteGroupId '<write-group-id>'
```

```powershell
Get-Help -Name 'Add-AzLicenseDb' -Full
```

---

## Architecture and Flow Diagrams

### Infrastructure Diagram

📖 See [Infrastructure Diagram](index.md#infrastructure-architecture)

- Shows PowerShell client to Entra ID + SQL interaction
- Includes threat model reference: [infrastructure.tm7](assets/threat-models/infrastructure.tm7)

### Execution Flow

📖 See [Execution Flow](index.md#execution-process)

- Describes correlation record creation, plugin execution loop, and upload pattern

---

## Related Pages

- [Discover Overview](index.md)
- [Deployment](Deployment.md)
- [Usage Guide](Usage-Guide.md)
- [Troubleshooting](Troubleshooting.md)