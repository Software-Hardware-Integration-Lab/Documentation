# Device Decommission

Below is the flowchart of the logical process that is completed when a device is decommissioned.

---

``` mermaid
graph TD

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
SuccessEnd{{"End"}}

Start --> | Device ID, Type | InputValidation
InputValidation -->| Valid | ManagedDeviceRequest
InputValidation --> | Invalid | FailValidation
ManagedDeviceRequest -->| Managed Device State | ManagementCheck
ManagementCheck -->| No | FailNotManaged
ManagementCheck -->| Yes | PrivDevCheck
PrivDevCheck -->| Privileged | PrivExtAttrib
PrivDevCheck -->| Other | DevSecGrp
PrivExtAttrib --> PrivUsrAssign
PrivUsrAssign --> PrivGrpConf
PrivGrpConf --> WipePriv
WipePriv --> DevSecGrp
DevSecGrp --> AdminUnit
AdminUnit --> AutopilotSync
AutopilotSync --> SuccessEnd
```
