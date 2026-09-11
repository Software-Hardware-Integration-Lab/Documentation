# How to Uninstall SHIELD

This guide explains how to fully decommission SHIELD to stop accruing the associated costs. The process involves three steps and an optional step to uninstall SHIELD Desktop. Once you're finished, validate that all the applications and groups have been removed.

---

## Step 1: Delete the Azure Resource Group Used for SHIELD

The first decommissioning step is to remove the Azure Resource Group associated with SHIELD.

1. Sign in to your Azure portal.
      - **Enterprise**: [https://portal.azure.com/](https://portal.azure.com/){:target="_blank"}
      - **Government**: [https://portal.azure.us/](https://portal.azure.us/){:target="_blank"}
2. Navigate to Subscriptions and select the subscription dedicated to SHIELD.
3. Click **Resource groups** in the left navigation bar.
4. Click on the Azure Resource group created for SHIELD (e.g., **SHIELD**).
5. Click **Delete resource group** at the top of the table and proceed with the deletion process.

**This removes**:

- The **SHIELD Azure App Service** (web app)
- Associated storage, compute, and networking resources

---

## Step 2: Cancel the Azure Subscription

Once the resource group is removed, the next step is to remove the Azure subscription used for SHIELD. If SHIELD was deployed in its own dedicated Azure subscription, you can go ahead and remove it. If it is running in a shared subscription, this step can be skipped.

1. Sign in to your Azure portal.
      - **Enterprise**: [https://portal.azure.com/](https://portal.azure.com/){:target="_blank"}
      - **Government**: [https://portal.azure.us/](https://portal.azure.us/){:target="_blank"}
2. Navigate to **Subscriptions** and select the subscription dedicated to SHIELD.
3. Click **Cancel subscription** at the top of the table and proceed with the cancelation process.

---

## Step 3: Delete SHIELD Identity Objects in Entra ID

After Azure resources are removed, you will need to remove a few identity objects. These objects are created as part of the SHIELD installation process and should be removed to fully decommission access.

1. Sign in to your Entra ID admin center.
      - **Enterprise**: [https://entra.microsoft.com/](https://entra.microsoft.com/){:target="_blank"}
      - **Government**: [https://entra.microsoft.us/](https://entra.microsoft.us/){:target="_blank"}
2. Navigate to **Enterprise apps** in the navigation bar.
3. Click on the name of the application you wish to delete. You can use the search bar if needed. You will need to delete the following applications:
      - **SHIELD - End User Login**
      - **SHIELD - Data Gateway**
      - **SHIELD - Desktop**
4. Click **Properties** in the left navigation bar.
5. Click the **Delete** button at the bottom and proceed with the deletion process.
6. Repeat steps 2-5 until you have deleted all the applications.

---

## Optional: Uninstall the SHIELD Desktop Application (If installed)

If you installed SHIELD using the SHIELD Desktop application, you can uninstall it after SHIELD Discover is complete. SHIELD Desktop is no longer required after reporting is finalized. This applies whether the app was installed on:

- A local machine
- An Azure VM

---

## Final Step: Validate Cleanup

As a final check, you may want to:

- Confirm the SHIELD resource group is fully removed
- Confirm the SHIELD web app no longer exists in Azure App Services
- Confirm the Azure Subscription dedicated for SHIELD has been canceled
- Confirm there are no SHIELD‑related applications in Entra ID
- Confirm the SHIELD Desktop application has been uninstalled
