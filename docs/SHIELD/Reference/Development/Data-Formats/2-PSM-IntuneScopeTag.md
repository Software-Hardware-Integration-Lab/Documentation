# PSM - Intune Scope Tag

The [prefix](../../Settings/Environmental-Variables-Reference.md#sop_name_prefix) and [suffix](../../Settings/Environmental-Variables-Reference.md#sop_name_suffix) can be changed in the SOP server settings. The default settings are being used for the tag name below.

## Example Configurations

Example configurations of the privileged security class Intune Scope Tag.

---

### Default Naming

``` INI title="SOP - PSM"
AU=5767b44d-8e1c-4c1d-9770-675be4900e6d
DevSg=0b7a6be8-deee-4f93-97bd-082926a7349c
UsrSg=e7f4c4f4-c457-45ae-883b-820b368f8310
SiloSg=973e7bb7-1e7b-4269-98f4-0e169aa4ce57
InterSg=8ee5bcdd-8406-4ad6-9845-6a36fb895438
Config=44c05cd0-8a3c-43fe-b47f-3ac329381d1b
UsrTag=96735da7-260b-44aa-b7bd-f463bc5c9f4a
```

### Custom Prefix and Suffix Naming

``` INI title="eLabs - PSM - Cloud"
AU=1d576094-f918-4741-8339-e93ae4e9a1d8
DevSg=3267afa7-9bfb-40ff-ba6b-096ba66a7d60
UsrSg=55435fae-7bc7-4bbd-a5fe-ecf896226324
SiloSg=7af57f26-5a4b-4188-8e0c-dab0a70ac6a9
InterSg=763b2330-6364-43b2-985f-e6d78a736b7d
Config=179ca1b2-de83-48c2-ac26-8e1d1a3c0951
UsrTag=cd0214b7-54b0-4211-bb5a-63798e197d20
```

---

## Properties

Technical details on the properties/values that can be set on the privileged scope tag.

---

### AU

**Expected Data:**
The Object ID (GUID) of the Administrative Unit that contains all of the privileged objects.

**Description:**
This is an Entra ID Restricted Admin Unit that contains a list of security groups, devices, apps and users.
The group is made in such a way (restricted AU) that existing admins will have no access. To manage objects in the AU, you need to have an AU scoped role assignment for this AU.
The membership of this AU is automatically maintained by SOP.

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

### SiloSg

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the privileged silos.

**Description:**
This security group only contains only security groups. The security groups that are members of this SG contain the configuration of their respective silo. Each security group that is a member of this SG represents a single silo.

This SG contains only privileged silos.

**Example:**
`SiloSg=b259dff3-34a7-43af-a2af-e94d36552cb9`

---

### InterSg

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the privileged intermediaries.

**Description:**
This security group only contains only security groups. The security groups that are members of this SG contain the configuration of their respective intermediary. Each security group that is a member of this SG represents a single intermediary.

This SG contains only privileged intermediaries.

**Example:**
`InterSg=b53d5d7d-d5c2-4d28-bf1f-7c3925cfc60e`

---

### Config

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the privileged configurations.

**Description:**
This security group is used for non-user/device configuration management, mostly for the marketplace and various intermediaries. This could also be used for by the end user to add config support to their custom stuff outside of SOP's lifecycle management and marketplace engines. This Security Group will be scanned for transitive membership count during license usage evaluation.

**Example:**
`Config=b0be63f9-d6ff-422b-b026-6e5e9ba8e15a`

---

### UsrTag

**Expected Data:**
The Object ID (GUID) of the Security Group that contains all of the privileged users.

**Description:**
This security group only contains users. Specifically all of the privileged (priv) users.
This group is assigned a permanent Entra ID role so that when the priv user logs into a Windows machine, the role's SID is exposed to the local machine. This can then be used to block authentication.

**Example:**
`UsrTag=96735da7-260b-44aa-b7bd-f463bc5c9f4a`
