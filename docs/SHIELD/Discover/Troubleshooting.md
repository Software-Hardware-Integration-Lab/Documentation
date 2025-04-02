# Troubleshooting

This page documents common issues that may occur when running the Discover module, along with guidance on resolution, retries, and output validation.

These cases are drawn from the expected behavior of plugin execution, Azure SQL access, and Defender/Graph API interactions.

---

## Issue: Plugin run starts but no data appears in SQL

**Possible Causes:**
- Azure SQL FQDN was entered incorrectly
- No write permissions for the logged-in user
- Plugin executed but no relevant configuration was found

**Resolution:**
- Verify that `AZSQL_SERVER_FQDN` is correct and reachable from the client machine
- Check user permissions on the database
- Ensure that plugins are active and supported for the tenant configuration

---

## Issue: Installer runs but shortcut is missing

**Cause:**
- Discover was installed machine-wide

**Resolution:**
- Use CLI directly:

```powershell
Start-DiscoverAudit.ps1 -CompanyName "Contoso" -Mode "Standard"
```

Shortcuts are only created for user-scoped installs.

---

## Issue: Silent install fails with no error

**Possible Causes:**
- Required `AZSQL_SERVER_FQDN` parameter was omitted
- MSI was run with incorrect context or permissions

**Resolution:**
- Add `/l*v install.log` to enable verbose logging
- Confirm all parameters are supplied and formatted correctly
- Example:

```cmd
License-Analytics.msi /qn AZSQL_SERVER_FQDN=yourserver.database.windows.net
```

---

## Issue: Script hangs at plugin step

**Possible Causes:**
- API credentials have expired
- Microsoft Graph rate-limiting or auth error

**Resolution:**
- Re-authenticate via PowerShell session
- Run again with fresh token
- Use `Get-Help .\Start-DiscoverAudit.ps1 -Full` for CLI flags

---

## FAQs

### Is Discover idempotent?
Yes — the correlation ID ensures that repeated runs do not corrupt existing data.

### Where is the output stored?
Output is written to the Azure SQL database defined during install. Table names include `Correlation`, `LicenseData`, and `Results`.

### Can I re-run Discover with new plugins?
Yes. You may add new plugin files to the plugin directory and rerun the audit.

---

## Related Pages

- [Discover Overview](index.md)
- [Deployment](Deployment.md)
- [Usage Guide](Usage-Guide.md)
- [Reference](Reference.md)

