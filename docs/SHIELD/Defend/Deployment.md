# Deployment

The Defend module is deployed automatically as part of the SHIELD platform’s **Core Infrastructure deployment** process. It does not require any separate deployment scripts or packages.

This page clarifies when and how Defend becomes active, and what its dependencies are.

---

## When Is Defend Activated?

Defend becomes available immediately after the **Deploy Core Infrastructure** action is completed in the SHIELD UI.

This process provisions all objects that Defend needs in order to operate:

- Security groups by security class (Enterprise, Specialized, Privileged)
- Entra ID Administrative Units for lifecycle scope isolation
- Intune Scope Tags and associated device policies
- Lifecycle engine triggers and UI cards

Once this is complete, the **Lifecycle Device Management** and **Lifecycle User Management** cards appear in the SHIELD UI.

---

## No Separate Installer Required

There is no separate installer, script, or action to "deploy Defend."

Instead, this module is:

- **Provisioned as part of the Deploy module's infrastructure**
- **Enabled via the SHIELD web app** once infrastructure provisioning is complete

You can verify readiness by visiting `{your-subdomain}.azurewebsites.net` and checking that:

- The home screen includes Lifecycle action cards
- Clicking them loads the correct views with no warnings

---

## Prerequisites

To use Defend, the following must already be deployed:

- Core infrastructure via Deploy
- Required Entra ID roles (Global Reader, Security Admin)
- Devices or users exist in Entra ID and are synced with Intune (where applicable)
- Defender for Endpoint workspace is initialized (for device enforcement)

📖 [View Full Prerequisites](Prerequisites.md)

---

## Related Pages

- [Defend Overview](index.md)
- [Defend Usage Guide](Usage-Guide.md)
- [Defend Reference](Reference.md)
- [Troubleshooting](Troubleshooting.md)
- [SHIELD Platform Deployment](../Deployment.md)