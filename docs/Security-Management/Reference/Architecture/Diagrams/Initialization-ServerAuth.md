---
hide:
    - toc
---
# Initialization - Orchestration Authentication

The authentication system is responsible for authenticating, and authorizing the MSM orchestration client to the various Microsoft APIs.

The Authentication engine is configured via [environmental variables](../../../Reference/Settings/Environmental-Variables-Reference.md) in combination with the use of managed identity.

---

## Legend

``` mermaid
flowchart TD

Start[/"Start"\]
Process["Process"]
Conditional(["Conditional Check"])
Stop{{"Stop Execution"}}

start1[ ] --> | Execution Flow, Carries Data | end1[ ]
style start1 height:0px;
style end1 height:0px;
start2[ ] -.-> | Decision, Carries data | end2[ ]
style start2 height:0px;
style end2 height:0px;
```

---

## Process

``` mermaid
flowchart TD

Start[/"Start"\]
ValidateAuthData["Validate the authentication data\nand set authentication mode in the state"]
ManagedIdentityIdCheck(["Check if MI ID was provided"])
CreateMiWithId["Create MI Credential\n(Using a User Assigned MI)"]
CreateMiWithoutId["Create MI Credential\n(Using a System Assigned MI)"]
CheckAuthType(["Check Auth Type in State"])
QueueKvSecretAuth["Queue Client Secret Auth\nusing a Secret in Key Vault"]
QueueAppRegAuth["Queue Client Secret Auth\nUsing secret in environmental variable"]
QueueMiAuth["Queue Managed Identity Auth"]
FailAuthQueue{{"End\n(Failed to select auth type)"}}
ChainAuth["Create Credential Chain"]
StoreAuthChain["Store the Cred Chain in class instance"]
GetToken["Get Entra ID Authentication Token"]
ExtractTenant["Extract Tenant ID"]
StoreTenantId["Store Tenant ID in State"]
SuccessEnd{{"End\n(Successful Execution)"}}

Start --> ValidateAuthData
ValidateAuthData --> ManagedIdentityIdCheck
ManagedIdentityIdCheck -.-> | Yes | CreateMiWithId
ManagedIdentityIdCheck -.-> | No | CreateMiWithoutId
CreateMiWithId --> | Managed Identity Credential | CheckAuthType
CreateMiWithoutId --> | Managed Identity Credential | CheckAuthType
CheckAuthType -.-> | Key Vault | QueueKvSecretAuth
CheckAuthType -.-> | App Registration | QueueAppRegAuth
CheckAuthType -.-> | Managed Identity | QueueMiAuth
CheckAuthType -.-> | Invalid State | FailAuthQueue
QueueKvSecretAuth --> | Azure Credential Object | ChainAuth
QueueAppRegAuth --> | Azure Credential Object | ChainAuth
QueueMiAuth --> | Azure Credential Object | ChainAuth
ChainAuth --> | Chained Credential Object | StoreAuthChain
StoreAuthChain --> | Chained Credential Object | GetToken
GetToken --> | Raw Auth Token | ExtractTenant
ExtractTenant --> | Tenant ID | StoreTenantId
StoreTenantId --> SuccessEnd
```
