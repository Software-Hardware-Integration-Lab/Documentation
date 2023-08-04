# SSM - Intune Scope Tag

The [prefix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_prefix) and [suffix](/Reference/Settings/Environmental-Variables-Reference/#msm_name_suffix) can be changed in the MSM server settings. The default settings are being used for the tag name below.

## Example Configurations

Example configurations of the specialized security class Intune Scope Tag.

---

### Default Naming

``` INI title="MSM - SSM"
AU=037b1de8-ed8e-4a6f-9647-80f24ec4c0e7
DevSg=473e19d7-9472-4575-9708-6c0ac3d92085
UsrSg=8beae504-9f15-429c-a64c-1c764c8bfd0b
SiloSg=a5b56352-1a8f-46f1-9cbd-e23741f7d250
InterSg=3302d571-cd36-4206-8c97-357bab06067a
```

### Custom Prefix and Suffix Naming

``` INI title="eLabs - SSM - Cloud"
AU=f7992cd7-98d8-481d-82b4-8da77f3e99c9
DevSg=233dc85a-3199-4560-8094-97175b611637
UsrSg=d45e7fa0-050f-4635-819d-2ca063c37a7f
SiloSg=68b65d6b-2206-413f-82b3-70be052eeb09
InterSg=cf6169cf-fb48-46d8-a636-2c7cab3864d1
```

---

## Properties

Technical details on the properties/values that can be set on the specialized scope tag.

---

### AU

**Expected Data:**
The Object ID (GUID) of the Administrative Unit that contains all of the specialized objects.

**Description:**
This is a normal Entra ID Admin Unit that contains a list of specialized security groups, devices, apps and users.
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

### SiloSg

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the specialized silos.

**Description:**
This security group only contains only security groups. The security groups that are members of this SG contain the configuration of their respective silo. Each security group that is a member of this SG represents a single silo.

This SG contains only specialized silos.

**Example:**
`SiloSg=36cbf501-b13e-45cc-8f80-6d52a4429c89`

---

### InterSg

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the specialized intermediaries.

**Description:**
This security group only contains only security groups. The security groups that are members of this SG contain the configuration of their respective intermediary. Each security group that is a member of this SG represents a single intermediary.

This SG contains only specialized intermediaries.

**Example:**
`InterSg=7b7c24ab-fbc6-4ed3-8aae-6fe9103974ce`
