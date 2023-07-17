# SSM - Intune Scope Tag

The [prefix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_prefix) and [suffix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_suffix) can be changed in the MSM server settings. The default settings are being used for the tag name below.

## Example Config

``` INI title="MSM - SSM"
AU=037b1de8-ed8e-4a6f-9647-80f24ec4c0e7
DevSg=473e19d7-9472-4575-9708-6c0ac3d92085
UsrSg=8beae504-9f15-429c-a64c-1c764c8bfd0b
```

---

### AU

**Expected Data:**
The Object ID (GUID) of the Administrative Unit that contains all of the specialized objects.

**Description:**
This is a normal AAD Admin Unit that contains a list of specialized security groups, devices, apps and users.
The membership of this AU is automatically maintained by MSM.

**Example:**
`SAu=037b1de8-ed8e-4a6f-9647-80f24ec4c0e7`

---

### DevSg

**Expected Data:**
The Object ID (GUID) of the Security Group that is the parent of all of the individual specialized device security groups.

**Description:**
This is used as the root search point to identify all of the specialized devices.
The application will treat all device identities and security groups under this SG to be specialized devices.

**Example:**
`DevSg=473e19d7-9472-4575-9708-6c0ac3d92085`

---

### UsrSg

**Expected Data:**
The Object ID (GUID) of the Security Group that is the parent of all of the individual specialized user security groups.

**Description:**
This is used as the root search point to identify all of the specialized users.
The application will treat all users identities and security groups under this SG to be specialized users.

**Example:**
`UsrSg=8beae504-9f15-429c-a64c-1c764c8bfd0b`

---
