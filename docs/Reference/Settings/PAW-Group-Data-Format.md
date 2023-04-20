### Overview

This application stores its PAW configuration in the security group description that the PAW is directly a member of.   
Because of this, do not change the description field that was configured by this app, otherwise you could cause issues with the management of your PAWs.   
Order of the description's items does not matter, the below config is displayed in a logical order, but the actual values may be in any order depending on the initialization of features and which order they were turned on.

### The current configuration specification lays out the below sections:
- [CommissionedDate](#CommissionedDate)
- [Type](#Type)
- [UserAssignment](#UserAssignment)

### Example Config:

```
CommissionedDate=2021-10-02T20:59:41.944Z,Type=Privileged,UserAssignment=12345678-e179-9ed1-79e1-d19e79e1d19e
```

---

### CommissionedDate
**Expected Data:**   
The toJSON() output of the Date object that represents the time when the PAW was commissioned.

**Description:**   
This is used to keep track of when a PAW was commissioned. This could be useful for audit, governance or tamper detection.

**Example:**   
`CommissionedDate=2021-10-02T20:59:41.944Z`

---

### Type
**Expected Data:**   
This is a string that represents the type of PAW that was commissioned.

**Description:**   
When a PAW is commissioned, it can only be commissioned as a specific type of PAW.   
This field will be used with the update and deployment engines for manageability.   
This field will also be useful for auditing, reporting, and searching.   
This field only accepts the following values: `Privileged`, `Developer`, or `Tactical`.

**Example:**   
`Type=Privileged`

---

### UserAssignment
**Expected Data:**   
The GUID of the settings catalog that controls the assignment of user accounts for the specified PAW.

**Description:**   
The settings catalog keeps track of the user accounts that are allowed to log into the PAW.   
This property is just a pointer to the relevant settings catalog.

**Example:**   
`UserAssignment=12345678-e179-9ed1-79e1-d19e79e1d19e`