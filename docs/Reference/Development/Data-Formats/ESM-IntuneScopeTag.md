# ESM - Intune Scope Tag

The [prefix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_prefix) and [suffix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_suffix) can be changed in the MSM server settings. The default settings are being used for the tag name below.

## Example Config

``` INI title="MSM - ESM"
AU=5b7c868e-98bf-437e-acf6-32c433328198
DevSg=66eeb4f4-91f8-431f-a336-1adf7bcb276f
UsrSg=3fd68a6f-0fd0-45b3-84ec-bfadccb10350
```

---

### AU

**Expected Data:**
The Object ID (GUID) of the Administrative Unit that contains all of the enterprise objects.

**Description:**
This is a normal AAD Admin Unit that contains a list of enterprise security groups, devices, apps and users.
The membership of this AU is automatically maintained by MSM.

**Example:**
`AU=5b7c868e-98bf-437e-acf6-32c433328198`

---

### DevSg

**Expected Data:**
The Object ID (GUID) of the Security Group that is the parent of all of the enterprise class device security groups.

**Description:**
This is used as the root search point to identify all of the enterprise devices.
The application will treat all device identities and security groups under this SG to be enterprise devices.

**Example:**
`DevSg=66eeb4f4-91f8-431f-a336-1adf7bcb276f`

---

### UsrSg

**Expected Data:**
The Object ID (GUID) of the Security Group that is the parent of all of the enterprise class user security groups.

**Description:**
This is used as the root search point to identify all of the enterprise users.
The application will treat all user identities and security groups under this SG to be enterprise users.

**Example:**
`UsrSg=3fd68a6f-0fd0-45b3-84ec-bfadccb10350`

---
