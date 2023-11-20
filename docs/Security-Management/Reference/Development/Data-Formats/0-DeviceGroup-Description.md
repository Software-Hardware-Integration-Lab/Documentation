# Device - Unique Group

This application stores its managed device configurations in the security group description that the managed device is directly a member of. Because of this, do not change the description field that was configured by this app, otherwise you could cause issues with the management of your devices.

Order of the description's items does not matter, the below config is displayed in a logical order. The actual values may be in any order depending on the initialization of features and which order they were turned on.

---

## Examples

Examples of various managed device unique group descriptions.

---

### Privileged Device

``` title="MSM - PSM - ce27fc58-0d74-4d72-bba2-105d8d90483f 💻"
CommissionedDate=2023-07-18T01:35:34.760Z,UserAssignment=8fe82ce9-cd69-4f4d-a6d0-8508fa163381,GroupAssignment=8e544b86-39ae-44c1-9ba4-0faeb456f259
```

### Privileged Device Hosted in Another Device

``` title="MSM - PSM - 029f899b-e08a-4434-8e47-355bea58680f 💻"
CommissionedDate=2023-07-18T01:35:34.760Z,UserAssignment=db9892d0-43f3-4688-b6c4-1a38267ca4cb,GroupAssignment=f6fbec86-904b-473f-be0d-3681df9022c8,ParentDevice=bf7b6877-5e7d-4945-a71f-b9b0f257e696
```

### Enterprise class device

``` title="MSM - ESM - 2db6bcf4-8cb3-4284-8ef4-57a525128344 💻"
CommissionedDate=2023-07-18T01:35:34.760Z
```

---

## Properties

Technical details on the properties/values that can be set on the device unique groups.

---

### CommissionedDate

**Expected Data:**
The JavaScript [`toJSON()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toJSON) output of the [`Date`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date) object that represents the time when the device was commissioned.

**Description:**
This is used to keep track of when a device was commissioned. This could be useful for audit, governance or tamper detection.

**Example:**
`CommissionedDate=2023-07-18T01:35:34.760Z`

---

### UserAssignment

**Expected Data:**
The object ID (GUID) of the settings catalog that controls the assignment of user accounts for the specified privileged device.

**Description:**
The settings catalog keeps track of the user accounts that are allowed to log into the privileged device.
This property is just a pointer to the relevant settings catalog.

Only privileged devices will have this property as user assignments only occur on privileged devices.

**Example:**
`UserAssignment=db9892d0-43f3-4688-b6c4-1a38267ca4cb`

---

### GroupAssignment

**Expected Data:**
The object ID (GUID) of the settings catalog that controls the local membership of user accounts for the specified privileged device.

**Description:**
The custom settings (OMA-URI) template enforces local admin and hyper-v admin rights on the local device.
This property is just a pointer to the relevant settings catalog.

Only privileged devices will have this property as strict local group management only occurs on privileged devices.

**Example:**
`GroupAssignment=f6fbec86-904b-473f-be0d-3681df9022c8`

---

### ParentDevice

**Expected Data:**
The Device ID (GUID) of the device that hosts the current device.

**Description:**
Devices can be hosted on other devices, this field is used to correlate these devices.
This will usually be used with privileged devices where a privileged device hosts another privileged device.

**Example:**
`ParentDevice=bf7b6877-5e7d-4945-a71f-b9b0f257e696`
