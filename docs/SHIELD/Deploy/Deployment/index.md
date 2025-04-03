# Deployment

The Deploy module is provisioned automatically as part of the SHIELD platform’s Core Infrastructure deployment. This page provides clarity on how the Deploy module fits into the broader deployment flow and what is delivered specifically by this module.

---

## When Is Deploy Activated?

Deploy is automatically initialized when you use the **Deploy Core Infrastructure** feature within the SHIELD web app. This step sets up all underlying identity, device, and Conditional Access scaffolding that the Defend and Discover modules rely on.

There is no separate installation or deployment process specific to the Deploy module. However, understanding what Deploy provisions is key to understanding how the rest of SHIELD works.

---

## What Is Deployed?

The Deploy module provisions all foundational objects required for SHIELD’s lifecycle and security logic:

- Security groups for each SPA tier (Enterprise, Specialized, Privileged)
- Intune Scope Tags for device policy enforcement
- Entra ID Administrative Units for object-level access scoping
- Conditional Access policies (by class and group)
- Autopilot profile placeholders
- Role-linked management groups and access control structure

All of these are deployed and linked to your tenant using least-privilege automation logic.

---

## Where to Deploy

You can launch the SHIELD UI and deploy the infrastructure from:

📍 `{your-subdomain}.azurewebsites.net`

From the home screen:

1. Click **Deploy Core Infrastructure**
2. Review the Terms and Conditions
3. Check the agreement box
4. Click **Deploy Infrastructure**

You’ll then see:

- A progress spinner
- Automatic status updates
- A redirect to the home screen when finished

📖 See full UI walkthrough and screenshots in the [Usage Guide](../Usage-Guide.md#deploy-core-infrastructure-ui-flow)

---

## Need to Customize?

After deployment, you can:

- Change autopilot profiles and device configurations
- Modify Conditional Access settings
- Tag additional users or groups

However, **the following objects are immutable after deployment:**

- Security groups
- Intune scope tags
- Entra ID Administrative Units

These cannot be renamed or deleted through the SHIELD UI.

---

## Related Pages

- [Deploy Overview](index.md)
- [Deploy Usage Guide](../Usage-Guide.md)
- [Reference Docs](../Reference/index.md)
- [Troubleshooting](../Troubleshooting.md)
- [Full SHIELD Deployment](../../Getting-Started.md)

