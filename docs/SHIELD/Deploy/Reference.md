# Reference

This reference section provides technical specifications and supporting details for SHIELD’s Deploy module, including identity protection policies and configuration recommendations that align with the SPA architecture.

---

## Identity Protection Policy Configuration

The Deploy module provisions policies to restrict sign-in to privileged accounts under specific conditions, enforcing Microsoft's guidance around secure administrative access.

These policies are designed to:

- Detect high-risk sign-in events
- Block access to privileged resources if risk conditions are met
- Route access through compliant devices and monitored interfaces

This aligns with Microsoft’s Zero Trust security model and helps enforce separation between administrative and user environments.

---

### Key Concepts

- **Policy Scope**: Only applies to privileged role-holding users (PAWs)
- **Conditions Evaluated**:
  - Sign-in risk level
  - Device compliance state
  - Location and interface origin
- **Actions Taken**:
  - Block sign-in
  - Require MFA or compliant device
  - Redirect to monitored jump station if policy fails

!!! note "SHIELD Default Behavior"
    These identity protection policies are deployed automatically when Core Infrastructure is deployed via the SHIELD UI.

---

## Related Reference Docs

Additional SPA-related configuration details are available in the global [Reference Guide](../Reference.md), including:

- Full lifecycle flow diagrams
- Microsoft Graph permissions required by SHIELD
- Hardware and certification requirements for SPA devices

---

## Related Pages

- [Deploy Overview](index.md)
- [Deployment](Deployment.md)
- [Deploy Usage Guide](Usage-Guide.md)
- [Troubleshooting](Troubleshooting.md)

