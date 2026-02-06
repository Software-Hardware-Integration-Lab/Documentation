# Sign-in Risk

## Description

This policy blocks access to Entra ID for users whose sign-in attempts are flagged with any level of risk—low, medium, or high. It’s designed to prevent access from potentially compromised or suspicious sign-in sessions, especially for privileged users.

## Why It's Important

This policy blocks risky sign-ins for privileged users, allowing SHIELD to prevent access from potentially compromised sessions and reduce the chance of account takeover.

## Recommendations

- **Communicate** the policy change and its impact on risky sign-ins. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** sign-in behavior and risk detection accuracy. 
- **Maintain** a rollback plan for quick recovery if needed. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P2 and a standalone license for Microsoft Defender for Cloud Apps

## Learn More

- [Require multifactor authentication for elevated sign-in risk](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-risk-based-sign-in){:target="_blank"}

<br>

---
