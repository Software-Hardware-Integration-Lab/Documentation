---
hide:
    - toc
---
# Device - Decommission

The lifecycle management engine is responsible for a variety of tasks. Below is the flowchart of the logical process that is completed when a device is [decommissioned](../../Usage-Guide/Device/1-Decommission.md).

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
InputValidation(["Validate Input and State"])
FailValidation{{"End\n(Stopped for security)"}}
ManagedDeviceRequest["Request Managed Device State"]
ManagementCheck(["Check if Device is Managed"])
FailNotManaged{{"End\n(Device is already not managed)"}}
PrivDevCheck(["Device Type Check"])
PrivExtAttrib["Remove Extension Attribute"]
PrivUsrAssign["Remove User Assignment Config"]
PrivGrpConf["Remove Group Assignment Config"]
DevSecGrp["Remove Device's Unique Security Group"]
WipePriv["Wipe Device"]
AdminUnit["Remove Device from Admin Unit"]
AutopilotSync["Run Autopilot Sync\n(If possible)"]
SuccessEnd{{"End\n(Successful Execution)"}}

Start --> | Device ID, Type | InputValidation
InputValidation -.->| Valid | ManagedDeviceRequest
InputValidation -.-> | Invalid | FailValidation
ManagedDeviceRequest -->| Managed Device State | ManagementCheck
ManagementCheck -.->| No | FailNotManaged
ManagementCheck -.->| Yes | PrivDevCheck
PrivDevCheck -.->| Privileged | PrivExtAttrib
PrivDevCheck -.->| Other | DevSecGrp
PrivExtAttrib --> PrivUsrAssign
PrivUsrAssign --> PrivGrpConf
PrivGrpConf --> WipePriv
WipePriv --> DevSecGrp
DevSecGrp --> AdminUnit
AdminUnit --> AutopilotSync
AutopilotSync --> SuccessEnd
```
