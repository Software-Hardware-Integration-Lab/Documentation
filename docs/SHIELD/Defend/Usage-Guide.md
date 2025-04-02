# Usage Guide

The Defend module in SHIELD provides lifecycle management for users and devices after the infrastructure is deployed. This guide explains how to perform key operations such as commissioning, decommissioning, assigning, and unassigning users or devices, all while respecting security class boundaries (Enterprise, Specialized, Privileged).

---

## Lifecycle Management Overview

Lifecycle Management is triggered from within the SHIELD web interface and allows you to:

- Onboard or offboard users and devices
- Assign users to Privileged Access Workstations (PAWs)
- Enforce metadata tagging and Intune integration
- Apply group policies and conditional access boundaries

All actions are class-aware and scoped by SHIELD’s infrastructure.

---

## Device Lifecycle Operations

Device lifecycle flows differ by class. Devices marked as Privileged undergo more stringent controls, such as wiping during onboarding.

### Commission a Device

Commissioning a device registers it with SHIELD and assigns lifecycle metadata. Privileged devices will be wiped if they are Intune-managed to ensure a clean baseline.

📖 [Commission a Device](Usage-Guide/Device/0-Commission.md)  
📊 [Workflow Diagram](Reference/Diagrams/Device-Commission.md)

#### UI Example

![Select Device - Light](../../assets/Images/Screenshots/Select-Unmanaged-Device-Light.png#only-light){ loading=lazy width="300" }
![Select Device - Dark](../../assets/Images/Screenshots/Select-Unmanaged-Device-Dark.png#only-dark){ loading=lazy width="300" }

!!! warning "Privileged Commissioning"
    Wipe commands are issued to Intune-managed devices during commissioning to protect against residual compromise.

---

### Decommission a Device

Removes a device from SHIELD’s lifecycle system.

📖 [Decommission a Device](Usage-Guide/Device/1-Decommission.md)  
📊 [Workflow Diagram](Reference/Diagrams/Device-Decommission.md)

---

### Assign a User to a PAW

Assigns one or more users to a privileged device (PAW). All others will be denied access.

📖 [Assign User](Usage-Guide/Device/2-Assign.md)  
📊 [Workflow Diagram](Reference/Diagrams/Device-Assign.md)

---

### Unassign a User from a PAW

Removes a user’s access from a PAW. If no users remain, a wipe is issued.

📖 [Unassign User](Usage-Guide/Device/3-Unassign.md)  
📊 [Workflow Diagram](Reference/Diagrams/Device-Unassign.md)

---

## User Lifecycle Operations

SHIELD supports onboarding and offboarding for both privileged and non-privileged users.

### Commission a User

Privileged users are created as new cloud-only accounts. Others are brought into management using existing identities. Temporary credentials are generated at creation.

📖 [Commission a User](Usage-Guide/User/Commission.md)  
📊 [Workflow Diagram](Reference/Diagrams/User-Commission.md)

#### UI Example

![Select User - Light](../../assets/Images/Screenshots/Select-Unmanaged-User-Light.png#only-light){ loading=lazy width="300" }
![Select User - Dark](../../assets/Images/Screenshots/Select-Unmanaged-User-Dark.png#only-dark){ loading=lazy width="300" }

#### Temporary Credential Dialog

![Temp Credentials - Light](../../assets/Images/Screenshots/Temporary-Credential-Dialog-Light.png#only-light){ loading=lazy }
![Temp Credentials - Dark](../../assets/Images/Screenshots/Temporary-Credential-Dialog-Dark.png#only-dark){ loading=lazy }

---

### Decommission a User

Privileged users are deleted from Entra ID. Non-privileged users are simply removed from SHIELD management.

📖 [Decommission a User](Usage-Guide/User/Decommission.md)  
📊 [Workflow Diagram](Reference/Diagrams/User-Decommission.md)

---

## Security Classes

All operations respect SHIELD’s class-based enforcement:

- **Enterprise**: standard users/devices with baseline protections
- **Specialized**: enhanced controls and policy targeting
- **Privileged**: strict isolation, hardware requirements, auto-wiping, credential controls

Class is selected at the top of the UI before performing lifecycle actions.

!!! note "Default Class"
    The UI defaults to **Privileged**. Make sure to adjust if managing non-privileged assets.

---

## Related Pages

- [Defend Overview](index.md)
- [Device Commissioning](Usage-Guide/Device/0-Commission.md)
- [User Commissioning](Usage-Guide/User/Commission.md)
- [Reference Diagrams](Reference.md)
- [Hardware Requirements](Reference/Hardware-Selection.md)