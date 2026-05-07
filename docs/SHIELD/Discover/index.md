# Overview

The Discover module enables advanced licensing intelligence and compliance reporting for Microsoft 365 services. It retrieves configuration data from multiple service APIs, analyzes it, and stores compliance results in an Azure SQL database for visualization in tools like Power BI.

Discover is plugin-driven, lightweight, and runs entirely from the client environment via PowerShell.

---

## What Discover Does

- Retrieves Microsoft service configuration data using Graph API and Defender APIs
- Evaluates license assignments against usage and configuration
- Stores structured results in SHI - Data Gateway

Discover allows organizations to:

- Ensure license assignments match technical requirements
- Detect gaps in purchased vs. configured capabilities
- Automate configuration audits across tenants

---

## Architecture

The Discover module is built on a modular architecture that emphasizes extensibility, scalability, and automation. This section provides an overview of three key components:

- **Plugin**: Explains how Discover leverages a plugin-based engine to extract and evaluate configuration data from various Microsoft services.
- **Infrastructure**: Describes the underlying infrastructure, including the Data Gateway, that supports secure data collection and storage.
- **Execution**: Details the end-to-end workflow, from engine startup through plugin execution to data upload, illustrating how Discover processes and normalizes data for compliance reporting.

---

### Plugin

Discover's core engine is extensible through plugins. Each plugin is responsible for extracting and evaluating configuration from a specific service, for example:

- 🔌 **Entra ID Plugin** – Retrieves directory and user-level settings
- 🔌 **Defender for Endpoint Plugin** – Retrieves licensing status
- 🔌 **Defender for Identity Plugin** – Retrieves licensing status

Plugins are executed sequentially, and their results are normalized before being uploaded to the Data Gateway.

📖 See full list in [Reference → Plugin Overview](Reference/index.md#plugin-overview)

---

### Infrastructure

Please see [Data Gateway Infrastructure](../../Data-Gateway/Architecture/Infrastructure.md) docs for more details.

---

### Integration and Execution

This diagram outlines the flow of interactions between the Shield UI, Microsoft Entra (identity provider), Microsoft Graph API  and the Data Gateway.

!!! requests for specific audience tokens are not shown on this diagram.
    In reality, before accessing any Azure services we need to generate a token scoped to a specific audience. This is done by making a request to EntraID and passing our original login token. Entra will then check that the user principle is authorised for access to that particular audience, and if so will generate a scoped token for that access. in the interest of brevity these processes are not shown on this diagram. 


![This diagram outlines the flow of interactions between the Shield UI, Microsoft Entra (identity provider), Microsoft Graph API  and the Data Gateway. It shows how a user action in a local browser initiates authentication and authorization with Microsoft Entra within the customer tenant context, resulting in access tokens which are used to call the Graph API to perform operations. Key components: Shield UI (Local Browser), Microsoft Entra (identity provider handling auth flows),  Shield App Service (Customer Tenant), and Graph API (Microsoft Global) and the Data Gateway  (SHI tenant). Relationships: browser triggers Discover process. Authentication with Entra; Entra validates within the customer tenant and issues tokens; Backend uses tokens to call Graph API; Graph API returns data;  Data is updated to data Gateway.](./assets/images/DiscoverIntegration.png)



Please see the internal [process flow diagram](./Reference/Architecture/Process-Flow.md) for more details.

---

## Related Pages

- [Discover Deployment](Deployment/index.md)
- [Discover Usage Guide](Usage-Guide.md)
- [Discover Reference](Reference/index.md)
- [Troubleshooting Discover](Troubleshooting.md)
