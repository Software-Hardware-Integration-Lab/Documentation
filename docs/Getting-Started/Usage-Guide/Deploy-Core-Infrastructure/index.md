# Deploy Core Infrastructure

You have to meet the prerequisites before being able to deploy the core infrastructure.
The core infrastructure is where the main configurations reside for the MSM product.
Once this is deployed, the configurations can be customized and the lifecycle management system can be used.

After deployment, the only parts of the core infrastructure that can't be touched are the `security groups`, `Intune scope tags` and `AAD Administrative Units`. All other items can be modified, including the device configurations, autopilot profiles and conditional access.

---

## Prerequisites

To deploy the core infrastructure, you have to make sure that the pre-requisites are met:

- [X] E5/A5/G5/F3 + F5 Security & Compliance [or equivalent](https://go.microsoft.com/fwlink/?linkid=2139145){:target="_blank"} licenses are purchased and enabled in the target tenant.
- [X] Defender for Endpoint has had its [workspace created](../MDE-Enable).
- [X] Security Defaults [are shut off](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/concept-fundamentals-security-defaults#disabling-security-defaults) in AAD.
- [X] Certificate Authentication is [disabled in the AAD authentication methods](https://learn.microsoft.com/en-us/azure/active-directory/authentication/how-to-certificate-based-authentication#step-2-enable-cba-on-the-tenant).

---

## Deployment

After the pre-requisites are met, you can deploy the core infrastructure.
Deploying the core-infrastructure is pretty easy:

1\. Open the Moot Security Management app to the URL that you deployed to. It will open itself to the `Infrastructure Deployment` page.

!!! note "Portal Location"
    By default, this is a subdomain at `{your-company}.azurewebsites.net`

2\. Read the `Terms and Conditions` document and if you agree, select the `I agree to the terms and conditions` check box. This will enable and arm the `Deploy Infrastructure` button.

![Screenshot of the Infrastructure Deployment page showing the "I agree" button as checked and the deploy button as enabled. The check box is highlighted by a red box indicating what should be selected.](/assets/Images/Screenshots/Core-Infrastructure-Deployment.png){ loading=lazy }

3\. Push the `Deploy Infrastructure` button. This will deploy all the supporting components to the lifecycle management system.

![Screenshot of the core infrastructure deployment spinner indicating a deployment is in progress. The spinner has been highlighted by a red box indicating where the deployment in progress spinner will appear.](/assets/Images/Screenshots/Spinner.png){ loading=lazy }

4.\ Once the deployment has completed it will redirect you to the home screen as seen in the below screenshot.

![Screenshot of the home page with the navigation cards visible.](/assets/Images/Screenshots/Home-Screen.png){ loading=lazy }
