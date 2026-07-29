# Entra Conditional Access

# Enterprise

---

## Compliance

### Description

This policy enforces that enterprise-class users must authenticate using a device that meets compliance standards defined in Intune.

### Why It's Important

Requiring compliant devices ensures that only endpoints with approved configurations, security controls, and health status can access corporate resources. This policy helps prevent access from unmanaged or misconfigured devices, reducing the risk of data leakage, malware propagation, and unauthorized access. It supports a zero-trust model by validating device posture before granting access.

### Recommendations

- **Communicate** the requirement for compliant devices and provide remediation guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** device compliance enforcement and validate Intune reporting.
- **Maintain** a rollback plan for operational resilience.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1
- Microsoft Intune

### Learn More

- [Require device compliance with Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-device-compliance){:target="_blank"}

---

## Location

### Description

This policy blocks enterprise identity authentication attempts from specific geographic regions identified as high-risk, based on IP geolocation.

### Why It's Important

Certain countries pose elevated cybersecurity threats due to geopolitical instability, regulatory concerns, or known malicious activity. This policy uses a named location filter to prevent sign-ins from these regions, helping to enforce geo-fencing and reduce exposure to unauthorized access attempts. It supports a zero-trust strategy by ensuring authentication only occurs from trusted geographic zones.

### Recommendations

- **Communicate** the geo-fencing policy and list of blocked regions.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** location-based access behavior and validate named location filters.
- **Maintain** a rollback plan for access continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Block access by location](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-block-by-location){:target="_blank"}

---

## Microsoft Defender for Cloud Applications (MDCA)

### Description

This policy integrates Microsoft Defender for Cloud Apps (MDCA) with enterprise identity access to enable real-time monitoring and control over user sessions.

### Why It's Important

MDCA provides visibility into user activity and enforces session-level controls across cloud applications. By enabling this integration, the policy allows for conditional access enforcement based on risk signals, user behavior, and compliance status. It helps detect anomalies, prevent data exfiltration, and apply granular access restrictions, strengthening enterprise security posture without disrupting productivity.

### Recommendations

- **Communicate** the integration of MDCA and its impact on session monitoring.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** session control behavior and validate MDCA enforcement.
- **Maintain** a rollback plan for operational flexibility.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1
- Microsoft Defender for Cloud Apps

### Learn More

- [Conditional Access app control in Microsoft Defender for Cloud Apps](https://learn.microsoft.com/en-us/defender-cloud-apps/proxy-intro-aad){:target="_blank"}

---

## Multi-Factor Authentication (MFA)

### Description

This policy enforces multi-factor authentication (MFA) for enterprise identities during sign-in to reduce the risk of identity compromise.

### Why It's Important

Passwords alone are insufficient to protect privileged access. This policy ensures that users in key enterprise groups must verify their identity using a second factor, such as a mobile app or hardware token, before accessing any cloud application. By excluding break-glass accounts, it maintains emergency access while enforcing strong authentication for all other users, supporting a zero-trust security model

### Recommendations

- **Communicate** the MFA requirement and provide setup guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** MFA enforcement and user experience across platforms.
- **Maintain** a rollback plan for access continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Require multifactor authentication for all users](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-mfa-strength){:target="_blank"}

---

---

# Privileged

---

## Authentication Methods

### Description

This policy enforces a specific set of acceptable authentication methods for Entra ID sign-in, based on authentication strength. Only users in the included groups can authenticate, and only if they use approved authentication methods.

### Why It's Important

This policy enforces strong authentication methods for Entra ID sign-ins, ensuring SHIELD limits privileged access to approved, phishing-resistant factors only.

### Recommendations

- **Communicate** the enforcement of strong authentication methods and provide setup guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** authentication strength enforcement and validate exclusions.
- **Maintain** a rollback plan for access continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Conditional Access authentication strengths](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths){:target="_blank"}

---

## Block Non-Privileged

### Description

This policy prevents non-privileged users from signing in to privileged devices—specifically those designated for sensitive operations. It ensures that only authorized, privileged identities can access high-trust endpoints, reducing the risk of lateral movement, data exposure, or misuse of privileged infrastructure.

### Why It's Important

This policy restricts privileged devices to privileged identities only, ensuring SHIELD prevents unauthorized users from accessing sensitive endpoints and reducing the risk of lateral movement.

### Recommendations

- **Communicate** the restriction of privileged devices to privileged users only.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** access behavior across user types and validate exclusions.
- **Maintain** a rollback plan for operational flexibility.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices){:target="_blank"}

---

## Compliance

### Description

This policy enforces that privileged devices must be compliant with their Intune compliance policies before they can access any cloud applications.

### Why It's Important

This policy ensures privileged devices meet Intune compliance requirements before accessing cloud apps, allowing SHIELD to block noncompliant or insecure endpoints from sensitive resources.

### Recommendations

- **Communicate** the requirement for compliant devices and provide remediation guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** device compliance enforcement and validate Intune reporting.
- **Maintain** a rollback plan for operational resilience.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1
- Microsoft Intune

### Learn More

- [Require device compliance with Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-device-compliance){:target="_blank"}

---

## Disable Conditional Access Resilience Downgrade

### Description

This policy prevents Microsoft Entra Conditional Access resilience features from automatically downgrading security requirements during service outages or disruptions. It ensures that privileged identities remain protected even when Microsoft services experience availability issues. Instead of relaxing controls, organizations are expected to use break-glass accounts for emergency access.

### Why It's Important

This policy ensures Conditional Access requirements are never weakened during outages, allowing SHIELD to maintain strong protection for privileged identities and rely on break-glass accounts for continuity.

### Recommendations

- **Communicate** the removal of resilience fallback and reinforce break-glass access procedures.
- **Stage** the rollout with a pilot group and validate emergency access.
- **Test** behavior during service disruptions and confirm policy enforcement.
- **Maintain** a rollback plan for operational continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Conditional Access: Resilience defaults](https://learn.microsoft.com/en-us/entra/identity/conditional-access/resilience-defaults){:target="_blank"}

---

## Hardware Enforcement

### Description

This policy ensures that only approved and commissioned hardware is allowed to authenticate to Entra ID. It blocks access from any device that does not meet specific manufacturer, model, and custom attribute criteria—enforcing strict control over the physical devices used by privileged identities.

### Why It's Important

This policy enforces that only approved hardware can access privileged accounts, allowing SHIELD to block untrusted or rogue devices and maintain strict control over sensitive operations.

### Recommendations

- **Communicate** the restriction to approved hardware and provide verification guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** hardware enforcement and validate device attribute filtering.
- **Maintain** a rollback plan for operational flexibility.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices){:target="_blank"}

---

## Join Type

### Description

This policy ensures that only devices joined directly to Microsoft Entra ID (formerly Azure AD) are allowed to authenticate privileged identities. It blocks access from hybrid-joined or Bring Your Own Device (BYOD) endpoints, helping prevent unauthorized or unmanaged devices from injecting into privileged workflows.

### Why It's Important

This policy restricts privileged access to Entra ID-joined devices only, ensuring SHIELD blocks unmanaged or hybrid endpoints from being used to compromise sensitive workflows.

### Recommendations

- **Communicate** the restriction to Entra ID-joined devices and provide transition guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** device join type enforcement and validate exclusions.
- **Maintain** a rollback plan for operational flexibility.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices){:target="_blank"}

---

## Legacy Authentication

### Description

This policy blocks the use of legacy authentication protocols—such as Exchange ActiveSync and other non-modern clients—for privileged identities.

### Why It's Important

This policy blocks legacy authentication for privileged identities, helping SHIELD prevent attackers from exploiting outdated protocols that bypass modern security controls like MFA.

### Recommendations

- **Communicate** the deprecation of legacy authentication and provide transition guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** for legacy protocol usage and validate enforcement.
- **Maintain** a rollback plan for operational continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Block legacy authentication with Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-block-legacy-authentication){:target="_blank"}

---

## Location

### Description

This policy blocks privileged identity authentication attempts from a set of problematic world regions, as defined by a named location based on IP geolocation. It helps prevent access from countries associated with elevated cybersecurity risks, geopolitical concerns, or regulatory restrictions.

### Why It's Important

This policy blocks privileged access attempts from high-risk or restricted regions, helping SHIELD reduce exposure to malicious activity and comply with geographic access requirements.

### Recommendations

- **Communicate** the geo-fencing policy and list of blocked regions.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** location-based access behavior and validate named location filters.
- **Maintain** a rollback plan for access continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P1

### Learn More

- [Block access by location](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-block-by-location){:target="_blank"}

---

## Multi-Factor Authentication (MFA)

### Description

This policy enforces Multi-Factor Authentication (MFA) for privileged users during sign-in to Entra ID. It significantly reduces the risk of identity compromise by requiring a second factor of authentication beyond just a password.

### Why It's Important

This policy enforces MFA for privileged users, helping SHIELD prevent account compromise by requiring an additional factor beyond passwords.

### Recommendations

- **Communicate** the MFA requirement and provide setup guidance.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** MFA enforcement and user experience across platforms.
- **Maintain** a rollback plan for access continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirement

- Microsoft Entra ID P1

### Learn More

- [Require multifactor authentication for all users](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-mfa-strength){:target="_blank"}

---

## Operating System Enforcement

### Description

This policy ensures that only devices running Windows are allowed to authenticate to Entra ID. It blocks access from all other operating systems, helping enforce a standardized and secure platform for privileged access.

### Why It's Important

This policy restricts privileged access to Windows devices only, enabling SHIELD to enforce a standardized platform and reduce risks from unmanaged or unsupported operating systems.

### Recommendations

- **Communicate** the change and explain the Windows-only access requirement.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** platform access behavior and validate exclusions.
- **Maintain** a rollback plan for operational continuity.
- **Enforce** the policy broadly after successful validation.

### License Requirement

- Microsoft Entra ID P1

### Learn More

- [Conditional Access: Filter for devices](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-devices#common-scenarios){:target="_blank"}

---

## Session Persistence

### Description

This policy disables persistent browser sessions for privileged users, ensuring that identity revalidation occurs as frequently as possible. It helps reduce the risk of unauthorized access due to session hijacking or stale authentication tokens.

### Why It's Important

This policy requires privileged users to reauthenticate frequently, helping SHIELD reduce the risk of session hijacking and misuse of stale tokens.

### Recommendations

- **Communicate** the change to users, highlighting the impact on session behavior.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** authentication frequency and user experience.
- **Maintain** a rollback plan to address potential disruptions.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P2

### Learn More

- [Configure adaptive session lifetime policies](https://learn.microsoft.com/en-us/entra/identity/conditional-access/howto-conditional-access-session-lifetime){:target="_blank"}

---

## Sign-in Risk

### Description

This policy blocks access to Entra ID for users whose sign-in attempts are flagged with any level of risk—low, medium, or high. It’s designed to prevent access from potentially compromised or suspicious sign-in sessions, especially for privileged users.

### Why It's Important

This policy blocks risky sign-ins for privileged users, allowing SHIELD to prevent access from potentially compromised sessions and reduce the chance of account takeover.

### Recommendations

- **Communicate** the policy change and its impact on risky sign-ins.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** sign-in behavior and risk detection accuracy.
- **Maintain** a rollback plan for quick recovery if needed.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P2 and a standalone license for Microsoft Defender for Cloud Apps

### Learn More

- [Require multifactor authentication for elevated sign-in risk](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-risk-based-sign-in){:target="_blank"}

---

## Token Binding

### Description

This policy is designed to prevent token theft from Microsoft Exchange Online (EXO) and SharePoint Online (SPO) clients by enforcing secure session controls for privileged users.

### Why It's Important

This policy protects against token theft by binding access tokens to secure sessions, ensuring attackers cannot reuse stolen tokens to bypass SHIELD identity and access controls.

### Recommendations

- **Communicate** the policy change and its impact to affected users.
- **Stage** the rollout by piloting with a small, controlled group.
- **Test** functionality and user experience across supported platforms.
- **Maintain** a rollback plan to quickly respond to any issues.
- **Enforce** the policy broadly once validated and stable.

### License Requirements

- P2 License

### Learn More

- [Token Protection in Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-token-protection){:target="_blank"}

---

## User Risk

### Description

This policy blocks access to Entra ID for users who are flagged with any level of user risk—low, medium, or high—as determined by Microsoft Entra ID’s risk detection engine. It’s designed to protect privileged access by preventing authentication from accounts that may be compromised.

### Why It's Important

This policy blocks privileged access for accounts flagged with user risk, helping SHIELD prevent compromised identities from authenticating and protecting sensitive operations.

### Recommendations

- **Communicate** the policy change and how user risk affects access.
- **Stage** the rollout with a pilot group and exclude critical accounts.
- **Test** risk detection accuracy and user impact.
- **Maintain** a rollback plan for rapid response to issues.
- **Enforce** the policy broadly after successful validation.

### License Requirements

- Microsoft Entra ID P2 and a standalone license for Microsoft Defender for Cloud Apps

### Learn More

- [User risk detections](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks#user-risk-detections){:target="_blank"}