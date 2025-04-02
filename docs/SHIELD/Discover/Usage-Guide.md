# Usage Guide

This guide explains how to run Discover, what to expect from its output, and how to interact with its data once collected.

The Discover engine runs locally via PowerShell and sends results to a specified Azure SQL Database. The interface is terminal-based and uses plugin-based configuration.

---

## Running Discover

After installing the application, you can run Discover using either the command line or PowerShell script shortcut.

### CLI Launch (Typical Flow)

```powershell
Start-DiscoverAudit.ps1 -CompanyName "Contoso" -Mode "Standard"
```

Depending on your install method and configuration, a GUI prompt may open (for standard install) or the plugin flow will begin directly (for CLI installs).

---

## Plugin Execution Behavior

When Discover runs, it processes all installed plugins in order:

1. Authentication to Entra ID and Azure SQL
2. Creation of a correlation record to link results
3. Enumeration and validation of plugins
4. Sequential plugin execution (data collection + processing)
5. Upload of result data to Azure SQL tables

Each plugin runs independently and its results are normalized before database submission.

📖 Plugin behavior is described in [Reference → Plugin Overview](Reference/index.md#plugin-overview)

---

## Where Results Go

- Output is written to the Azure SQL Database configured at install time
- Each run generates a correlation record with timestamp and run metadata
- You can query this database directly using SQL tools or BI platforms (like Power BI)

The schema is documented in the [Reference Guide](Reference/index.md#database-schema)

---

## Example Power BI Setup

Once data is stored in Azure SQL, you can use Power BI to:

- Visualize configuration compliance
- Track license optimization opportunities
- Export audit snapshots for reporting

Simply connect to your Azure SQL DB using Power BI Desktop and load the relevant tables.

---

## Related Pages

- [Discover Overview](index.md)
- [Discover Deployment](Deployment/index.md)
- [Reference](Reference/index.md)
- [Troubleshooting](Troubleshooting.md)

