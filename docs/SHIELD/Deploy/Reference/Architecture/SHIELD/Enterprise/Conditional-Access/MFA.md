# Multi-Factor Authentication (MFA)

## Description

This policy enforces multi-factor authentication (MFA) for enterprise identities during sign-in to reduce the risk of identity compromise.

## Why It's Important

Passwords alone are insufficient to protect privileged access. This policy ensures that users in key enterprise groups must verify their identity using a second factor, such as a mobile app or hardware token, before accessing any cloud application. By excluding break-glass accounts, it maintains emergency access while enforcing strong authentication for all other users, supporting a zero-trust security model

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