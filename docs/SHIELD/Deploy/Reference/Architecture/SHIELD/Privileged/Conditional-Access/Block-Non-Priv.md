# Block Non-Privileged

## Description

This policy prevents non-privileged users from signing in to privileged devices—specifically those designated for sensitive operations. It ensures that only authorized, privileged identities can access high-trust endpoints, reducing the risk of lateral movement, data exposure, or misuse of privileged infrastructure.

## Why It's Important

This policy restricts privileged devices to privileged identities only, ensuring SHIELD prevents unauthorized users from accessing sensitive endpoints and reducing the risk of lateral movement.

## Recommendations

- **Communicate** the restriction of privileged devices to privileged users only. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** access behavior across user types and validate exclusions. 
- **Maintain** a rollback plan for operational flexibility. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices){:target="_blank"}

<br>

---