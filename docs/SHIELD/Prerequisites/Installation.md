# Overview and Installation Requirements

## Overview

SHIELD is a self-hosted application deployed in a customer’s Azure App Service tenant. SHIELD collects and processes all necessary data exclusively within the customer’s environment, then returns only abstracted and fully anonymized results back to SHI for reporting. All requirements can be set up by the delivery team or customer prior to engagement. This guide explains how to install the SHIELD - Desktop application and run your first scan. For more information about requirements, pricing, and more, see [Prerequisites](/SHIELD/Prerequisites).

!!! info "Security Considerations"
    While this application requires sensitive permissions to conduct the automated scan, by self-hosting the application, SHI does not represent a supply chain risk or path to compromise a customer environment via the SHIELD platform, as there is no control maintained beyond the initial point of installation. All code being run to conduct the automated discovery is available for code and security reviews prior to engagement upon request. Permissions exist for both the user initiating the report and the application itself. Code review is available upon request.
---

## Networking Requirements

For a smooth installation, network traffic inspection must be disabled on the device installing SHIELD. If inspection is enabled, Microsoft will drop the traffic, and SHIELD will not function properly. This includes tools like Palo, Zscaler, or nginx (caching). Traffic inspection must be excluded from network inspection according to Microsoft's terms and conditions. For more information, see [Microsoft Documentation](http://aka.ms/pnc){:target="_blank"}.

If you require assistance, please reach out to your networking team, security team, or the person in charge of information technology at your organization. For more information about traffic inspection, see [Network Traffic Inspection](./Network-Traffic-Inspection).

- Add the following network endpoints to the inspection exclusion list:
    - `https://api.shilab.com`
    - `https://url.shilab.com`
    - `https://*.azurewebsites.net` - *Your specific deployment URL (generated after deployment)*

---

## Installation Instructions

!!! info "SHIELD Installation Has Changed"
    The **SHIELD - Desktop** application is now the preferred method, for faster and easier installation.<br><br>
    **Why?** The desktop application automates most steps, making setup much simpler.<br><br>
    **Manual Installation**: If you prefer the manual method, please reach out to an SHI employee for guidance and support


### SHIELD - Desktop's Installer Module

1. Create a new Azure subscription dedicated to SHIELD (recommended for isolation).
2. You must have:
    - **Global Administrator** or **Privileged Role Administrator** (to grant Microsoft Graph application permissions via admin consent). For more information about permissions, see [Application Permissions](./Application-Permissions).
    - `Owner` on the Azure subscription (to deploy resources)
3. If you haven't already done so, turn off network traffic inspection on the device installing SHIELD, so there are no interruptions during installation. If you require assistance with this step, please see [Networking Requirements](#networking-requirements) above.
4.  Run the installer to set up SHIELD automatically using the following link: [https://url.shilab.com/shield-install](https://url.shilab.com/shield-install)
    - **Note**: The download will not work if network traffic inspection is enabled, especially in Microsoft/Azure environments.

### Install and Deploy SHIELD Discover


1. After installation, launch the SHIELD - Desktop application. 
2. Log in using the account manager in the top right corner. Be sure to log in with the account that has the necessary `Owner` and `Global Admin` permissions in Azure. These are required to grant the necessary permissions for deployment.
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


### Running the SHIELD Web Instance


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