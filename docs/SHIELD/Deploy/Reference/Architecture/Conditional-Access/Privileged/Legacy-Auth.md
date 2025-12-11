# Legacy Authentication

## Description

This policy blocks the use of legacy authentication protocols—such as Exchange ActiveSync and other non-modern clients—for privileged identities. 

## Why It's Important

This policy blocks legacy authentication for privileged identities, helping SHIELD prevent attackers from exploiting outdated protocols that bypass modern security controls like MFA.

## Recommendations

- **Communicate** the deprecation of legacy authentication and provide transition guidance. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** for legacy protocol usage and validate enforcement. 
- **Maintain** a rollback plan for operational continuity. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Block legacy authentication with Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-block-legacy-authentication){:target="_blank"}

<br>

---
