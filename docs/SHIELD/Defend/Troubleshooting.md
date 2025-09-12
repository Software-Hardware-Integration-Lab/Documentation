# Troubleshooting

This section addresses common issues encountered when using the Defend module's lifecycle management features. It also offers clarification on edge cases, expected behaviors, and safe recovery actions.

---

## Issue: Devices not appearing in SHIELD UI

**Cause:**

- Devices are not hybrid-joined or cloud-joined to Entra ID
- Devices are not enrolled or synced into Intune

**Resolution:**

- Confirm the device is joined to Entra ID
- Ensure it is visible in the Intune portal ([https://intune.microsoft.com](https://intune.microsoft.com))
- Ensure it is not already managed by another tenant or stale registration

---

## Issue: Users not showing up when trying to commission

**Cause:**

- The user has already been onboarded
- The user is filtered out by Entra ID query
- Admin does not have required permissions

**Resolution:**

- Verify the user exists in Entra ID
- Confirm you're operating with Global Reader or User Administrator role
- Switch to a different security class to check other eligible users

---

## Issue: Lifecycle actions failing silently or UI not responding

**Cause:**

- Required Defender for Endpoint workspace is not initialized
- Scoped Intune tags are missing
- Conditional Access policies are not yet deployed

**Resolution:**

- Follow workspace setup verification steps in the [Usage Guide](Usage-Guide/index.md), under **Defender for Endpoint Workspace Creation**
- Check that SHIELD infrastructure was successfully deployed from the Deploy module
- Review prerequisites in [Defend Prerequisites](Prerequisites.md)

---

## Issue: Privileged device wipe triggered unexpectedly

**Cause:**

- Privileged commissioning/unassignment flow triggered without assigned users
- Attempted to assign a new user without retaining previous assignment

**Resolution:**

- Always include current assigned users in the assignment flow
- Ensure wipe behavior for privileged devices is clearly understood (see the [Usage Guide](Usage-Guide/index.md))

---

## Issue: Temporary credentials not saved after privileged user creation

**Cause:**

- Admin did not record credentials from the popup
- UI was closed or refreshed before saving

**Resolution:**

- Re-run commissioning with a new user
- Contact SHI if lifecycle audit recovery is needed

---

## FAQs

### Are lifecycle actions idempotent?

Yes. If a device or user is already managed, SHIELD will not reapply the same configuration unless it detects a mismatch.

### Can I reverse a decommission action?

No. Once a user or device is removed, it must be re-commissioned.

### Does the UI prevent mistakes?

Yes — warnings and confirmations are built into the UI. However, wipe actions for privileged devices occur automatically in certain workflows.

---

## Related Pages

- [Defend Usage Guide](Usage-Guide/index.md)
- [Defend Reference](Reference/index.md)
- [Defend Prerequisites](Prerequisites.md)
