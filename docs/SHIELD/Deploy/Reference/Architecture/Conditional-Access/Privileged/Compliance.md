# Compliance

## Description

This policy enforces that privileged devices must be compliant with their Intune compliance policies before they can access any cloud applications

## Why It's Important

This policy ensures privileged devices meet Intune compliance requirements before accessing cloud apps, allowing SHIELD to block noncompliant or insecure endpoints from sensitive resources.

## Recommendations

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
