# PSM - Intune Scope Tag

The [prefix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_prefix) and [suffix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_suffix) can be changed in the MSM server settings. The default settings are being used for the tag name below.

## Example Config

``` INI title="MSM - PSM"
AU=5767b44d-8e1c-4c1d-9770-675be4900e6d
DevSg=0b7a6be8-deee-4f93-97bd-082926a7349c
UsrSg=e7f4c4f4-c457-45ae-883b-820b368f8310
UsrTag=96735da7-260b-44aa-b7bd-f463bc5c9f4a
```

---

### AU

**Expected Data:**
The Object ID (GUID) of the Administrative Unit that contains all of the privileged objects.

**Description:**
This is an AAD Restricted Admin Unit that contains a list of security groups, devices, apps and users.
The group is made in such a way (restricted AU) that existing admins will have no access. To manage objects in the AU, you need to have an AU scoped role assignment for this AU.
The membership of this AU is automatically maintained by MSM.

**Example:**
`AU=5767b44d-8e1c-4c1d-9770-675be4900e6d`

---

### DevSg

**Expected Data:**
The Object ID (GUID) of the Security Group that is the parent of all of the unique privileged device security groups.

**Description:**
This is used as the root search point to identify all of the privileged devices.
The application will treat all device identities and security groups under this SG to be privileged devices.

**Example:**
`DevSg=0b7a6be8-deee-4f93-97bd-082926a7349c`

---

### UsrSg

**Expected Data:**
The Object ID (GUID) of the Security Group that is the parent of all of the unique privileged user security groups.

**Description:**
This is used as the root search point to identify all of the privileged users.
The application will treat all user identities and security groups under this SG to be privileged users.

**Example:**
`UsrSg=e7f4c4f4-c457-45ae-883b-820b368f8310`

---

### UsrTag

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the privileged users.

**Description:**
This security group only contains users. Specifically all of the privileged (priv) users.
This group is assigned a permanent Azure AD role so that when the priv user logs into a Windows machine, the role's SID is exposed to the local machine. This can then be used to block authentication.

**Example:**
`UsrTag=96735da7-260b-44aa-b7bd-f463bc5c9f4a`

---
