# Microsoft Defender for Cloud Applications (MDCA)

## Description

This policy integrates Microsoft Defender for Cloud Apps (MDCA) with enterprise identity access to enable real-time monitoring and control over user sessions.

## Why It's Important

MDCA provides visibility into user activity and enforces session-level controls across cloud applications. By enabling this integration, the policy allows for conditional access enforcement based on risk signals, user behavior, and compliance status. It helps detect anomalies, prevent data exfiltration, and apply granular access restrictions, strengthening enterprise security posture without disrupting productivity.

## Recommendations

- **Communicate** the integration of MDCA and its impact on session monitoring. 
- **Stage** the rollout with a pilot group and exclude critical accounts. 
- **Test** session control behavior and validate MDCA enforcement. 
- **Maintain** a rollback plan for operational flexibility. 
- **Enforce** the policy broadly after successful validation.

## License Requirements

- Microsoft Entra ID P1 
- Microsoft Defender for Cloud Apps

## Learn More

- [Conditional Access app control in Microsoft Defender for Cloud Apps](https://learn.microsoft.com/en-us/defender-cloud-apps/proxy-intro-aad){:target="_blank"}

<br>

---