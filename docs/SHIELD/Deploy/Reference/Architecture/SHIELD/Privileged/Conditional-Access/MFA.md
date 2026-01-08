# Multi-Factor Authentication (MFA)

## Description

This policy enforces Multi-Factor Authentication (MFA) for privileged users during sign-in to Entra ID. It significantly reduces the risk of identity compromise by requiring a second factor of authentication beyond just a password.

## Why It's Important

This policy enforces MFA for privileged users, helping SHIELD prevent account compromise by requiring an additional factor beyond passwords.

## Recommendations

- **Communicate** the MFA requirement and provide setup guidance. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** MFA enforcement and user experience across platforms. 
- **Maintain** a rollback plan for access continuity. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Require multifactor authentication for all users](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-mfa-strength){:target="_blank"}

<br>

---
