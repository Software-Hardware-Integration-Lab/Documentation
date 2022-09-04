### Overview

The application stores its core configuration in the Microsoft Endpoint Manager scope tag description field rather than needing to store it in a database.   
Because of this, do not change the scope tag that was configured by the application, otherwise you could cause issues with the management of your PAWs.   
Order of the description's items does not matter, the below config is displayed in a logical order, but the actual values may be in any order depending on the initialization of features and which order they were turned on.   
The maximum size of the description field is `1024` characters (including whitespaces and newlines).

### The current configuration specification lays out the below sections:
- [PAWSecGrp](#PAWSecGrp)
- [UsrSecGrp](#UsrSecGrp)
- [SiloRootGrp](#SiloRootGrp)
- [BrkGls](#BrkGls)
- [UsrTag](#UsrTag)

### Example Config:

```
PAWSecGrp=9ed1e179-e179-9ed1-79e1-d19e79e1d19e
UsrSecGrp=9ed1e179-e179-9ed1-79e1-d19e79e1d19e
SiloRootGrp=9ed1e179-e179-9ed1-79e1-d19e79e1d19e
BrkGls=9ed1e179-e179-9ed1-79e1-d19e79e1d19e
UsrTag=9ed1e179-e179-9ed1-79e1-d19e79e1d19e
```

---

### PAWSecGrp
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the individual PAW security groups.

**Description:**   
This is used as the root search point to identify all of the PAW devices.   
The application will treat all device identities and security groups under this SG to be PAW devices (where there is a 1:1 relationship for PAWs and SGs to target individual policies to individual PAWs.

**Example:**   
`PAWSecGrp=9ed1e179-e179-9ed1-79e1-d19e79e1d19e`

---

### UsrSecGrp
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the privileged users (Tier 0 or 1).

**Description:**   
This security group houses all of the privileged users.   
This is essentially the global silo that all priv users are a part of. All of the sec policies that apply to all priv users are assigned here.   
The silos should not be children of this security group. They should have their own top level SG.

**Example:**   
`UsrSecGrp=9ed1e179-e179-9ed1-79e1-d19e79e1d19e`

---

### SiloRootGrp
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the silo groups.

**Description:**    
The Root silo Security Group is used to a relationship to the rest of the silos.   
All security groups that are a member of the root silo group are considered to be individual silo from a management perspective.   
This security group should not be the same as the privileged users group that lists all of the privileged users.

**Example:**   
`SiloRootGrp=9ed1e179-e179-9ed1-79e1-d19e79e1d19e`

---

### BrkGls
**Expected Data:**   
This is the GUID of the "Break Glass" security group that contains all of the break glass accounts to be excluded.

**Description:**   
Emergency access accounts help restrict privileged access within an Azure AD organization. These accounts are highly privileged and aren't assigned to specific individuals. Emergency access accounts are limited to emergency for "break glass" scenarios where normal administrative accounts can't be used. Ensure that you control and reduce the emergency account's usage to only that time for which it's necessary.   
This configuration excludes the break glass accounts from the security that is applied by this app.

**Example:**   
`BrkGls=9ed1e179-e179-9ed1-79e1-d19e79e1d19e`

---

### UsrTag
**Expected Data:**   
The GUID of the Security Group that contains all of the privileged users.

**Description:**   
This security group only contains users. Specifically all of the privileged (priv) users.   
This group is assigned a permanent Azure AD role so that when the priv user logs into a Windows machine, the role's SID is exposed to the local machine. This can then be used to block authentication.

**Example:**   
`UsrTag=9ed1e179-e179-9ed1-79e1-d19e79e1d19e`

---