# Device Commission

Below is the flowchart of the logical process that is completed when a device is commissioned.

---

``` mermaid
graph TD

InputValidation[Validate Input and State]
FailValidation["End\n(Stopped for security)"]
UnmanagedDeviceRequest[Request Unmanaged Device State]
UnmanagedCheck[Check if requested device is already an existing managed device]
InitialTypeCheck[Check Requested Device Type]
DeviceUniqueGroup[Create Device Unique Group]
PrivTypeCheck[Check if Requested Device is Privileged]
PrivConfigAssign[Assign Configurations]
AddDevToDevGrp[Add Device to Unique Device Group]
DevToRootGrp[Add Unique Device Group to Root Group]
AutopilotSyncCmd["Run Autopilot Sync (if possible)"]
AddToAdminUnit[Add Device to Admin Unit]
PrivWipe[Wipe Device]
PrivLogin[Create Login Enforcement Policy]
PrivGroup[Create Local Group Membership Enforcement Policy]
PrivCaOemCheck[Check if the requested OEM in the Conditional Access Hardware Allowed List]
PrivCaModelCheck[Check if the requested Model in the Conditional Access Hardware Allowed List]
PrivHwOemEnforcement[Add OEM to Entra ID - CA Hardware Enforcement Policy]
PrivHwModelEnforcement[Add Model to Entra ID - CA Hardware Enforcement Policy]
ExistingEnd["End\n(Device already managed)"]
SuccessfulEnd["End\n(Successful Execution)"]

InputValidation --> | Valid | UnmanagedDeviceRequest
InputValidation --> | Invalid | FailValidation
UnmanagedDeviceRequest --> | Unmanaged Device Status | UnmanagedCheck
UnmanagedCheck --> | Yes | ExistingEnd
UnmanagedCheck --> | No | InitialTypeCheck
InitialTypeCheck --> | Privileged | PrivWipe
InitialTypeCheck --> | Other | DeviceUniqueGroup
PrivWipe --> PrivLogin
PrivLogin --> | New Settings Catalog Policy Object | PrivGroup
PrivGroup --> | New Policy Template Object | PrivCaOemCheck
PrivCaOemCheck --> | No | PrivHwOemEnforcement
PrivHwOemEnforcement --> PrivCaModelCheck
PrivCaOemCheck --> | Yes | PrivCaModelCheck
PrivCaModelCheck --> | No | PrivHwModelEnforcement
PrivCaModelCheck --> | Yes | DeviceUniqueGroup
PrivHwModelEnforcement --> DeviceUniqueGroup
DeviceUniqueGroup --> | New Group Object | PrivTypeCheck
PrivTypeCheck --> | Yes | PrivConfigAssign
PrivTypeCheck --> | No | AddDevToDevGrp
PrivConfigAssign --> AddDevToDevGrp
AddDevToDevGrp --> DevToRootGrp
DevToRootGrp --> AutopilotSyncCmd
AutopilotSyncCmd --> AddToAdminUnit
AddToAdminUnit --> SuccessfulEnd
```
