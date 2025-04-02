# Overview

The Discover module enables advanced licensing intelligence and compliance reporting for Microsoft 365 services. It retrieves configuration data from multiple service APIs, analyzes it, and stores compliance results in an Azure SQL database for visualization in tools like Power BI.

Discover is plugin-driven, lightweight, and runs entirely from the client environment via PowerShell.

---

## What Discover Does

- Retrieves Microsoft service configuration data using Graph API and Defender APIs
- Evaluates license assignments against usage and configuration
- Stores structured results in an Azure SQL database
- Visualizes data using third-party tools such as Power BI

Discover allows organizations to:

- Ensure license assignments match technical requirements
- Detect gaps in purchased vs. configured capabilities
- Automate configuration audits across tenants

---

## Plugin Architecture

Discover’s core engine is extensible through plugins. Each plugin is responsible for extracting and evaluating configuration from a specific service:

- 🔌 **Entra ID Plugin** – Retrieves directory and user-level settings
- 🔌 **Defender for Endpoint Plugin** – Retrieves configuration and licensing status
- 🔌 **Defender for Identity Plugin** – Extracts rules and signals used in audit logic

Plugins are executed sequentially, and their results are normalized before being uploaded to the Azure SQL Database.

📖 See full list in [Reference → Plugin Overview](Reference/index.md#plugin-overview)

---

## Infrastructure Architecture

The infrastructure diagram below shows how the Discover engine interacts with Microsoft services and securely stores results in Azure SQL:

### Infrastructure Flow

```mermaid
flowchart
    subgraph "Client Environment"
    Client["PowerShell Client"]
    end

    subgraph "Microsoft Trust Boundary (Cloud Boundary)"
    EntraId["Entra ID"]
    SqlDb[("Azure SQL Database")]
    end

    Client --> | Step 1 - Request Auth Code | EntraId
    EntraId --> | Step 2 - Receive Auth Code | Client
    Client --> | Step 3 - Data + Auth Token | SqlDb
    SqlDb --> | Step 4 - Validate Auth Token | EntraId
    EntraId --> | Step 5 - Auth Token Confirmation | SqlDb
    SqlDb --> | Step 6 - Confirm DB Operation | Client
```

📄 Download annotated threat model: [Infrastructure Threat Model (.tm7)](assets/threat-models/infrastructure.tm7)

---

## Execution Process

The following diagram shows the plugin execution flow from engine startup through plugin enumeration, execution, and data upload.

### Execution Flowchart

```mermaid
flowchart TD

AzSqlDb[("Report Storage")]

Start["Start"]
Initialization["Configure Core Engine"]
LoginHost["Log into Az SQL Server's tenant"]
LoginCustomer["Log into tenant that\ndata is to be retrieved from"]
ReportCorelationRecord["Create a record to\ncorrelate all counts for a run"]
LoadPlugins["Enumerate/Validate and Run Plugins"]

subgraph plugin
StartPlugin["Start execution\non specified plugin"]
GetData["Query APIs to get configuration data"]
ProcessData["Organize and Deduplicate Data"]
ReportProcessedData["Upload Processed Data to Az SQL DB"]
EndPlugin["End execution\nof current plugin"]
end

LoopPlugin["Check if another\nplugin is present"]
LogOut["Log out of all sessions"]
SuccessEnd["Finish Reporting\nSuccessfully"]

Start --> Initialization
Initialization --> LoginHost
LoginHost --> LoginCustomer
LoginCustomer --> ReportCorelationRecord
ReportCorelationRecord -.-> AzSqlDb
ReportCorelationRecord --> LoadPlugins
LoadPlugins --> StartPlugin
StartPlugin --> GetData
GetData --> ProcessData
ProcessData --> ReportProcessedData
ReportProcessedData -.-> AzSqlDb
ReportProcessedData --> EndPlugin
EndPlugin --> LoopPlugin
LoopPlugin -->|If Yes| StartPlugin
LoopPlugin -->|If No| LogOut
LogOut --> SuccessEnd
```

---

## Related Pages

- [Discover Deployment](Deployment/index.md)
- [Discover Usage Guide](Usage-Guide.md)
- [Discover Reference](Reference/index.md)
- [Troubleshooting Discover](Troubleshooting.md)

# Overview

The Discover module enables advanced licensing intelligence and compliance reporting for Microsoft 365 services. It retrieves configuration data from multiple service APIs, analyzes it, and stores compliance results in an Azure SQL database for visualization in tools like Power BI.

Discover is plugin-driven, lightweight, and runs entirely from the client environment via PowerShell.

---

## What Discover Does

- Retrieves Microsoft service configuration data using Graph API and Defender APIs
- Evaluates license assignments against usage and configuration
- Stores structured results in an Azure SQL database
- Visualizes data using third-party tools such as Power BI

Discover allows organizations to:

- Ensure license assignments match technical requirements
- Detect gaps in purchased vs. configured capabilities
- Automate configuration audits across tenants

---

## Plugin Architecture

Discover’s core engine is extensible through plugins. Each plugin is responsible for extracting and evaluating configuration from a specific service:

- 🔌 **Entra ID Plugin** – Retrieves directory and user-level settings
- 🔌 **Defender for Endpoint Plugin** – Retrieves configuration and licensing status
- 🔌 **Defender for Identity Plugin** – Extracts rules and signals used in audit logic

Plugins are executed sequentially, and their results are normalized before being uploaded to the Azure SQL Database.

📖 See full list in [Reference → Plugin Overview](Reference/index.md#plugin-overview)

---

## Infrastructure Architecture

The infrastructure diagram below shows how the Discover engine interacts with Microsoft services and securely stores results in Azure SQL:

### Infrastructure Flow

```mermaid
flowchart
    subgraph "Client Environment"
    Client["PowerShell Client"]
    end

    subgraph "Microsoft Trust Boundary (Cloud Boundary)"
    EntraId["Entra ID"]
    SqlDb[("Azure SQL Database")]
    end

    Client --> | Step 1 - Request Auth Code | EntraId
    EntraId --> | Step 2 - Receive Auth Code | Client
    Client --> | Step 3 - Data + Auth Token | SqlDb
    SqlDb --> | Step 4 - Validate Auth Token | EntraId
    EntraId --> | Step 5 - Auth Token Confirmation | SqlDb
    SqlDb --> | Step 6 - Confirm DB Operation | Client
```

📄 Download annotated threat model: [Infrastructure Threat Model (.tm7)](assets/threat-models/infrastructure.tm7)

---

## Execution Process

The following diagram shows the plugin execution flow from engine startup through plugin enumeration, execution, and data upload.

### Execution Flowchart

```mermaid
flowchart TD

AzSqlDb[("Report Storage")]

Start["Start"]
Initialization["Configure Core Engine"]
LoginHost["Log into Az SQL Server's tenant"]
LoginCustomer["Log into tenant that\ndata is to be retrieved from"]
ReportCorelationRecord["Create a record to\ncorrelate all counts for a run"]
LoadPlugins["Enumerate/Validate and Run Plugins"]

subgraph plugin
StartPlugin["Start execution\non specified plugin"]
GetData["Query APIs to get configuration data"]
ProcessData["Organize and Deduplicate Data"]
ReportProcessedData["Upload Processed Data to Az SQL DB"]
EndPlugin["End execution\nof current plugin"]
end

LoopPlugin["Check if another\nplugin is present"]
LogOut["Log out of all sessions"]
SuccessEnd["Finish Reporting\nSuccessfully"]

Start --> Initialization
Initialization --> LoginHost
LoginHost --> LoginCustomer
LoginCustomer --> ReportCorelationRecord
ReportCorelationRecord -.-> AzSqlDb
ReportCorelationRecord --> LoadPlugins
LoadPlugins --> StartPlugin
StartPlugin --> GetData
GetData --> ProcessData
ProcessData --> ReportProcessedData
ReportProcessedData -.-> AzSqlDb
ReportProcessedData --> EndPlugin
EndPlugin --> LoopPlugin
LoopPlugin -->|If Yes| StartPlugin
LoopPlugin -->|If No| LogOut
LogOut --> SuccessEnd
```

---

## Related Pages

- [Discover Deployment](Deployment/index.md)
- [Discover Usage Guide](Usage-Guide.md)
- [Discover Reference](Reference/index.md)
- [Troubleshooting Discover](Troubleshooting.md)

