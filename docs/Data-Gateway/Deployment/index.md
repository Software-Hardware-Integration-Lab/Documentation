# Deployment

The Data Gateway service does not require installation in your tenant.  
The service is hosted by SHI and is available directly via the UI and API.

## Permission Grants

The Data Gateway SaaS requires that permissions be granted before you can access the app.
To grant permissions to a principal in your tenant, please register the `SHI - Data Gateway` app so that SSO is enabled by navigating to the following URL:

- <https://login.microsoftonline.com/common/adminconsent?client_id=4c40281b-a305-4aaf-90a4-d5bbee6eb8ed&redirect_uri=https%3A%2F%2Fdashboard.shilab.com>

!!! note
    To register this app, you may require the [Cloud Application Administrator](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#cloud-application-administrator) role or higher in your tenant depending on the admin consent settings configured.

When the app is registered, you will see an Enterprise App that has the name of `SHI - Data Gateway` with the Client ID of `4c40281b-a305-4aaf-90a4-d5bbee6eb8ed`.
This enterprise app allows principals in your tenant to be able to generate Access Tokens (JWT) and make API calls to the Data Gateway service.
This enterprise app does not allow the Data Gateway service to connect into your tenant.

## Getting Started

- Sign in with your Entra ID account.  
- Navigate the [Usage Guide](../Usage-Guide/index.md) for common tasks.  
- See [Reference](../Reference/index.md) for API integration details.
