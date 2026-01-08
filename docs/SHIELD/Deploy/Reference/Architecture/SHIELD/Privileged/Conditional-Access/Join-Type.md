# Join Type

## Description

This policy ensures that only devices joined directly to Microsoft Entra ID (formerly Azure AD) are allowed to authenticate privileged identities. It blocks access from hybrid-joined or Bring Your Own Device (BYOD) endpoints, helping prevent unauthorized or unmanaged devices from injecting into privileged workflows.

## Why It's Important

This policy restricts privileged access to Entra ID-joined devices only, ensuring SHIELD blocks unmanaged or hybrid endpoints from being used to compromise sensitive workflows.

## Recommendations

- **Communicate** the restriction to Entra ID-joined devices and provide transition guidance. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** device join type enforcement and validate exclusions. 
- **Maintain** a rollback plan for operational flexibility. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices){:target="_blank"}

<br>

---
