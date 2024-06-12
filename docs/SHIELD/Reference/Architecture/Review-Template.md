# Architecture Security Review Template

## Overview

Engagement details to help identify the customer (CX) and the product being reviewed.
Additionally contains info on how to read this document and or to write your own questions.

---

### Engagement Details

Requesting Party:

- Company Name:
- Representative List (Format: name, email, phone):
- Reason for review:

Product details:

- Company Name:
- Product Name:
- Sales Model ({++SaaS++}, PaaS, etc.):
- Misc. Notes:

---

### How to Read the Symbols

- Bullet point: Indicates a question.
    - Nested bullet points are dependant on their parents.
    - `🚫` Emoji: Depending on the parent's answer, may be skipped, which will be indicated by the emoji.
- `🕵️` Emoji: Indicates a trick question. Be careful with how you ask this question.
- Parentheses `()`: Used to indicate potential answers.
- Green Underline ({++Correct answer++}): Used to identify the best answer for the question.
- Red Strikethrough ({--Bad answer--}): Used to identify bad answers or big red flags.
- Block Quote (Admonition): Used to provide commentary on the question or answer.

!!! note "Block Quote Example"
    Like this!

- Heading 1 `#` Element: Indicates the page title.
    - Not to be used elsewhere
- Heading 2 `##` Element: Indicates a major section.
    - Will be preceded by a horizontal rule to visually separate it from other sections.
    - May (recommended) contain a description of the section to provide context.
    - Will have a horizontal rule placed after the H2
        - Or if a description is specified, after the description.
- Heading 3 `###` Element: Indicates a sub section.
    - Will be preceded by a horizontal rule to visually separate it from other sections.
    - May (recommended) contain a description of the section to provide context.

---

## User Experience

Questions relating to how the end user/customer's experience and interactions with the product are secured.
Topics covered by this section are related to the app's end user interface, back-end systems/interfaces will be covered later.

---

### Authentication

End user authentication and IdP integration.

- Is there a self built IdP managing end user access ({--Yes--}, {++No++}):
- Are passwords available as an option (Yes, No):
    - Are the password salted ({++Yes++}, No):
    - Is password-less an option ({++Yes++}, No):
- MFA Support (Yes, No):
    - Types of MFA supported ({++FIDO2++}, {++Cert Auth++}, TOTP, HOTP, SMS, Email, etc.):
- SSO Support (Yes, No):
    - SSO Types Supported ({++SAML++}, {++OAuth++}, {++OpenID Connect++}, WSFed, Kerberos, {--LDAP/LDAPS--}, etc.):
    - SSO feature behind a paywall (Yes, {++No++}):

---

### App Delivery

- Delivered as web app ({++Yes++}, No):
    - 🕵️ Does the web app support internet explorer (Yes, {++No++}):
    - Framework Used (Node.JS, DJango, Electron, {--Spring--}, {--Custom--}, etc.):
    - Is Cross Origin Request Sharing `CORS` fully implemented ({++Yes++}, {--No--}):
    - Is it Progressive Web App `PWA` compatible/integrated ({++Yes++}, No):
- Delivered as desktop app (Yes, {++No++}):
    - VDI type desktop app ({--Yes--}, {++No++}):
    - Supported Operating Systems (Windows, MacOS, Linux):
    - Framework used (.Net, NodeJS, Electron, {--Spring--}, {--Custom--}, etc.):
    - Auto updates supported ({++Yes++}, No):
        - Auto updates enabled by default ({++Yes++}, No):
- Delivered as mobile app (yes, no):
    - Supported Operating Systems (Android, iOS):
    - Framework Used (ReactNative, Cordova, Xamarin,{--Custom--},etc.):

---

## Infrastructure Architecture

---

### Network

- VPN required for End Users ({--Yes--}, {++No++}):
- VPN required for IT Admins ({--Yes--}, {++No++}):

### Hosting Infrastructure

- Any planned architecture changes ({++Yes++}, no):
    - List of changes:
    - Any provider changes (yes, no):
        - List of changes:
- Self Hosted Data Centers/Colos ({--Yes--},{++No++}):
    - **Limited/JEA** staff access to emergency/hardware maintenance ({++Yes++}, {--No--}):
    - Truck proof fences ({++Yes++}, no):
    - Truck proof building walls ({++Yes++}, no):
    - Truck proof gates/barricades ({++Yes++}, no):
    - Guards with guns ({++Yes++}, no):
    - No fly zones ({++Yes++}, no):
    - Man Traps ({++Yes++}, no):
    - Railroad Placement Taken into account ({++Yes++}, no):
    - Metal detectors ({++Yes++}, no):
    - On-site hard-drive destruction ({++Yes++}, no):
- Pure Cloud Hosting/Architecture ({++Yes++}, {--No--}):
    - Which cloud provider ({++Azure++}, {++AWs++}, {++GCP++}, {--3rd. Party--}):
    - Are any VMs used (yes, {++No++}):
        - Is a host based intrusion prevention implemented on all systems ({++Yes++}, {--No--}):
        - Are Privileged Class security concepts implemented ({++Yes++}, {--No--}):
    - Are any container solutions used (yes, {++No++}):
        - Is a host based intrusion prevention implemented on all containers ({++Yes++}, {--No--}):
        - Is container vulnerability scanning continuously used ({++Yes++}, No):
        - Is a container integrated AV used ({++Yes++}, No):
        - Is continuous patching implemented ({++Yes++}, No):
    - Are serverless resources used ({++Yes++}, no):
    - Are any third party SaaS products used (yes, no):
        - Which ones:
    - Any resources that can't be SSO integrated (yes, no):
- Self host option (yes, no):
    - Any limitations on self hosted version (yes, {++No++}):
        - List of limitations:
- Is the infrastructure compatible with confidential compute ({++Yes++}, No):
- Is a WAF implemented on all web facing system ({++Yes++}, {--No--}):
    - What type of WAF architecture is/are used (Cloud, {++Network++}, {++Host++}):

---

### Identity Provider

Identity providers are critical for centralizing and managing user access for engineering and corp.

- Are any systems integrated not integrated with a central IdP ({--Yes--}, {++No++}):
    - What is not integrated (DB User, local user account on computer):
- What IdP is used ({++Entra ID++}, {++Google Workspace++}, Okta, LastPass, CyberArk, etc.):
- Is credential partitioning implemented ({++Yes++}, {--No--}):
- Is zero persistent admin, also known as JIT implemented ({++Yes++}, {--No--}):
- Is least privilege followed for **ALL** permissions assignments ({++Yes++}, {--No--}):
- Is the clean source principal followed for administrative tasks ({++Yes++}, {--No--}):
- Is self service password reset enabled ({++Yes++}, {--No--}):
    - How many factors are required for reset (1, {++2+++}):
    - What are the reset factors ([Push notification], email, phone call, sms,{--Questions--}):
- Is continuous access reviews implemented for people with infra access ({++Yes++}, no):

---

## Software Development

Coding security is critical to building a stable and secure app.

- Are credentials in the source code ({--Yes--}, {++No++}):
- Is SCM/VCS used ({++Yes++}, no):
    - What format is used ({++Git++}, {--TFS--}, Mercurial, SVN):
    - Is peer review mandatory before code merged ({++Yes++}, {--No--}):
- Is Ci/CD implemented (Yes, No):
    - Is a human required to push to prod env (Yes, No):
- Are feature flag implemented (Yes, No):
- Is a ring deployment architecture used ({++Yes++}, No):
- Is a multi-environment architecture used for bubbling up new builds to prod (Yes, {++No++})
- Is automated testing used ({++Yes++}, {--No--}):
    - Unit Testing ({++Yes++}, No):
    - Integration Testing ({++Yes++}, no):
    - End-to-end testing ({++Yes++}, no):
- Is Static Code Analysis used ({++Yes++}, {--No--}):
- Is Dynamic Code Analysis used ({++Yes++}, No):
- Is Linting enforced ({++Yes++}, No):
- Is Dependency Management implemented ({++Yes++}, No):
    - Are versions auto updated ({++Yes++}, No):
    - Are dependencies hosted in a private package management solution ({++Yes++}, No):
    - Are dependencies reviewed before used/approved ({++Yes++}, No):
    - Did legal review the dependency for legal license compatibility before use/approval ({++Yes++}, No):
- Are developer workstation hardened more than normal user workstations ({++Yes++}, No):
- Is the source code pen tested (Yes, No):
    - What ways is it pen tested:
- Does application have telemetry integrations ({++Yes++}, No):
    - What type of telemetry is collected, and how is it used:
- Are standardized tools allows ({++Yes++}, No):
    - Have they been security reviewed ({++Yes++}, No):
- Is OWASP Top 10 training required for developers ({++Yes++}, No):
- Is the application and its components threat modeled ({++Yes++}, {--No--}):

---

## Security Operations

- Is a CASB used for all non-privileged users ({++Yes++}, No):
- Is CPSM software used ({++Yes++}, No):
- Is EDR software used ({++Yes++}, No):
- Is continual vulnerability analysis used on all systems ({++Yes++}, No):
- Is all telemetry collected centrally ({++Yes++}, No):
- Is all telemetry retained for at least 1 year ({++Yes++}, No):
- Is a SIEM used ({++Yes++}, {--No--}):
    - Is all of the WAF telemetry available in the SIEM ({++Yes++}, No):
    - Is SOAR functionality built into the SIEM ({++Yes++}, No):
    - Is all host based intrusion prevention system telemetry available in the SIEM ({++Yes++}, No):
    - Is all of the EDR telemetry available in the SIEM ({++Yes++}, No):
    - Is all of the CASB telemetry available in the SIEM ({++Yes++}, No):
    - Is the CPSM results available in the SIEM ({++Yes++}, No):
    - Is the vulnerability analysis data available in the SIEM ({++Yes++}, No):
    - Is the SAST data available in the SIEM ({++Yes++}, No):
    - Is the DAST data available in the SIEM ({++Yes++}, No):
- Is AI/ML used for signal intelligence ({++Yes++}, No):
    - What is it implemented for:
    - Can it perform automated remediation ({++Yes++}, No):
- Is all telemetry collected in a tamper resistant way (Yes, No):
    - Does application generate logs with user modifiable data located in them (Yes, {++No++}):
    - After logs are stored, can they be modified ({--Yes--}, {++No++}):
- Is there dedicated staff for security operations ({++Yes++}, No):
    - How may teams are there (1, {++2+++}):
    - What are their functions:
- Is penetration testing performed ({++Yes++}, No):
    - How frequent are pen tests ({--Yearly--}, Quarterly, {++Monthly++}, {++Continuous++}):
    - Are there pen testers in-house ({++Yes++}, No):
    - Are external pen testers used ({++Yes++}, {--No--}):
    - Are the pen testers allowed to ask the developers for help ({++Yes++}, No):
- Is an approved credential vault solution minimally available to the IT team list that require them ({++Yes++}, {--No--}):
    - Is an organization wide credential vault approved/offered to all employees ({++Yes++}, No):
    - Is the credential vault SSO integrated to the primary identity provider ({++Yes++}, No):
    - Name of credential vaulting provider ({--Home built, custom credential vault provider--}):

---

## Business Continuity and Disaster Recovery (BCDR)

- Is volumetric DDoS prevention deployed ({++Yes++}, No):
- Is application level DDoS/DoS prevention deployed ({++Yes++}, No):

---

### Backup/Failover

Properly architected backups are critical for ransomware resistance.

- Are backups stored in a PaaS or SaaS solution ({++Yes++}, {--No--}):
- Are backups automated ({++Yes++}, {--No--}):
- What is the RTO:
- What if the RPO:
- What is the uptime in 9s targeted/offered ({++Minimum of 3x9s++}):
- What is the data resiliency in 9s targeted/offered:

---

### Incident Management

- Is there a bug report playbook ({++Yes++}, No):
- Is there a security incident playbook set ({++Yes++}, No):
    - For DDoS ({++Yes++}, No):
    - For ransomware ({++Yes++}, No):
    - For data breach ({++Yes++}, No):
    - For vulnerability report ({++Yes++}, No):
    - For rogue employee ({++Yes++}, No):
    - Any others:
