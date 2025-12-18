# Compliance

## Description

This policy enforces that enterprise-class users must authenticate using a device that meets compliance standards defined in Intune.

## Why It's Important

Requiring compliant devices ensures that only endpoints with approved configurations, security controls, and health status can access corporate resources. This policy helps prevent access from unmanaged or misconfigured devices, reducing the risk of data leakage, malware propagation, and unauthorized access. It supports a zero-trust model by validating device posture before granting access.

## Recommendations:

- **Communicate** the requirement for compliant devices and provide remediation guidance. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** device compliance enforcement and validate Intune reporting. 
- **Maintain** a rollback plan for operational resilience. 
- **Enforce** the policy broadly after successful validation.


## License Requirements

- Microsoft Entra ID P1
- Microsoft Intune

## Learn More

- [Require device compliance with Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-device-compliance){:target="_blank"}

<br>

---