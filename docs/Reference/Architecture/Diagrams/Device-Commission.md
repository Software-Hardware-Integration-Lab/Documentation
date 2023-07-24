---
hide:
    - toc
---
# Device - Commission

The lifecycle management engine is responsible for a variety of tasks. Below is the flowchart of the logical process that is completed when a device is [commissioned](/Getting-Started/Usage-Guide/Lifecycle-Management/Device/0-Commission/).

---

``` mermaid
flowchart TD

Start[/"Start"\]
Process["Process"]
Conditional(["Conditional Check"])
Stop{{"Stop Execution"}}

start1[ ] --> | Execution Flow, Carries Data | end1[ ]
style start1 height:0px;
style end1 height:0px;
start2[ ] -.-> | Decision, Caries data | end2[ ]
style start2 height:0px;
style end2 height:0px;
```

---

``` mermaid
flowchart TD

Start[/"Start"\]
InputValidation(["Validate Input and State"])
FailValidation{{"End\n(Stopped for security)"}}
UnmanagedDeviceRequest["Request Unmanaged Device State"]
UnmanagedCheck(["Check if requested device is already an existing managed device"])
InitialTypeCheck(["Device Type Check"])
DeviceUniqueGroup["Create Device Unique Group"]
PrivTypeCheck(["Check if Requested Device is Privileged"])
PrivConfigAssign["Assign Configurations"]
AddDevToDevGrp["Add Device to Unique Device Group"]
DevToRootGrp["Add Unique Device Group to Root Group"]
AutopilotSyncCmd["Run Autopilot Sync (if possible)"]
AddToAdminUnit["Add Device to Admin Unit"]
PrivWipe["Wipe Device"]
PrivLogin["Create Login Enforcement Policy"]
PrivGroup["Create Local Group Membership Enforcement Policy"]
PrivCaOemCheck(["Check if the requested OEM is in the Conditional Access Hardware Allowed List"])
PrivCaModelCheck(["Check if the Requested Device Model is in the Conditional Access Hardware Allowed List"])
PrivHwOemEnforcement["Add Device OEM to Entra ID - CA Hardware Enforcement Policy"]
PrivHwModelEnforcement["Add Device Model to Entra ID - CA Hardware Enforcement Policy"]
ExistingEnd{{"End\n(Device already managed)"}}
SuccessEnd{{"End\n(Successful Execution)"}}

Start --> | Device ID, Type | InputValidation
InputValidation -.-> | Valid | UnmanagedDeviceRequest
InputValidation -.-> | Invalid | FailValidation
UnmanagedDeviceRequest --> | Unmanaged Device Status | UnmanagedCheck
UnmanagedCheck -.-> | Yes | ExistingEnd
UnmanagedCheck -.-> | No | InitialTypeCheck
InitialTypeCheck -.-> | Privileged | PrivWipe
InitialTypeCheck -.-> | Other | DeviceUniqueGroup
PrivWipe --> PrivLogin
PrivLogin --> | New Settings Catalog Policy Object | PrivGroup
PrivGroup --> | New Policy Template Object | PrivCaOemCheck
PrivCaOemCheck -.-> | No | PrivHwOemEnforcement
PrivHwOemEnforcement --> PrivCaModelCheck
PrivCaOemCheck -.-> | Yes | PrivCaModelCheck
PrivCaModelCheck -.-> | No | PrivHwModelEnforcement
PrivCaModelCheck -.-> | Yes | DeviceUniqueGroup
PrivHwModelEnforcement --> DeviceUniqueGroup
DeviceUniqueGroup --> | New Group Object | PrivTypeCheck
PrivTypeCheck -.-> | Yes | PrivConfigAssign
PrivTypeCheck -.-> | No | AddDevToDevGrp
PrivConfigAssign --> AddDevToDevGrp
AddDevToDevGrp --> DevToRootGrp
DevToRootGrp --> AutopilotSyncCmd
AutopilotSyncCmd --> AddToAdminUnit
AddToAdminUnit --> SuccessEnd
```
