# Infrastructure Diagram

The below is the logical infrastructure interaction of the core Discover engine.
Each plugin interacts with the specific service configuration that is being interpreted.

## Threat Model

For an annotated threat model of the application's infrastructure architecture, please see the attached Microsoft [Threat Model Tool](https://aka.ms/tmt) representation of the infrastructure architecture.

[Annotated Infrastructure Threat Model](../assets/threat-models/infrastructure.tm7)

## Diagram

``` mermaid
%% Flowchart components
flowchart
    subgraph "Client Environment"
    Client["PowerShell Client"]
    end

    subgraph "Microsoft Trust Boundary (Cloud Boundary)"
    EntraId[/"Entra ID"\]
    SqlDb[("Azure SQL Database")]
    end

%% Authentication
Client --> | Step 1 - Request Auth Code | EntraId
EntraId --> | Step 2 - Receive Auth Code | Client

%% Write Data
Client --> | Step 3 - Data + Auth Token | SqlDb

%% Auth Validation
SqlDb --> | Step 4 - Validate Auth Token | EntraId
EntraId --> | Step 5 - Auth Token Confirmation | SqlDb

%% Data Write Confirmation
SqlDb --> | Step 6 - Confirm DB Operation | Client
```
