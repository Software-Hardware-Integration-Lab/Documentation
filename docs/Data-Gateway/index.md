# SHI - Data Gateway

Data Gateway is SHI’s secure data layer that unifies access to product and tenant information across SHI solutions.  
It provides a single, trusted path for ingesting, storing, and retrieving the data that powers SHIELD and related services.

!!! tip "Who should read this?"
    Admins, operators, and analysts who will use the Data Gateway UI or connect via the public API.

---

## What you can do

Data Gateway helps you:

- **Use the web UI** to explore tenant data and SHI experiences such as **Tenant Manager** and **LicenseGPT**.
- **Integrate via API** with SHI’s services using the public OpenAPI/Swagger specification.
- **Authenticate securely** with your organization’s Entra ID account to protect data access.
- **Ingest and retrieve reports** including license reports, entitlement data, and telemetry.
- **Manage updates** such as update packages and configuration channels stored in Azure Blob Storage.
- **Access processed relational data** in Azure SQL for compliance and reporting scenarios.

---

## Explore Data Gateway

<div class="grid cards" markdown>
- 🧭 **Getting Started**  
  Learn how to sign in, navigate the UI, and complete common tasks.  
  [:octicons-arrow-right-24: Usage Guide](./Usage-Guide/index.md)

- 🏗️ **Architecture**  
  Understand the service layout, trust boundaries, and how Data Gateway connects to SHI Cloud.  
  [:octicons-arrow-right-24: Architecture Overview](./Architecture/index.md)

- 🌐 **API Reference**  
  Browse the live API reference and try requests in your browser.  
  [:octicons-link-24: specs.shilab.com](https://specs.shilab.com)

</div>

---

## Architecture Overview

```mermaid
flowchart LR

  %% ==========================================================
  %% Data Gateway - High-level Architecture (Accessible + Modern)
  %% Shapes communicate category:
  %%   External: ([ ... ])         Components: [ ... ]
  %%   Data store: [[ ... ]]       AI assistant: (( ... ))
  %% ==========================================================

  %% ---- Accessible, high-contrast style classes ----
  classDef boundary fill:#F9FAFB,stroke:#5B6472,stroke-width:1.25px,rx:10,ry:10,color:#1F2937;
  classDef external fill:#FFF4E6,stroke:#B45309,stroke-width:1.25px,rx:12,ry:12,color:#1F2937;
  classDef component fill:#E8F1FF,stroke:#1D4ED8,stroke-width:1.25px,rx:8,ry:8,color:#0B1736;
  classDef datastore fill:#ECFDF5,stroke:#047857,stroke-width:1.25px,rx:8,ry:8,color:#0B1736;
  classDef ai fill:#F5F3FF,stroke:#6D28D9,stroke-width:1.25px,rx:8,ry:8,color:#0B1736;

  %% ---- External actors ----
  U([Users]):::external
  IDP([Entra ID Sign in and Tokens]):::external

  %% ---- SHI Cloud trust boundary ----
  subgraph CLOUD [SHI Cloud]
    direction LR

    %% Core app components (rectangles)
    UI[Data Gateway UI]:::component
    API[Data Gateway API]:::component

    %% Data layer (double borders)
    BLK[[Azure Blob Storage Bulk Data]]:::datastore
    UPD[[Azure Blob Storage Update Packages]]:::datastore
    SQL[[Azure SQL Database Processed Data]]:::datastore

    %% AI assistant (circle)
    LLM((LicenseGPT Azure OpenAI)):::ai
  end

  class CLOUD boundary

  %% ---- Flows  ----
  U -->|HTTPS| UI
  UI -->|OAuth2 Sign in| IDP
  IDP -->|Tokens| UI
  UI -->|HTTPS JWT| API

  API -->|Read Write| BLK
  API -->|Read Write| UPD
  API -->|ORM| SQL
  API -->|LLM Calls| LLM
  
  linkStyle 1 stroke-dasharray:6 4,stroke:#5B6472,stroke-width:1.25px
  linkStyle 2 stroke-dasharray:6 4,stroke:#5B6472,stroke-width:1.25px
```
