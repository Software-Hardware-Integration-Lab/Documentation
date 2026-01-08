# Hardware Enforcement

## Description

This policy ensures that only approved and commissioned hardware is allowed to authenticate to Entra ID. It blocks access from any device that does not meet specific manufacturer, model, and custom attribute criteria—enforcing strict control over the physical devices used by privileged identities.

## Why It's Important

This policy enforces that only approved hardware can access privileged accounts, allowing SHIELD to block untrusted or rogue devices and maintain strict control over sensitive operations.

## Recommendations

- **Communicate** the restriction to approved hardware and provide verification guidance. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** hardware enforcement and validate device attribute filtering. 
- **Maintain** a rollback plan for operational flexibility. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices){:target="_blank"}

<br>

---
