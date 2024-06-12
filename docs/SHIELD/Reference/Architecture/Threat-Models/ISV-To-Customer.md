# SHI to Customer

## Overview

SHIELD is a specialized orchestration platform that can provide a holistic, scalable, automated, and customizable architecture for managing PAWs in Microsoft environments. It uses Intune and other Microsoft services as the underlying tools to deploy, configure, update, and maintain PAWs, but it is not a replacement for Intune or a device management solution. Instead, it is a layer of abstraction and automation that simplifies and optimizes the PAW management process.

One of the questions that potential customers may have about SHIELD is how it ensures the privileged permissions it needs to run are not abused by SHI or by threat actors who may try to compromise SHI or its customers. The following will address this question and explain the various measures and safeguards that SHIELD implements to prevent abuse of its permissions:

- No inbound commands possible
- Outbound commands disabled by default
- No undocumented API or commands
- Losing licenses does not affect operation
- Source code available for verification
- Customer controls authentication to the platform
- Telemetry data is not a security ris

Below are some of the steps we use to prevent supply chain attacks from affecting you.

## No Unauthorized Inbound Commands Possible

One of the key features of SHIELD is that it does not allow any inbound commands from SHI or anyone else to the customer's environment. This means that no one can send commands to the customer's devices or systems without authenticating to the customer's tenant first, which the customer completely controls. SHI does not have access to the customer's tenant or credentials and cannot bypass the customer's authentication mechanisms. There is no backdoor or hidden API that would allow SHI or anyone else to remotely control or manipulate the customer's PAWs.

The only way SHIELD interacts with the customer's environment is through outbound commands that the customer initiates and approves. These commands are either part of the initial deployment process, or part of the update and maintenance process, which the customer can choose to enable or disable. SHIELD does not report into a central database where SHI or anyone else can send commands to the customer's devices or systems.

## Outbound Commands Disabled by Default

Another feature of SHIELD is that it does not automatically update itself or the customer's PAWs by default. The customer must opt-in to enable automatic updates, which can be done through a simple checkbox in the user interface. If the customer does not enable automatic updates, SHIELD will only notify the customer of the availability of updates, and the customer will have to manually approve and apply them.

This gives the customer full control and visibility over the update and maintenance process. The customer can review the contents and details of each update before applying it and verify that it matches the expectations and requirements. SHIELD provides complete transparency and documentation for each update and does not include any undocumented or malicious changes. The customer can also choose to skip or postpone an update if they wish, without affecting the functionality or security of their PAWs.

## No Undocumented APIs or Commands

A further feature of SHIELD is that it does not have any undocumented API or commands that could be used to abuse its permissions. Everything that SHIELD can do is exposed and documented in the open API specification, which the customer can access and inspect. There are no hidden or secret commands that could be used to alter the behavior or functionality of SHIELD or the customer's PAWs.

The commands that the user interface uses are the exact same commands that the customer can use themselves if they want to automate or integrate SHIELD with other systems or tools. The customer can also access and modify the source code of SHIELD, which is available for verification and customization, to suit their specific needs and preferences. SHIELD does not rely on a black box or proprietary code that could conceal malicious or harmful actions.

## Losing Licenses Does Not Affect Operation

Another feature of SHIELD is that it does not depend on licenses to operate or maintain the customer's PAWs. Losing licenses, either accidentally or intentionally, does not cause SHIELD or the customer's PAWs to stop working or become vulnerable. The only effect of losing licenses is a banner notification in the user interface that informs the customer of the license status and prompts them to renew or purchase new licenses, and that updates are unable to be installed from the update engine.

This means that SHIELD is resilient to license attack vectors, where a threat actor could try to disrupt or compromise the customer's PAWs by tampering with the license database or revoking the licenses.

## Source Code Available for Verification

One of the most prominent features of SHIELD is that it makes its source code available for the customer to verify. SHIELD does not use a black box or proprietary code that could hide or conceal malicious or harmful actions. The customer can access and inspect the source code of SHIELD and verify that it matches the claims and documentation that SHI provides.

This gives the customer full confidence and trust in SHIELD and eliminates the possibility of backdoors or hidden features that could abuse its permissions. The customer can also audit and review the source code of SHIELD and ensure that it complies with their policies and standards. SHIELD does not use encrypted code that could prevent the customer from examining it.

SHIELD uses obfuscated code at runtime to reduce the risk of IP theft or malicious injection. All product build steps are verifiable via hashing if required to prove no modifications were performed.

## Customer Controls Authentication to the Platform

The next feature of SHIELD that prevents abuse of its permissions is that the customer controls the authentication to the platform. SHIELD does not have its own authentication mechanism or credentials that could be stolen or compromised. Instead, it uses the customer's existing Entra ID and enterprise app to authenticate the users and devices that can access and use the platform. The customer can control and restrict who can log in to SHIELD, and what actions they can perform.

This means that SHI or anyone else cannot access or use SHIELD without the customer's authorization and consent. There is no way for SHI or anyone else to bypass or override the customer's authentication policies or mechanisms. The customer can also monitor and audit the usage and activity of SHIELD and detect and prevent any unauthorized or suspicious access or actions.

## Telemetry Data Is Not a Security/Privacy Risk

The last feature of SHIELD that prevents abuse of its permissions is that it does not collect or transmit any sensitive or confidential data from the customer's environment. The only data that SHIELD collects and sends to SHI is telemetry data, which is used for licensing purposes. The telemetry data aggregated and normalized and does not contain any personal or identifiable information about the customer, their users, their devices, their data, or their systems.

This means that SHIELD does not pose a security risk or a privacy breach risk for the customer or their data. The telemetry data that SHIELD collects and sends to SHI is not useful or valuable for any threat actor or malicious actor who may try to intercept or access it. Telemetry data is also encrypted and protected in transit and at rest and follows the highest standards and best practices for data security and privacy.

## Conclusion

SHIELD is a specialized orchestration platform that can provide a holistic, scalable, automated, and customizable architecture for managing privileged access workstations (PAWs) in Microsoft environments. It uses Intune and other Microsoft services as the underlying tools to deploy, configure, update, and maintain the various in-scope systems, but it is not a replacement for Intune or a device management solution. Instead, it is a layer of abstraction and automation that simplifies and optimizes the PAW management process.

One of the questions that potential customers may have about SHIELD is how it ensures the privileged permissions it needs to run are not abused by SHI or by threat actors who may try to compromise SHI or its customers. This white paper has addressed this question and explained the various measures and safeguards that SHIELD implements to prevent abuse of its permissions. These include:

- No inbound commands possible
- Outbound commands disabled by default
- No undocumented API or commands
- Losing licenses does not affect operation
- Source code available for verification
- Customer controls authentication to the platform
- Telemetry data is not a security/privacy risk

These features make SHIELD a secure and trustworthy solution for managing architecture at scale and give the customer full control and visibility over the PAW management process. SHIELD does not abuse its permissions and does not allow anyone else to abuse its permissions. SHIELD is designed to protect and enhance the security of the customer's PAWs, and prevent lateral traversal, supply chain attacks, pre-login attacks, insider threats, and more.

## See Also

- Telemetry data (Coming Soon!)
