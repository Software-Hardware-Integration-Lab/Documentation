# Disable Conditional Access Resilience Downgrade

## Description

This policy prevents Microsoft Entra Conditional Access resilience features from automatically downgrading security requirements during service outages or disruptions. It ensures that privileged identities remain protected even when Microsoft services experience availability issues. Instead of relaxing controls, organizations are expected to use break-glass accounts for emergency access.

## Why It's Important

This policy ensures Conditional Access requirements are never weakened during outages, allowing SHIELD to maintain strong protection for privileged identities and rely on break-glass accounts for continuity.

## Recommendations

- **Communicate** the removal of resilience fallback and reinforce break-glass access procedures. 
- **Stage** the rollout with a pilot group and validate emergency access. 
- **Test** behavior during service disruptions and confirm policy enforcement. 
- **Maintain** a rollback plan for operational continuity. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Conditional Access: Resilience defaults](https://learn.microsoft.com/en-us/entra/identity/conditional-access/resilience-defaults){:target="_blank"}

<br>

---
