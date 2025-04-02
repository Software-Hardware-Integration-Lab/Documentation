# Overview

The Defend module is responsible for all lifecycle operations within the SHIELD platform. It provides user and device onboarding, offboarding, access enforcement, and enforcement of privileged workflows in alignment with the SPA model deployed by the Deploy module.

Whereas the Deploy module provisions the infrastructure, **Defend is responsible for using that infrastructure to manage the identities and devices inside it**.

---

## What Defend Manages

- Commissioning and decommissioning users and devices
- Assigning privileged users to privileged devices (PAWs)
- Automatic Intune and Entra ID tagging
- Lifecycle management rules based on selected security class

All these actions are exposed via the SHIELD Lifecycle UI and the platform’s API endpoints.

---

## Security Class Enforcement

Defend strictly applies the lifecycle rules associated with each of SHIELD’s supported security classes:

- **Enterprise (ESM)** – standard business users and workstations
- **Specialized (SSM)** – elevated or regulated roles and systems
- **Privileged (PSM)** – most secure tier, requires clean hardware, wipes on commission/unassign, and restricted access boundaries

The class is selected in the UI prior to performing any lifecycle action. 

---

## Entry Points

After the SHIELD infrastructure is deployed, the Defend module is accessed via the SHIELD UI home screen:

- **Lifecycle Device Management** – for commissioning, decommissioning, assignment, and unassignment
- **Lifecycle User Management** – for onboarding and offboarding privileged and standard users

The lifecycle engine handles all object mapping, Intune tagging, group membership, and access scope enforcement automatically based on your selections.

---

## Related Pages

- [Deployment](Deployment.md)
- [Prerequisites](Prerequisites.md)
- [Usage Guide](Usage-Guide/index.md)
- [Reference](Reference/index.md)
- [Troubleshooting](Troubleshooting.md)

