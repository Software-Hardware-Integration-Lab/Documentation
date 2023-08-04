# ESM - Intune Scope Tag

The [prefix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_prefix) and [suffix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_suffix) can be changed in the MSM server settings. The default settings are being used for the tag name below.

## Example Configurations

Example configurations of the enterprise security class Intune Scope Tag.

---

### Default Naming

``` INI title="MSM - ESM"
AU=5b7c868e-98bf-437e-acf6-32c433328198
DevSg=66eeb4f4-91f8-431f-a336-1adf7bcb276f
UsrSg=3fd68a6f-0fd0-45b3-84ec-bfadccb10350
SiloSg=628fceed-4c6c-42b6-ab15-8513a265b1b1
InterSg=814fb4a4-c484-4e41-80ff-089b61031221
```

### Custom Prefix and Suffix Naming

``` INI title="eLabs - ESM - Cloud"
AU=3e54c5c2-a2cf-4ca5-897e-97d706b5e31b
DevSg=d014ae16-7748-4722-ba28-196a008bcb30
UsrSg=08fd53d4-b002-40cf-bcfa-95a7fcda0bcd
SiloSg=3c80e644-e631-41f1-b426-0183482ef716
InterSg=8af317ee-7ce4-40c8-bd2a-b5fba7afe39e
```

---

## Properties

Technical details on the properties/values that can be set on the enterprise scope tag.

---

### AU

**Expected Data:**
The Object ID (GUID) of the Administrative Unit that contains all of the enterprise objects.

**Description:**
This is a normal Entra ID Admin Unit that contains a list of enterprise security groups, devices, apps and users.
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

### SiloSg

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the enterprise silos.

**Description:**
This security group only contains only security groups. The security groups that are members of this SG contain the configuration of their respective silo. Each security group that is a member of this SG represents a single silo.

This SG contains only enterprise silos.

**Example:**
`SiloSg=28cb89fe-8226-4fec-bd23-48481a264117`

---

### InterSg

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the enterprise intermediaries.

**Description:**
This security group only contains only security groups. The security groups that are members of this SG contain the configuration of their respective intermediary. Each security group that is a member of this SG represents a single intermediary.

This SG contains only enterprise intermediaries.

**Example:**
`InterSg=f3637d69-364b-48a3-8067-cb2305e332ef`
