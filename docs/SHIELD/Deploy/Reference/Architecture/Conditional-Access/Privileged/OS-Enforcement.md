# Operating System Enforcement

## Description

This policy ensures that only devices running Windows are allowed to authenticate to Entra ID It blocks access from all other operating systems, helping enforce a standardized and secure platform for privileged access.

## Why It's Important

This policy restricts privileged access to Windows devices only, enabling SHIELD to enforce a standardized platform and reduce risks from unmanaged or unsupported operating systems.

## Recommendations

- **Communicate** the change and explain the Windows-only access requirement. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** platform access behavior and validate exclusions. 
- **Maintain** a rollback plan for operational continuity. 
- **Enforce** the policy broadly after successful validation

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices#common-scenarios){:target="_blank"}

<br>

---
