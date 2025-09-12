# Usage Guide

This guide explains how to operate SHIELD once it's been deployed. It covers core infrastructure deployment, device and user lifecycle management, and links to detailed task-level workflows.

---

## Core Infrastructure Management

After deploying SHIELD, your first task is to set up the **Core Infrastructure**, which includes:

- Security groups
- Intune Scope Tags
- Entra ID Administrative Units
- Autopilot profiles
- Conditional Access baseline policies

These are deployed via the SHIELD UI at `{your-subdomain}.azurewebsites.net` using the **Deploy Core Infrastructure** card on the home screen.

!!! note "Immutable Components"
    Security groups, scope tags, and admin units cannot be changed after deployment. All other settings can be modified afterward.

📖 For step-by-step deployment instructions, see the [Deployment Guide](./Getting-Started.md)

---

## Lifecycle Management Overview

SHIELD provides full lifecycle control of identities and devices, organized by three security levels:

- **Enterprise**
- **Specialized**
- **Privileged**

Lifecycle actions include:

- Commissioning & decommissioning devices
- Assigning users to PAWs (Privileged Access Workstations)
- Creating and removing privileged users

These operations are triggered directly from the SHIELD app's **Lifecycle Management** section.

---

## Device Management

Device operations are performed through the Lifecycle interface. The following guides explain each task:

### Commission a Device

- Adds devices to SHIELD management
- Privileged devices are wiped/reset before being configured

📖 [Commission a Device](Defend/Usage-Guide/Device/0-Commission.md)  
📊 [Commission Workflow Diagram](Defend/Reference/Diagrams/Device-Commission.md)

---

### Decommission a Device

- Removes the device from SHIELD
- Privileged devices are reset and removed from their assigned groups

📖 [Decommission a Device](Defend/Usage-Guide/Device/1-Decommission.md)  
📊 [Decommission Workflow Diagram](Defend/Reference/Diagrams/Device-Decommission.md)

---

### Assign a User to a PAW

- Assigns allowed users to a privileged device
- All other users are blocked from login

📖 [Assign User](Defend/Usage-Guide/Device/2-Assign.md)  
📊 [Assignment Workflow](Defend/Reference/Diagrams/Device-Assign.md)

---

### Unassign a User

- Removes users from a PAW
- If no users remain, a wipe command is triggered

📖 [Unassign User](Defend/Usage-Guide/Device/3-Unassign.md)  
📊 [Unassign Workflow](Defend/Reference/Diagrams/Device-Unassign.md)

---

## User Management

SHIELD manages three user types — Privileged, Specialized, and Enterprise — and supports creating, onboarding, and offboarding these accounts.

### Commission a User

- Adds an existing Entra ID user or creates a new cloud-only privileged account
- Temporary credentials are shown upon creation

📖 [Commission a User](Defend/Usage-Guide/User/Commission.md)  
📊 [Commission Workflow](Defend/Reference/Diagrams/User-Commission.md)

---

### Decommission a User

- Removes the user from SHIELD
- Privileged accounts are deleted; others are de-tagged

📖 [Decommission a User](Defend/Usage-Guide/User/Decommission.md)  
📊 [Decommission Workflow](Defend/Reference/Diagrams/User-Decommission.md)

---

## Other Object Types

SHIELD will soon support additional lifecycle workflows:

- **Intermediaries** – Virtual session hosts or temporary worker devices
- **Interfaces/Servers** – Backend infrastructure and shared management planes

🛠️ Coming soon

---

## Summary

- Core Infrastructure must be deployed first
- Use Lifecycle Management to adopt and manage devices/users
- Task-level actions (commission, assign, etc.) are performed via the SHIELD UI
- Each action links to a detailed guide and diagram for deeper understanding
