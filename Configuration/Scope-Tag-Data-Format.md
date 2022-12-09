### Overview

The application stores its core configuration in the Microsoft Endpoint Manager scope tag description field rather than needing to store it in a database.   
Because of this, do not change the scope tag that was configured by the application, otherwise you could cause issues with the management of your PAWs.   
Order of the description's items does not matter, the below config is displayed in a logical order, but the actual values may be in any order depending on the initialization of features and which order they were turned on.   
The maximum size of the description field is `1024` characters (including whitespaces and newlines).

### The current configuration specification lays out the below sections:
- [PdSg](#PdSg)
- [SdSg](#SdSg)
- [EdSg](#EdSg)
- [PuSg](#PuSg)
- [SuSg](#SuSg)
- [EuSg](#EuSg)
- [SiloRootGrp](#SiloRootGrp)
- [BrkGls](#BrkGls)
- [UsrTag](#UsrTag)
- [PAU](#PAU)
- [SAU](#SAU)
- [EAU](#EAU)
- [V](#V)

### Example Config:

```
PdSg=0b7a6be8-deee-4f93-97bd-082926a7349c
SdSg=473e19d7-9472-4575-9708-6c0ac3d92085
EdSg=66eeb4f4-91f8-431f-a336-1adf7bcb276f
PuSg=e7f4c4f4-c457-45ae-883b-820b368f8310
SuSg=8beae504-9f15-429c-a64c-1c764c8bfd0b
EuSg=3fd68a6f-0fd0-45b3-84ec-bfadccb10350
SiloRootGrp=3b55565f-40c8-44bd-be5f-ba19f8f048e4
BrkGls=f73537be-1ab3-4023-a8b5-f360c38795ef
UsrTag=96735da7-260b-44aa-b7bd-f463bc5c9f4a
PAU=5767b44d-8e1c-4c1d-9770-675be4900e6d
SAU=037b1de8-ed8e-4a6f-9647-80f24ec4c0e7
EAU=5b7c868e-98bf-437e-acf6-32c433328198
v=123
```

---

### PdSg
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the unique privileged device security groups.

**Description:**   
This is used as the root search point to identify all of the privileged devices.   
The application will treat all device identities and security groups under this SG to be privileged devices (where there is a 1:1 relationship for devices and SGs to target individual policies to individual devices.

**Example:**   
`PdSg=0b7a6be8-deee-4f93-97bd-082926a7349c`

---

### SdSg
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the individual specialized device security groups.

**Description:**   
This is used as the root search point to identify all of the specialized devices.   
The application will treat all device identities and security groups under this SG to be specialized devices (where there is a 1:1 relationship for devices and SGs to target individual policies to individual devices.

**Example:**   
`SdSg=473e19d7-9472-4575-9708-6c0ac3d92085`

---

### EdSg
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the enterprise class device security groups.

**Description:**   
This is used as the root search point to identify all of the enterprise devices.   
The application will treat all device identities and security groups under this SG to be enterprise devices (where there is a 1:1 relationship for devices and SGs to target individual policies to individual devices.

**Example:**   
`EdSg=66eeb4f4-91f8-431f-a336-1adf7bcb276f`

---

### PuSg
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the unique privileged user security groups.

**Description:**   
This is used as the root search point to identify all of the privileged users.   
The application will treat all user identities and security groups under this SG to be privileged users (where there is a 1:1 relationship for users and SGs to target individual policies to individual users.

**Example:**   
`PuSg=e7f4c4f4-c457-45ae-883b-820b368f8310`

---

### SuSg
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the individual specialized user security groups.

**Description:**   
This is used as the root search point to identify all of the specialized users.   
The application will treat all users identities and security groups under this SG to be specialized users (where there is a 1:1 relationship for users and SGs to target individual policies to individual users.

**Example:**   
`SuSg=8beae504-9f15-429c-a64c-1c764c8bfd0b`

---

### EuSg
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the enterprise class user security groups.

**Description:**   
This is used as the root search point to identify all of the enterprise users.   
The application will treat all user identities and security groups under this SG to be enterprise users (where there is a 1:1 relationship for users and SGs to target individual policies to individual users.

**Example:**   
`EuSg=3fd68a6f-0fd0-45b3-84ec-bfadccb10350`

---

### SiloRootGrp
**Expected Data:**   
The GUID of the Security Group that is the parent of all of the silo groups.

**Description:**    
The Root silo Security Group is used to a relationship to the rest of the silos.   
All security groups that are a member of the root silo group are considered to be individual silo from a management perspective.   
This security group should not be the same as the privileged users group that lists all of the privileged users.

**Example:**   
`SiloRootGrp=3b55565f-40c8-44bd-be5f-ba19f8f048e4`

---

### BrkGls
**Expected Data:**   
This is the GUID of the "Break Glass" security group that contains all of the break glass accounts to be excluded.

**Description:**   
Emergency access accounts help restrict privileged access within an Azure AD organization. These accounts are highly privileged and aren't assigned to specific individuals. Emergency access accounts are limited to emergency for "break glass" scenarios where normal administrative accounts can't be used. Ensure that you control and reduce the emergency account's usage to only that time for which it's necessary.   
This configuration excludes the break glass accounts from the security that is applied by this app.

**Example:**   
`BrkGls=f73537be-1ab3-4023-a8b5-f360c38795ef`

---

### UsrTag
**Expected Data:**   
The GUID of the Security Group that contains all of the privileged users.

**Description:**   
This security group only contains users. Specifically all of the privileged (priv) users.   
This group is assigned a permanent Azure AD role so that when the priv user logs into a Windows machine, the role's SID is exposed to the local machine. This can then be used to block authentication.

**Example:**   
`UsrTag=96735da7-260b-44aa-b7bd-f463bc5c9f4a`

---

### PAU
**Expected Data:**   
The GUID of the Administrative Unit that contains all of the privileged objects.

**Description:**   
This is an AAD Restricted Admin Unit that contains a list of security groups, devices, apps and users.   
The group is made in such a way that existing admins will have no access (except for Priv Role and Global Admin).   
The membership of this AU is automatically maintained by MSM.

**Example:**   
`PAU=5767b44d-8e1c-4c1d-9770-675be4900e6d`

---

### SAU
**Expected Data:**   
The GUID of the Administrative Unit that contains all of the specalized objects.

**Description:**   
This is a normal AAD Admin Unit that contains a list of specalized security groups, devices, apps and users.   
The membership of this AU is automatically maintained by MSM.

**Example:**   
`SAU=037b1de8-ed8e-4a6f-9647-80f24ec4c0e7`

---

### EAU
**Expected Data:**   
The GUID of the Administrative Unit that contains all of the enterprise objects.

**Description:**   
This is a normal AAD Admin Unit that contains a list of enterprise security groups, devices, apps and users.   
The membership of this AU is automatically maintained by MSM.   

**Example:**   
`EAU=5b7c868e-98bf-437e-acf6-32c433328198`

---

### V
**Expected Data:**   
A whole number representing the deployed architecture specification.

**Description:**   
The whole number is incremented by 1 every time there is a change in the architecture specification. This number may differ from the version that the server is running and can be used to identifiy if the currently deployed architecture spec needs updating (in the case that the number is lower than what the server has) or that the server needs updating (in the case that the server has a lower number than what the currently deployed architecture spec reports). 

**Example:**   
`V=123`

---
