Conditional Access Policies are critical to how Entra ID secures sign in.
Below are the list of policies that are automatically deployed and why they are necessary for securing privileged access.

## MSM - Compliance

- **Setting Name:** MSM - Compliance
- **Type of Policy:** Conditional Access
- **Description:**
Requires devices to be marked as compliant and requires MFA sign in
- **Why it is needed (what does it secure against):**
Forces devices to be managed devices and requires MFA to protect all cloud apps. Protects against credential theft or any any attempt to password spray, brute force, or otherwise reuse credentials.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a principal in the Privileged device Devices or Privileged User group attempts to access any cloud app.

## MSM - User Risk

- **Setting Name:** MSM - User Risk
- **Description:**
Prevents signing in if user has a user risk of Low/Medium/High
- **Why it is needed (what does it secure against):**
If a user risk of Low/Medium/High is detected, it will block the sign in. Prevents attacks that attempt to reuse credentials in unfamiliar locations from risky IPs(as determined by Microsoft Threat Intelligence), and from suspicious behavior.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a principal in the Privileged device Devices or Privileged User group attempts to access any cloud app with a user risk of Low/Medium/High, their sign in will be blocked.

## MSM - Sign-in Risk

- **Setting Name:** MSM - Sign-in Risk
- **Description:**
Prevents signing in if user has a sign-in risk of Low/Medium/High
- **Why it is needed (what does it secure against):**
If a sign-in risk of Low/Medium/High is detected, it will block the sign in. This will protect against unfamiliar location sign in attempts that the principal has not signed in from before.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a principal in the Privileged device Devices or Privileged User group attempts to access any cloud app with a sign-in risk of Low/Medium/High, their sign in will be blocked.

## MSM - OS Enforcement

- **Setting Name:** MSM - OS Enforcement
- **Description:**
Prevents signing in if user is NOT using Windows OS
- **Why it is needed (what does it secure against):**
Ensures sign ins are only coming from Windows OS machines. Protects against attackers attempting to utilize other operating systems.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a principal in the in Privileged device Devices or Privileged Users attempts to sign into any cloud app from a NON Windows OS, their sign in will be blocked.

## MSM - Location

- **Setting Name:** MSM - Location
- **Description:**
Prevents signing in if user is in a known risky location
- **Why it is needed (what does it secure against):**
Ensures sign ins are only coming from United States based IPs. Protects against credential theft.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a principal in the Privileged device Devices or Privileged Users attempts to sign into any cloud app from outside the United States, their sign in will be blocked.

## MSM - Legacy Auth

- **Setting Name:** MSM - Legacy Auth
- **Description:**
Prevents signing in if user is utilizing legacy authentication such as Exchange ActiveSync, POP, IMAP, SMTP.
- **Why it is needed (what does it secure against):**
Ensures sign ins are only coming from modern authentication.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a principal in the Privileged device Devices or Privileged Users attempts to sign into any cloud app utilizing legacy authentication, their sign in will be blocked.

## MSM - Hardware Enforcement

- **Setting Name:** MSM - Hardware Enforcement
- **Description:**
Prevents signing in if user is not signing in from a Privileged device configured device. Devices must meet the naming convention set through Intune Autopilot and a custom extension attribute to be allowed sign in from this policy.
- **Why it is needed (what does it secure against):**
Ensures sign ins are only coming from Privileged device configured devices. Protects against privilege escalation attempts from other devices managed by the organization, but are not Privileged devices.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a principal in the Privileged device Devices or Privileged Users attempts to sign into any cloud app utilizing a device not meeting the custom extension attribute and not falling under the autopilot naming convention, their sign in will be blocked.

## MSM - MCAS

- **Setting Name:** MSM - MCAS
- **Description:**
Sends all cloud sessions over to Microsoft Cloud App Security
- **Why it is needed (what does it secure against):**
Ensures sessions are going over to Microsoft Cloud App Security for tracking, additional policy configuration, and security controls.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When any principal from Privileged device Devices or Privileged Users accesses any cloud app.

## MSM - MFA

- **Setting Name:** MSM - MFA
- **Description:**
Requires a multi-factor credential when signing in.
- **Why it is needed (what does it secure against):**
Ensures sign ins are protected through multi-factor authentication. Protects against credential theft and password attacks.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
All sign-ins by principals in the Privileged device Devices and Privileged Users will require a MFA token

## MSM - Session Duration

- **Setting Name:** MSM - Session Duration
- **Description:**
Forces principals to re-authenticate utilizing their Entra ID credentials after their session has been established for 9 hours
- **Why it is needed (what does it secure against):**
Ensures users cannot leave sessions open over multiple days and reduces risk of someone utilizing an established session after hours.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
After a session has existed for 9 hours, principals will be required to re-authenticate

## MSM - Session Persistence

- **Setting Name:** MSM - Session Persistence
- **Description:**
When a browser session is closed, it will require principals to re-authenticate into all cloud apps utilizing their Entra ID credentials.
- **Why it is needed (what does it secure against):**
Ensures that on new browser sessions, new sessions will be established utilizing a principals Entra ID credentials
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
When a browser session is closed and relaunched, a re-authentication will occur.

## MSM - Disable CA Resilience Downgrade

- **Setting Name:** MSM - Disable CA Resilience Downgrade
- **Description:**
If their is an outage in Entra ID and Conditional Access policies cannot be evaluated, it will block principals from authenticating.
- **Why it is needed (what does it secure against):**
Ensures that no principals can bypass any Conditional Access policies when their is an outage.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users
- **When the policy triggers:**
If their is an outage in Entra ID, once a principals session expires they will not be able to continue in their session until Entra ID Conditional Access is able to be evaluated again.

## Continuous Access Evaluation

- **Setting Name:** Continuous Access Evaluation
- **Description:**
Anytime Entra ID detects a change in signal on the session, such as location, IP address, permissions, it will reprocess the conditional access policies on the account
- **Why it is needed (what does it secure against):**
This protects against credential theft attacks, session stealing, and users inadvertently trying to authenticate from prohibited locations. If a user is authenticated in a permitted location and then moves to a prohibited location it will then end the session.
- **Who this applies to:**
Entra ID Groups: Privileged device Devices & Privileged Users or all users if already set.
- **When the policy triggers:**
Anytime there is a change in signal on the token
