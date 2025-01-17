---
hide:
    - toc
---
# Device - Unassign

The lifecycle management engine is responsible for a variety of tasks. Below is the flowchart of the logical process that is completed when a device is [unassigned one or more users](../../../Usage-Guide/Device/3-Unassign.md).

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
failValidation{{"End\n(Stopped for security)"}}
readAssignedUsers["Get The List of Assigned Users"]
filterUserList["Filter the list of users to remove\nthe requested set of users"]
extractUserIdList["Extract the IDs from the\nfiltered list of users"]
convertToSid["Convert the Object ID List to a list of SIDs"]
checkAssignmentChange(["Check if the assignment has changed\nafter filtering has completed"])
failNoChange{{"End\n(No change in assignment)"}}
userRightsAssignment["Update User Rights Assignment\nwith the remaining set of SIDs"]
restrictedGroupConfig["Update Restricted Group Config\nwith the remaining set of SIDs"]
successEnd{{"End\n(Successful Execution)"}}

Start -->| Device ID, List of IDs | InputValidation
InputValidation -.->| Invalid | failValidation
InputValidation -.->| Valid | readAssignedUsers
readAssignedUsers --> | Managed User List | filterUserList
filterUserList --> | Filtered Managed User List | extractUserIdList
extractUserIdList --> | Object ID List | convertToSid
convertToSid --> | List of SIDs | checkAssignmentChange
checkAssignmentChange -.-> | List has changed | userRightsAssignment
checkAssignmentChange -.-> | No change detected | failNoChange
userRightsAssignment --> restrictedGroupConfig
restrictedGroupConfig --> successEnd
```
