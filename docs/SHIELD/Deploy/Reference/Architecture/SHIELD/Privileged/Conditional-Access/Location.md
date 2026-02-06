# Location

## Description

This policy blocks privileged identity authentication attempts from a set of problematic world regions, as defined by a named location based on IP geolocation. It helps prevent access from countries associated with elevated cybersecurity risks, geopolitical concerns, or regulatory restrictions.

## Why It's Important

This policy blocks privileged access attempts from high-risk or restricted regions, helping SHIELD reduce exposure to malicious activity and comply with geographic access requirements.

## Recommendations

- **Communicate** the geo-fencing policy and list of blocked regions. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** location-based access behavior and validate named location filters. 
- **Maintain** a rollback plan for access continuity. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1

## Learn More

- [Block access by location](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-block-by-location){:target="_blank"}

<br>

---
