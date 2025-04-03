# Uninstall

This section covers how to uninstall or reset SHIELD's Deploy module infrastructure and outlines common considerations for support and recovery scenarios.

---

## Uninstalling SHIELD Deploy Infrastructure

The SHIELD platform uses multiple Microsoft 365 services to create configuration components. Removing these components manually is complex and can break your tenant setup. Use the provided uninstall script only if directed by SHI support.

!!! danger "Data Loss Warning"
    If you uninstall the architecture, **you will clear out any managed objects and configurations** deployed by the Deploy module. This procedure should only be followed if SHI explicitly instructs you to do so.

!!! note "Stateless Server Reminder"
    SHIELD’s application server is stateless. You can safely redeploy the app after cleanup without losing data stored in the Microsoft cloud (e.g., Intune tags, Entra groups).

---

## Uninstall Procedure

1. **Stop the SHIELD server** to prevent regeneration of infrastructure during cleanup.

2. **Download the uninstall script**:

   📥 [Uninstall-ShieldArchitecture.ps1](../Scripts/Uninstall-ShieldArchitecture.ps1)

3. **Remove all Microsoft.Graph modules** to prevent version conflicts:

   ```powershell
   Get-Module -Name '*Microsoft.Graph*' -ListAvailable | Uninstall-Module
   ```

!!! note
        You may have to run the above command twice because the order of operations tries to uninstall a dependency first rather than last. Running it the second time will remove the remaining dependency.

4. **Install the correct version of Microsoft Graph Beta modules**:

   ```powershell
   Install-Module -Name 'Microsoft.Graph.Beta' -RequiredVersion '2.1.0' -Scope 'AllUsers'
   ```

5. **Run the uninstall script** to remove SHIELD-deployed infrastructure.

   The script is designed to remove:
   - Entra ID groups and admin units
   - Intune scope tags
   - Conditional Access policies created by SHIELD

   It does **not** delete data outside the SHIELD-deployed infrastructure.

---

## FAQs & Recovery Notes

### What if the uninstall script fails?

Try re-running the script. It is designed to be idempotent and will retry safely. Make sure you have proper permissions and the correct PowerShell modules installed.

### Can I re-deploy SHIELD after uninstalling?

Yes. SHIELD can be redeployed using the same app interface or script, as long as all infrastructure components have been successfully removed.

### What is not removed?

- Audit logs in Entra ID
- Device enrollment history
- Local device configurations if not managed via Intune

---

## Related Pages

- [Deploy Overview](../Deploy/index.md)
- [Deploy Usage Guide](../Deploy/Usage-Guide.md)
- [Deployment](../Deploy/Deployment/index.md)
- [Deploy Reference](../Deploy/Reference/index.md)

