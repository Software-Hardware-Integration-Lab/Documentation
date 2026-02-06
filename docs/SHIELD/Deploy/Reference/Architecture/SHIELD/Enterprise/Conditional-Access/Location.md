# Location

## Description

This policy blocks enterprise identity authentication attempts from specific geographic regions identified as high-risk, based on IP geolocation.

## Why It's Important

Certain countries pose elevated cybersecurity threats due to geopolitical instability, regulatory concerns, or known malicious activity. This policy uses a named location filter to prevent sign-ins from these regions, helping to enforce geo-fencing and reduce exposure to unauthorized access attempts. It supports a zero-trust strategy by ensuring authentication only occurs from trusted geographic zones.

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