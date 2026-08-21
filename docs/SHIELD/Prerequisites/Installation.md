# Overview and Installation Requirements

## Overview

SHIELD is a self-hosted application deployed in a customer’s Azure App Service tenant. SHIELD collects and processes all necessary data exclusively within the customer’s environment, then returns only abstracted and fully anonymized results back to SHI for reporting. All requirements can be set up by the delivery team or customer prior to engagement. This guide explains how to install the SHIELD - Desktop application and run your first scan. For more information about requirements, pricing, and more, see [Prerequisites](/SHIELD/Prerequisites).

!!! info "Security Considerations"
    While this application requires sensitive permissions to conduct the automated scan, by self-hosting the application, SHI does not represent a supply chain risk or path to compromise a customer environment via the SHIELD platform, as there is no control maintained beyond the initial point of installation. All code being run to conduct the automated discovery is available for code and security reviews prior to engagement upon request. Permissions exist for both the user initiating the report and the application itself. Code review is available upon request.

---

## Installation Prerequisites

### Disable Network Traffic Inspection

Network traffic inspection must be turned off for SHIELD and Microsoft endpoints on the device installing SHIELD. Major cloud service providers do not allow network traffic inspection of their services and SHIELD relies on Microsoft Azure networking. If inspection is not disabled, SHIELD will not install or function properly.

Every organization uses different equipment and processes, so the steps to disable inspection will vary.

**How to Proceed**:

- If you’re not sure how to disable network traffic inspection, please contact your networking team, security team, or the person in charge of information technology at your organization.
- You can also share the following network endpoints with your networking team to have the addresses excluded from inspection:
    - `https://api.shilab.com`
    - `https://url.shilab.com`
    - `https://*.azurewebsites.net` - *Your specific deployment URL (generated after deployment)*

**Common Network Traffic Inspection Technologies**

- **Firewalls** (Palo Alto, Fortinet, Cisco)
- **Secure Web Gateways (SWG) & Proxies** (Zscaler, ProxySG)
- **Cloud Access Security Brokers** (Netskope, Microsoft Defender for Cloud Apps)
- **Data Loss Prevention (DLP)** (Microsoft Purview DLP, Symantec DLP)
- **WAN Acceleration and Optimization** (Riverbed, Cisco WAAS, nginx caching)
- **VPN & Traffic Redirection** (VPN gateways, SASE platforms)

For more information about traffic inspection, see [Network Traffic Inspection](./Network-Traffic-Inspection).

---

### Create a Dedicated Azure Subscription

1. Sign in to your Azure portal.
    - **Enterprise**: [https://portal.azure.com/](https://portal.azure.com/){:target="_blank"}
    - **Government**: [https://portal.azure.us/](https://portal.azure.us/){:target="_blank"}
2. Navigate to **Subscriptions** and click **+ Add**.
3. If applicable, choose an offer type from the options provided. **Enterprise Agreement (EA) customers** typically do not have to select an offer type.
4. Enter a name for the subscription (e.g., "SHIELD – Production") or similar.
5. **Enterprise Agreement (EA) customers**: Assign a billing account and confirm creation.

---

### Global Administrator

The user installing SHIELD must be a **Global Administrator** in order to grant Microsoft Graph application permissions via admin consent. For more information about permissions, see [Application Permissions](./Application-Permissions).

1. Sign in to your Entra ID admin center.
    - **Enterprise**: [https://entra.microsoft.com/](https://entra.microsoft.com/){:target="_blank"}
    - **Government**: [https://entra.microsoft.us/](https://entra.microsoft.us/){:target="_blank"}
2. Navigate to **Roles & admins**.
3. Search for and click on the **Global Administrator** role.
4. If the user deploying SHIELD is already assigned the **Global Administrator** role, no additional action is required. If a user needs to be assigned the **Global Administrator** role, follow the steps below:
    1. At the top, click **+ Add Assignments**.
    2. Click the link under **Select member(s)**.
    3. Check the box next to the desired user and click **Select**. You can also use the search bar if needed.
    4. Select your desired settings. We recommend the following:
        - Assignment type: **Active**
        - Permanently eligible: Uncheck
        - Assignment duration: 24-48 hours
    5. Click **Assign**.

---

### Azure Subscription Owner

Make sure the user installing SHIELD is the **Owner** on the Azure subscription in order to deploy resources.

1. Sign in to your Azure portal.
    - **Enterprise**: [https://portal.azure.com/](https://portal.azure.com/){:target="_blank"}
    - **Government**: [https://portal.azure.us/](https://portal.azure.us/){:target="_blank"}
2. Navigate to **Subscriptions** and select the subscription to be used with SHIELD.
3. Click **Access control (IAM)** in the left navigation bar.
4. Click on the **Role assignments** tab.
5. If the user deploying SHIELD is already assigned the **Owner** role of the subscription, no additional action is required. If a user needs to be assigned the **Owner** role, follow the steps below:
    1. At the top, click **+ Add** and click **Add role assignment** in the drop-down menu.
    2. Click on the **Privileged administrator** roles tab.
    3. Click on the **Owner** role so it is highlighted and click **Next**.
    4. Click **+ Select members**, click on the desired user account, and click **Select**.
    5. Click **Next**.
    6. Select **Allow user to assign all roles (highly privileged)**.
    7. Click **Next**.
    8. If applicable, select your desired Assignment type settings. We recommend the following:
        - Assignment type: **Active**
        - Assignment duration: **Permanent**
    9. Once finalized, click **Review + assign**.
    10. (Optional) Confirm the role appears in the **Role assignments** tab.

---

## Install and Deploy SHIELD Discover

!!! info "SHIELD Installation Has Changed"
    The **SHIELD - Desktop** application is now the preferred method, for faster and easier installation.<br><br>
    **Why?** The desktop application automates most steps, making setup much simpler.<br><br>
    **Manual Installation**: If you prefer the manual method, please reach out to an SHI employee for guidance and support.

0. Run the installer to set up SHIELD automatically using the following link: [https://url.shilab.com/shield-install](https://url.shilab.com/shield-install)
    - **Note**: The download will not work if network traffic inspection is enabled, especially in Microsoft/Azure environments.
1. After installation, launch the SHIELD - Desktop application.
2. Log in using the account manager in the top right corner. Be sure to log in with the account that has the necessary **Owner** and **Global Administrator** permissions in Azure. These are required to grant the necessary permissions for deployment.
3. After you are successfully logged in, click on the **Installer** module.
    - **Note**: An additional tab may open, and another log in may be required.
4. Select the **Azure Subscription** that is dedicated for SHIELD.
5. Select your desired **Azure Region** from the drop-down menu. **West US 3** is recommended, but other regions can be selected depending on company policy.
6. Click on the toggle switch to display **Advanced Options**.
7. For **Operation Mode**, select **Discover** from the drop-down menu.
8. Click on the **Deploy** button for the SHIELD installer to begin the installation process.
    - **Note**: An additional tab may open, and another log in may be required.
9. The installer will do the following:
    - Download the SHIELD Deploy ZIP file
    - Create a SHIELD App Service and managed identity in Azure
    - Upload and configure the SHIELD application, including permissions and security settings such as disabling basic auth, enabling encryption, and setting quantum-resistant cryptography.
10. After deployment, verify the following required permissions are granted to the SHIELD managed identity in Azure:
    - `Application.ReadWrite.All`
    - `AppRoleAssignment.ReadWrite.All`
11. Lastly, assign the Read and Write Everything role to the user who will run SHIELD scans via the "SHIELD End User Login" enterprise app in Entra.
    1. Sign in to your Entra ID admin center.
        - **Enterprise**: [https://entra.microsoft.com/](https://entra.microsoft.com/){:target="_blank"}
        - **Government**: [https://entra.microsoft.us/](https://entra.microsoft.us/){:target="_blank"}
    2. Navigate to **Enterprise apps** in the navigation bar.
    3. Clear out the **Enterprise Applications** filter.
    4. Search for 'SHIELD End User Login' and click on the name of the application.
    5. Click **Users and groups** in the left navigation bar.
    6. Click **+ Add user/group**.
    7. Click the link under **Users and groups**.
    8. Check the box next to the desired user and click **Select**. You can also use the search bar if needed.
    9. Click on the link under **Select a role**.
    10. Search for 'Read and Write Everything', click on the name of the role, and click **Select**.
    11. Click **Assign**.

## Running the SHIELD Web Instance

1. Navigate to your SHIELD web instance in your browser: [https://portal.azure.com/](https://portal.azure.com/){:target="_blank"}
2. Click **Resource groups**.
3. Click **SHIELD**.
4. Click on the App Service that starts with "shield-xxxxxxxxx" (the x's are a random set of lower-case letters and numbers).
5. In the top right corner, click on the **Default domain** link. **Example**: shield-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxx.eastus-01.azurewebsites.net
6. Log in to the SHIELD web instance with the account that has the necessary Azure permissions.
7. Click on **Discover Module**.
8. Click **Start Authentication Sync**. Then click **Start Report Collection** to start scanning the tenant environment.
9. During the first scan, SHIELD - Desktop will open and request account credentials multiple times. Log in each time as required. You will also need to accept each set of permissions.
10. Once the scan is complete, reports are available on the SHIELD web instance.
    1. Click **Discover** in the left navigation pane and click **Overview**.
