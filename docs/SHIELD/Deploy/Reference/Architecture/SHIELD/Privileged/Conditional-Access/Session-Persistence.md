# Session Persistence

## Description

This policy disables persistent browser sessions for privileged users, ensuring that identity revalidation occurs as frequently as possible. It helps reduce the risk of unauthorized access due to session hijacking or stale authentication tokens.

## Why It's Important

This policy requires privileged users to reauthenticate frequently, helping SHIELD reduce the risk of session hijacking and misuse of stale tokens.

## Recommendations

- **Communicate** the change to users, highlighting the impact on session behavior. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** authentication frequency and user experience. 
- **Maintain** a rollback plan to address potential disruptions. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P2

## Learn More

- [Configure adaptive session lifetime policies](https://learn.microsoft.com/en-us/entra/identity/conditional-access/howto-conditional-access-session-lifetime){:target="_blank"}

<br>

---
