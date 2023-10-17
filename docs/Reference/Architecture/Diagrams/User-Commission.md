---
hide:
    - toc
---
# User - Commission

The lifecycle management engine is responsible for a variety of tasks. Below is the flowchart of the logical process that is completed when a user is [commissioned](../../../Getting-Started/Usage-Guide/Lifecycle-Management/User/Commission.md).

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
getTemplateUser["Get Existing Entra ID\nUser Data"]
checkIfManaged(["Check if the User Is Already Managed"])
failAlreadyManaged{{"End\n(User Is Already Managed)"}}
checkSecurityType(["Check Requested Security Class Type"])
createNewUser["Create New Privileged User"]
createUniqueGroup["Create Unique Security Group"]
addToGroup["Add User to Unique Group"]
addUniqueGroupToRootGroup["Add the Unique Group to the\nType's Corresponding Root Group"]
checkPrivType(["Check if a Privileged User Was Created"])
addToTagGroup["Add User to Privileged Tagging Group"]
successEnd{{"End\n(Successful Execution)"}}

Start -->| User ID, Type | InputValidation
InputValidation -.->| Invalid | failValidation
InputValidation -.->| Valid | getTemplateUser
getTemplateUser --> | Entra ID User Object | checkIfManaged
checkIfManaged -.-> | Managed User Present | failAlreadyManaged
checkIfManaged -.-> | Not Managed or 'Privileged' Type Requested | checkSecurityType
checkSecurityType -.-> | Privileged | createNewUser
checkSecurityType -.-> | Enterprise or Specialized | createUniqueGroup
createNewUser --> | New User Object | createUniqueGroup
createUniqueGroup --> | Entra ID Group Object | addToGroup
addToGroup --> addUniqueGroupToRootGroup
addUniqueGroupToRootGroup --> checkPrivType
checkPrivType -.-> | Privileged | addToTagGroup
checkPrivType -.-> | Specialized or Enterprise | successEnd
addToTagGroup --> successEnd
```
