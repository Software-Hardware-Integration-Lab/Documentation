## System Requirements

### Hosting Environment

- **Platform**: Azure App Service  
- **Runtime**: Node.js 22 LTS (or latest stable version)  
- **Deployment Mode**: Code deploy mode  
- **Identity Configuration**:  
    - **System-assigned Managed Identity**: Must be enabled  
    - This identity will be used to authenticate against Microsoft Graph API for identity-aware redirection and access control.

---

The application is broken up into two parts, the server and the end user experience. The server has permissions granted to it so that it can validate the incoming data. The end user experience has permissions so that the end user is able to provide IDs to the server for user and group assignments.
