# User Risk

## Description

This policy blocks access to Entra ID for users who are flagged with any level of user risk—low, medium, or high—as determined by Microsoft Entra ID’s risk detection engine. It’s designed to protect privileged access by preventing authentication from accounts that may be compromised.

## Why It's Important

This policy blocks privileged access for accounts flagged with user risk, helping SHIELD prevent compromised identities from authenticating and protecting sensitive operations.

## Recommendations

- **Communicate** the policy change and how user risk affects access. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** risk detection accuracy and user impact. 
- **Maintain** a rollback plan for rapid response to issues. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P2 and a standalone license for Microsoft Defender for Cloud Apps

## Learn More

- [User risk detections](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks#user-risk-detections){:target="_blank"}

<br>

---
