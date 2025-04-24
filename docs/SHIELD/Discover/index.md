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

Discover’s core engine is extensible through plugins. Each plugin is responsible for extracting and evaluating configuration from a specific service, for example:

- 🔌 **Entra ID Plugin** – Retrieves directory and user-level settings
- 🔌 **Defender for Endpoint Plugin** – Retrieves licensing status
- 🔌 **Defender for Identity Plugin** – Retrieves licensing status

Plugins are executed sequentially, and their results are normalized before being uploaded to the Data Gateway.

📖 See full list in [Reference → Plugin Overview](Reference/index.md#plugin-overview)

---

### Infrastructure

Please see [Data Gateway Infrastructure](../../Data-Gateway/Architecture/Infrastructure.md) docs for more details.

---

### Execution

Please see the [process flow diagram](./Reference/Architecture/Process-Flow.md) for more details.

---

## Related Pages

- [Discover Deployment](Deployment/index.md)
- [Discover Usage Guide](Usage-Guide.md)
- [Discover Reference](Reference/index.md)
- [Troubleshooting Discover](Troubleshooting.md)
