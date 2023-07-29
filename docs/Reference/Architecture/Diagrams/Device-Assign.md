---
hide:
    - toc
---
# Device - Assign

The lifecycle management engine is responsible for a variety of tasks. Below is the flowchart of the logical process that is completed when a device is [assigned one or more users](/Getting-Started/Usage-Guide/Lifecycle-Management/Device/2-Assign/).

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
getListOfAssignedUsers["Get The List of Assigned Users"]
mergeUserLists["Merge the list of IDs to assign and\nthe currently assigned user list\nkeeping only unique values"]
checkForNewAssignment(["Check if new users are to be assigned"])
failNoNewUser{{"End\n(No new users to assign)"}}
updateUserRightsAssignment["Update the User Rights Assignment Policy"]
updateRestrictedGroups["Update the Restricted Groups Policy"]
enrichUserList["Convert list of assigned IDs to managed users"]
successEnd{{"End\n(Successful Execution)"}}

Start -->| Device ID, List of IDs | InputValidation
InputValidation -.->| Invalid | failValidation
InputValidation -.->| Valid | getListOfAssignedUsers
getListOfAssignedUsers -->| Managed User List| mergeUserLists
mergeUserLists -->| Merged ID List | checkForNewAssignment
checkForNewAssignment -.-> | Merged ID list is the same as the input ID list | failNoNewUser
checkForNewAssignment -.-> | There are new IDs in the merged list | updateUserRightsAssignment
updateUserRightsAssignment --> updateRestrictedGroups
updateRestrictedGroups --> enrichUserList
enrichUserList --> | Updated Managed User List | successEnd
```
