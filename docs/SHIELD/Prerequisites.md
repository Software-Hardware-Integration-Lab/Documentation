# Prerequisites

SHIELD is an enterprise product that requires specific licenses and configurations to deploy and use.

To simplify the documentation, we use the `M` prefix to refer to the different license types of Microsoft 365 licensing, such as `M1`, `M3`, `M5`, etc. This prefix can replace the other prefixes that indicate the type of organization, such as `E` for Enterprise, `A` for Education, `G` for Government, `F` for Frontline, and so on.

---

## Base Requirements

- [X] Deploying User has `Global Admin Rights` (for [manual deployment](Deploy/Deployment/Manual-Deployment.md) only)
- [X] Defender for Endpoint has had its [workspace created](Deploy/Usage-Guide/MDE-Enable.md)
- [X] Security Defaults [are shut off](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/concept-fundamentals-security-defaults#disabling-security-defaults) in Entra ID
- [X] Certificate Authentication is [disabled in the Entra ID authentication](https://learn.microsoft.com/en-us/azure/active-directory/authentication/how-to-certificate-based-authentication#step-2-enable-cba-on-the-tenant) methods for SHIELD's ESM, SSM and PSM root security groups

---

## ESM

- [X] `M3` [or equivalent](https://go.microsoft.com/fwlink/?linkid=2139145){:target="_blank"} licenses are purchased and enabled in the target tenant
- [X] Devices to be managed through SHIELD need to be either Hybrid or Cloud only joined

---

## SSM

- [X] `M5` [or equivalent](https://go.microsoft.com/fwlink/?linkid=2139145){:target="_blank"} licenses are purchased and enabled in the target tenant
- [X] Devices to be managed through SHIELD need to be either Hybrid or Cloud only joined

---

## PSM

- [X] `M5` [or equivalent](https://go.microsoft.com/fwlink/?linkid=2139145){:target="_blank"} licenses are purchased and enabled in the target tenant
- [X] Secure Core Certified hardware. Please see the [hardware selection](Defend/Reference/Architecture/Hardware-Selection.md) documentation for details
- [X] Devices need to be registered in Autopilot to be allowed to be commissioned into a PAW
