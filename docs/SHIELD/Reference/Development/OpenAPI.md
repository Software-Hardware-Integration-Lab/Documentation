# OpenAPI Specification

This application has its API documented in the `Open API` version 3 format.
This allows for ease of adoption into existing automation systems or workflows.

The SHIELD software contains a copy of the OpenAPI spec that is currently in use. To access the built-in `Open API` specification, you can check the following:

- If your app is in [Debug Mode](../Settings/Environmental-Variables-Reference.md#sop_debug), you can access the spec at `{yourDomain}.azurewebsites.net/Docs`.

!!! note
    The server's built-in spec is only accessible if the app is in `Debug Mode`.

Please reach out to our team to get a copy of the JSON file, as well as best practices and other support for its use.

!!! danger "Security Best Practice"
    It is a best practice to avoid bringing SHIELD into debug mode. Security features like the login screen and rate limiter get shut off when in this mode. Please reach out to us before considering this option.
    If you bring your app into debug mode without us advising you to do so, you take responsibility for these changes.

[:material-email: Contact Us](https://shilab.com/contact/){ .md-button  }
