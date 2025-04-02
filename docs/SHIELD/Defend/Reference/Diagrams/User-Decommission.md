---
hide:
    - toc
---
# User - Decommission

The lifecycle management engine is responsible for a variety of tasks. Below is the flowchart of the logical process that is completed when a user is [decommissioned](../../Usage-Guide/User/Decommission.md).

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
failValidation{{"End\n(Stopped for Security)"}}
checkIfManaged(["Check if the User Is Already Managed"])
failNotManaged{{"End\n(User Is Not Managed)"}}
checkSecurityType(["Check Requested Security Class Type"])
deleteUniqueGroup["Delete the Unique Security Group"]
deleteUser["Delete the User Account"]
removeAdminUnitMember["Remove the User From the\nCorresponding Admin Unit"]
successEnd{{"End\n(Successful Execution)"}}

Start -->| User ID, Type | InputValidation
InputValidation -.->| Invalid | failValidation
InputValidation -.->| Valid | checkIfManaged
checkIfManaged -.-> | User Is Not Managed | failNotManaged
checkIfManaged -.-> | User Is Managed by SHIELD | deleteUniqueGroup
deleteUniqueGroup --> checkSecurityType
checkSecurityType -.-> | Privileged | deleteUser
checkSecurityType -.-> | Specialized or Enterprise | removeAdminUnitMember
deleteUser --> successEnd
removeAdminUnitMember --> successEnd
```
