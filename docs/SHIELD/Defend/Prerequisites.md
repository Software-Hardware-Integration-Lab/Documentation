# Prerequisites

The Defend module manages user and device lifecycle operations. Before using this module, the following prerequisites must be in place within your Microsoft 365 environment.

These requirements ensure that SHIELD can enforce security controls, commission resources, and assign users or devices to their correct roles.

---

## Infrastructure Requirements

The Defend module relies on infrastructure that must be deployed via the Deploy module. Specifically, the following must already exist:

- Core infrastructure has been deployed via the **Deploy Core Infrastructure** action
- Conditional Access policies are applied based on security class
- Entra ID Administrative Units and security groups are provisioned
- Intune is configured with scope tags

📖 See [SHIELD Platform Prerequisites](../Prerequisites/index.md)

---

## Role-Based Permissions

To use Defend’s lifecycle functionality, the signed-in admin must have the following roles in Entra ID:

| Role | Reason |
|------|--------|
| Global Reader | Required to enumerate users and devices |
| Security Administrator | Required for actions that interact with Defender and Intune APIs |
| User Administrator | Required for privileged user provisioning and removal |

---

## Device and User Sync

For SHIELD to manage identities and endpoints, the following must be true:

- Users are present in Entra ID
- Devices are registered or hybrid-joined with Entra ID
- Devices must be visible in Intune (for privileged device management)
- Users and devices must be assigned to the correct security class

---

## Defender for Endpoint Readiness

SHIELD uses Microsoft Defender for Endpoint to enforce privileged device controls. The Defender portal must have a provisioned workspace before certain lifecycle actions can succeed.

To verify:

1. Go to [Microsoft 365 Defender](https://security.microsoft.com){:target="_blank"}
2. Click on **Devices**
3. If a table of devices appears, your workspace is ready
4. If prompted to initialize setup, follow instructions and wait until the UI is fully active

📖 For more detail, see the [Defend Usage Guide](Usage-Guide/index.md), under **Defender for Endpoint Workspace Creation**

---

## Related Pages

- [Defend Deployment](Deployment.md)
- [Defend Usage Guide](Usage-Guide/index.md)
- [Hardware Requirements](Reference/index.md)
- [SHIELD Prerequisites](../Prerequisites/index.md)

