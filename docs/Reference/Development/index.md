# Overview

This application has its API documented in the `Open API` version 3 format.
This allows for ease of adoption into existing automation systems or workflows.

To access the `Open API` specification, if your app is in [Debug Mode](/Reference/Settings/Environmental-Variables-Reference/#MSM_Debug), you can access the spec at `{yourDomain}.azurewebsites.net/Docs`.
We recommend reach out to Moot, Inc. to get a copy of the JSON file, we have best practices when integrating and other support we can offer in addition to supplying the spec.

[:material-email: Contact Us](https://mootinc.com/contact/){ .md-button  }

!!! danger "Security Best Practice"
    It is a best practice to avoid bring MSM into debug mode. Security features like the login screen and rate limiter get shut off when in this mode. Please reach out to us before considering this option.
    If you bring your app into debug mode without us advising you to do so, you take responsibility for these changes.

## Custom HTTP Status Codes

The API server has special codes to tell you when something happens, like when an app starts or if the infrastructure isn't set up correctly.

You can find a table of these codes here, but they might not be the most recent ones. That's because the [OpenAPI Specification](../) always has the most up-to-date info, and the user interface uses that spec to generate part of its source code.
So, this page might not have the newest codes, but the OpenAPI Specification will always have the most current ones for all endpoints served by the server.

---

## Response Code Reference

| HTTP Response Code | Description |
| :------------------| :-----------|
| 520 | App is starting still. Feature is not available. Please try again later. |
| 525 | Not deployed. Please deploy the infra before using this feature. |

---

## See Also

- [Open API Specification](../)
