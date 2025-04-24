# Infrastructure Diagram

The below is the logical infrastructure interaction of the core Discover engine.
Each plugin interacts with the specific service configuration that is being interpreted.

## Diagram

```mermaid
flowchart BT
subgraph shiLab["SHI Lab - Trust Boundary"]
    AppService{{"Data Gateway"}}
    SqlDb[("General Data<br>(SQL DB)")]
    BulkData(["Bulk Data<br>(Storage Blob)"])
    UpdateData(["Update Data<br>(Storage Blob + Table)"])
end
subgraph microsoftGlobal["Microsoft Global"]
    entraId{"Entra ID"}
    shiLab
end
subgraph clientEnvironment["Client Environment"]
    client[/"REST API Client"\]
end

AppService --> entraId
AppService -- CRUD Operation + Token --> SqlDb
AppService -- CRUD Operation + Token --> BulkData & UpdateData
BulkData <-- Validate Auth of CRUD Operation --> entraId
SqlDb <-- Validate Auth of CRUD Operation --> entraId
entraId -- Public Keys --> AppService
entraId <-- Log into Entra ID --> client
AppService -- "CRUD Operation + Token. Response included." --> client
UpdateData <-- Validate Auth of CRUD Operation --> entraId
```

## Threat Model

For an annotated threat model of the application's infrastructure architecture, please see the attached Microsoft [Threat Model Tool](https://aka.ms/tmt) representation of the infrastructure architecture.

📄 [Data Gateway - Threat Model](../assets/threat-models/Data-Gateway.tm7)
