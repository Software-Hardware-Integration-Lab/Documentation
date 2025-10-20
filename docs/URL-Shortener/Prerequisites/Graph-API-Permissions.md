# Required Permissions

The application is broken up into two parts, the server and the end user experience. The server has permissions granted to it so that it can validate the incoming data. The end user experience has permissions so that the end user is able to provide IDs to the server for user and group assignments.

## Server - Service Principal

The following Entra ID Service Principal permissions are required to run the service. These are mandatory at all times.

| Graph API Permission| Permission Type |Description                                                                 |
|--------------------------------------------------------------------------------------|-----------------|-----------------------------------------------------------------------------|
| [`Group.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#groupreadall){:target="_blank"} | Application     | Used to validate group Object IDs provided as part of an RBAC assignment.  |
| [`User.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall){:target="_blank"} | Application     | Used to retrieve user's transitive group membership list for RBAC assignment validation. |

## End User Auth - Service Principal

| Graph API Permission                                                                 | Permission Type | Description                                                                 |
|--------------------------------------------------------------------------------------|-----------------|-----------------------------------------------------------------------------|
| [`profile`](https://learn.microsoft.com/en-us/graph/permissions-reference#profile){:target="_blank"} | Delegated       | Used to authenticate the end user.                                          |
| [`User.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall){:target="_blank"} | Delegated       | Used to authenticate the end user and retrieve their profile picture.       |
| [`Group.Read.All`](https://learn.microsoft.com/en-us/graph/permissions-reference#groupreadall){:target="_blank"} | Delegated       | Used to retrieve the list of groups that can be assigned in an RBAC assignment. |
