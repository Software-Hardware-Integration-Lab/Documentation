# Authentication Methods

## Description

This policy enforces a specific set of acceptable authentication methods Entra ID sign-in, based on authentication strength. Only users in the included groups can authenticate, and only if they use approved authentication methods.

## Why It's Important

This policy enforces strong authentication methods for Entra ID sign-ins, ensuring SHIELD limits privileged access to approved, phishing-resistant factors only.

## Recommendations

- **Communicate** the enforcement of strong authentication methods and provide setup guidance. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** authentication strength enforcement and validate exclusions. 
- **Maintain** a rollback plan for access continuity. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Conditional Access authentication strengths](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths){:target="_blank"}

<br>

---