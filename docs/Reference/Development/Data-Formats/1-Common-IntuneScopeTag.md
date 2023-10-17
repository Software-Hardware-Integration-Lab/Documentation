# Common (Root) - Intune Scope Tag

The application stores its core configuration in the Microsoft Intune scope tag description field rather than needing to store it in a database.
Because of this, do not change the scope tag that was configured by the application, otherwise you could cause issues with the management of your PAWs.
Order of the description's items does not matter, the below config is displayed in a logical order, but the actual values may be in any order depending on the initialization of features and which order they were turned on.
The maximum size of the description field is `1024` characters (including whitespace and newlines).

The title of the (Role) Scope Tag in Intune may differ depending on the settings being used on the MSM server [(see the env vars docs for details)](../../Settings/Environmental-Variables-Reference.md#msm_scope_tag). The default value is `Moot-Security-Management`. For these docs, that is what the tag title is.

## Example Configurations

Example configurations of the root Intune Scope Tag.

---

### Default Name

``` INI title="Moot-Security-Management"
PsmId=21
SsmId=20
EsmId=19
BrkGls=f73537be-1ab3-4023-a8b5-f360c38795ef
V=1
```

### Custom Name for Scope Tag

``` INI title="eLabs-Security-Automation"
PsmId=5
SsmId=4
EsmId=3
BrkGls=c11055f2-0bae-4051-a94c-a03463786616
V=3
```

---

## Properties

Technical details on the properties/values that can be set on the root/common scope tag.

---

### PsmId

**Expected Data:**
This is a whole number that is the unique ID of the scope tag.

**Description:**
This is the ID of the Intune Role Scope Tag that separates privileged configurations from other [security classes](../../Architecture/Securing-Privileged-Access.md). The description field also contains additional context and configurations as described [here](2-PSM-IntuneScopeTag.md).

**Example:**
`PsmId=21`

---

### SsmId

**Expected Data:**
This is a whole number that is the unique ID of the scope tag.

**Description:**
This is the ID of the Intune Role Scope Tag that separates specialized configurations from other [security classes](../../Architecture/Securing-Privileged-Access.md). The description field also contains additional context and configurations as described [here](3-SSM-IntuneScopeTag.md).

**Example:**
`SsmId=21`

---

### EsmId

**Expected Data:**
This is a whole number that is the unique ID of the scope tag.

**Description:**
This is the ID of the Intune Role Scope Tag that separates enterprise configurations from other [security classes](../../Architecture/Securing-Privileged-Access.md). The description field also contains additional context and configurations as described [here](4-ESM-IntuneScopeTag.md).

**Example:**
`EsmId=21`

---

### BrkGls

**Expected Data:**
This is the Object ID (GUID) of the "Break Glass" security group that contains all of the break glass accounts to be excluded.

**Description:**
Emergency access accounts help restrict privileged access within an Entra ID organization. These accounts are highly privileged and aren't assigned to specific individuals. Emergency access accounts are limited to emergency for "break glass" scenarios where normal administrative accounts can't be used. Ensure that you control and reduce the emergency account's usage to only that time for which it's necessary.
This configuration excludes the break glass accounts from the security that is applied by this app.

**Example:**
`BrkGls=f73537be-1ab3-4023-a8b5-f360c38795ef`

---

### V

**Expected Data:**
A whole number representing the deployed architecture specification.

**Description:**
The whole number is incremented by 1 every time there is a change in the architecture specification. This number may differ from the version that the server is running and can be used to identify if the currently deployed architecture spec needs updating (in the case that the number is lower than what the server has) or that the server needs updating (in the case that the server has a lower number than what the currently deployed architecture spec reports).

**Example:**
`V=123`
