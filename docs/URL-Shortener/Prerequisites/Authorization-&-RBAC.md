# Authorization & RBAC

The service expects upstream authentication (e.g., bearer token from Entra ID). These permissions are app roles defined on the ```End User Login``` app registration.

Elevated (Privileged) User Permissions:

| Scope Value             | Description |
|-------------------------|-------------|
| Everything.ReadWrite.All | Grants the principal the ability to read and write everything in SUS. This role is designed for moderation of all links created by all users as by default only the creating user has access to the link. This role can also be used as break glass access. This is a highly privileged role and should not be used normally. Please use the fine-grained roles where possible. |
| Redirect.ReadWrite.All  | Create, read, update and delete all URL redirects. Bypasses any RBAC and lets you see everything (no constraints). Do not use this for general access, please use the built-in RBAC. This is meant for automation and privileged admin/access. |
| Domain.ReadWrite.All    | Create, read, update and delete items from the list of domains allowed to be used for vanity URLs. Bypasses any RBAC and lets you see everything (no constraints). Do not use this for general access, please use the built-in RBAC. This is meant for automation and privileged admin/access. |
| BanList.ReadWrite.All   | Create, read, update and delete items on the banned term list. Bypasses any RBAC and lets you see everything (no constraints). Do not use this for general access, please use the built-in RBAC. This is meant for automation and privileged admin/access. |
| Rbac.ReadWrite.All      | Create, read, update and delete RBAC Assignments. Bypasses any RBAC and lets you see everything (no constraints). Do not use this for general access, please use the built-in RBAC. This is meant for automation and privileged admin/access. |

RBAC assignments are available to allow dynamic delegation without full superuser elevation.