Debug mode exposes additional data and endpoints that can be used for troubleshooting the app.   
This can be consumed by an admin or by another dev.   
Enabling debug mode is a security risk, only enable it in a dev environment with minimal permissions as bad things can happen if threat actors find it.

---

Additional Endpoints:
- /stop
- /envVars
- /accessToken
- /testPost
- /roleScopeTag[/`<number>`]
- /deviceConfiguration[/`<guid>`]
- /deviceGroupPolicyConfiguration[/`<guid>`]
- /group[/`<guid>`]
- /user[/`<upn | guid>`]
- /adminUnit[/`<guid>`]
- /settingsCatalog[/`<guid`>]

Output Data:
- lorem ipsum