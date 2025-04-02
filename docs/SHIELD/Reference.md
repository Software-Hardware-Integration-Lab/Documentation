# Reference

This reference section contains key technical specifications and supporting details for working with SHIELD, including:

- Microsoft Graph API permissions required for SHIELD functionality
- Hardware requirements based on security mode
- Full lifecycle workflow diagrams for both users and devices

---

## Microsoft Graph API Permissions

SHIELD requires specific Graph API permissions to function correctly. These permissions are either assigned automatically by SHIELD or require pre-assignment by an admin.

!!! note "Permission Scope Legend"
    ✅ = Automatically assigned by SHIELD
    ❌ = Must be manually assigned by an admin

### Entra ID Role Permissions

| Permission Name | Auto Granted | Description |
|-----------------|--------------|-------------|
| Privileged Authentication Administrator | ✅ | Required to delete privileged users with role lockouts. |

### Graph API Permissions

| Permission Name | Auto Granted | Description |
|-----------------|--------------|-------------|
| AdministrativeUnit.ReadWrite.All | ✅ | Manage restricted admin units. |
| AppRoleAssignment.ReadWrite.All | ❌ | Assign Managed Identity permissions. |
| Application.ReadWrite.All | ❌ | Create and maintain app registrations. |
| Device.ReadWrite.All | ✅ | Enumerate and tag Entra ID devices. |
| DeviceManagementApps.ReadWrite.All | ✅ | Configure Intune managed installer. |
| DeviceManagementConfiguration.ReadWrite.All | ✅ | Manage configuration profiles in Intune. |
| DeviceManagementManagedDevices.PrivilegedOperations.All | ✅ | Send Wipe commands to devices. |
| DeviceManagementManagedDevices.ReadWrite.All | ✅ | Remove old session hosts, list devices. |
| DeviceManagementRBAC.ReadWrite.All | ✅ | Manage scope tags and app config. |
| DeviceManagementServiceConfig.ReadWrite.All | ✅ | Read and manage Autopilot config. |
| Group.ReadWrite.All | ✅ | Manage security groups in Entra ID. |
| Policy.Read.All / Policy.ReadWrite.ConditionalAccess | ✅ | Enforce and manage Conditional Access policies. |
| RoleManagement.ReadWrite.Directory | ✅ | Assign roles to security groups. |
| User.ReadWrite.All | ✅ | Manage user lifecycle in Entra ID. |

### SHI Data Gateway Permissions

| Permission Name | Auto Granted | Description |
|-----------------|--------------|-------------|
| LicenseReport.ReadWrite | ✅ | Store license reports after Discover runs. |
| Telemetry.Sop.ReadWrite | ✅ | Upload monthly telemetry reports. |

### SHI Orchestration Platform Authenticator

| Permission Name | Auto Granted | Description |
|-----------------|--------------|-------------|
| Authenticator.Attest | ✅ | Authenticate SOP against tenant during API operations. |

---

## Hardware Requirements

Hardware requirements for SHIELD vary by security level.

### ESM & SSM (Enterprise/Specialized Security Modes)

| Requirement | Recommended |
|-------------|-------------|
| OS | Windows 10 or later |
| RAM | 16GB or higher |
| OEMs | Microsoft Surface, Lenovo |
| Graphics | NVIDIA preferred (no AMD) |

!!! info "Device Security Notes"
    Risk of firmware-level threats is lower in ESM/SSM. Still, choose reputable OEMs and avoid unsupported firmware.

### PSM (Privileged Security Mode)

| Requirement | Recommended |
|-------------|-------------|
| OS | Windows 11 Secure Core Certified |
| CPU | Intel i7 / Ryzen 7 or better |
| RAM | 32GB (16GB minimum) |
| Storage | 256GB NVMe |
| Certification | [Secure Core Certified](https://www.microsoft.com/en-us/windows/business/windows-11-secured-core-computers) |

!!! warning "Hardware Backdoor Risk"
    Avoid OEMs known to support master password removal or insecure firmware (e.g., older Dell, HP, Samsung). Prioritize Secure Core Certified devices from trusted vendors.

More info: 
- [Microsoft Secure Core Devices – Microsoft](https://www.microsoft.com/en-us/windows/business/devices?col=securedcorepc)

---

## Lifecycle Workflow Diagrams

The following flowcharts describe what happens behind the scenes during key lifecycle operations.

### Device Workflows

- 📊 [Device Commissioning](Defend/Reference/Diagrams/Device-Commission.md)
- 📊 [Device Decommissioning](Defend/Reference/Diagrams/Device-Decommission.md)
- 📊 [Device Assignment](Defend/Reference/Diagrams/Device-Assign.md)
- 📊 [Device Unassignment](Defend/Reference/Diagrams/Device-Unassign.md)

### User Workflows

- 📊 [User Commissioning](Defend/Reference/Diagrams/User-Commission.md)
- 📊 [User Decommissioning](Defend/Reference/Diagrams/User-Decommission.md)

These diagrams match the logic used in the SHIELD backend and provide a visual reference for each action.

---

## Related Pages

- [Deployment Guide](Getting-Started.md)
- [Usage Guide](Usage-Guide.md)
- [Prerequisites](Prerequisites.md)

