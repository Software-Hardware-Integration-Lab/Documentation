# Prerequisites

Before deploying SHIELD or using Discover, ensure your environment meets all license, configuration, permission, and software requirements.

This page is divided into two parts:

1. [SHIELD Core Platform Requirements](#shield-core-platform-requirements)  
2. [Discover System Requirements](#discover-system-requirements)

---

## SHIELD Core Platform Requirements

SHIELD automates secure deployment and lifecycle management using Microsoft 365 and Azure. It requires specific license levels, identity configurations, and Microsoft Defender components.

### Environment Requirements

- ✅ Deploying user must have **Global Admin Rights**  
- ✅ Microsoft Defender for Endpoint must be provisioned. See [Defend Usage Guide](../Defend/Usage-Guide/index.md), under **Defender for Endpoint Workspace Creation**
- ✅ [Security Defaults](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/concept-fundamentals-security-defaults#disabling-security-defaults) must be disabled in Entra ID  
- ✅ [Certificate Authentication](https://learn.microsoft.com/en-us/azure/active-directory/authentication/how-to-certificate-based-authentication#step-2-enable-cba-on-the-tenant) must be disabled for SHIELD’s security groups

---

### Licensing Requirements by Mode

SHIELD uses `M3` and `M5` to refer to Microsoft 365 license families, abstracting E3/E5 and similar plans.

| Mode | License | Additional Requirements |
|------|---------|--------------------------|
| **ESM** (Enterprise Security Mode) | M3 or equivalent | Devices must be Hybrid or Cloud Joined |
| **SSM** (Specialized Security Mode) | M5 or equivalent | Devices must be Hybrid or Cloud Joined |
| **PSM** (Privileged Security Mode) | M5 or equivalent | Devices must be Autopilot-registered and [Secure Core Certified](../Defend/Reference/Hardware-Selection.md) |

---

## Discover System Requirements

Discover is a component of SHIELD that audits licensing configuration, queries Microsoft APIs, and stores analysis in SHI - Data Gateway. The following setup is required.

- Discover requires no Microsoft Licensing to operate.
- Discover requires the same dependencies (minus licenses) as SHIELD's core system.

---

### Entra ID Role Permissions

Discover uses read-only Entra ID roles for configuration queries. These permissions are scoped with the principle of least privilege.

| Role | Required For |
|------|---------------|
| **Global Reader** | Basic environment access (Defender, Entra ID) |
| **Security Administrator** | Access to Defender for Endpoint & Identity APIs |
| **User Administrator** | Access to user directory properties |

**Related plugin guides:**
docs\SHIELD\Reference\Plugins\DefenderEndpoint.md

- 📄 [Defender for Endpoint](../Discover/Plugins/DefenderEndpoint.md)  
- 📄 [Defender for Identity](../Discover/Plugins/DefenderIdentity.md)  
- 📄 [Entra ID](../Discover/Plugins/EntraID.md)

!!! info "Permissions Note"
    Discover will never modify your configuration. All operations are read-only and scoped to data retrieval.

---

## Related Pages

- 📄 [Hardware Requirements](../Defend/Reference/Hardware-Selection.md)  
- 📄 [Deployment Guide](../Getting-Started.md)  
