# Reference

This reference page for the Defend module provides a comprehensive view of all supporting technical material that underpins lifecycle management operations, including:

- Hardware requirements for each security class
- Full lifecycle diagrams for devices and users
- Notes on privileged workflows
- Relevant configuration examples

All information here is specific to the Defend module and complements the main [Usage Guide](../Usage-Guide/index.md).

---

## Hardware Requirements

SHIELD enforces hardware baselines per security class, especially for **Privileged Security Mode (PSM)**, to reduce the risk of compromise through firmware, bootkits, and untrusted supply chains.

### Enterprise and Specialized Modes (ESM/SSM)

| Requirement        | Recommendation                              |
|--------------------|----------------------------------------------|
| OS                | Windows 10 or later                         |
| RAM               | 16GB or more                                |
| OEM Devices       | Microsoft Surface or Lenovo preferred       |
| Graphics Support  | NVIDIA recommended (avoid AMD graphics)     |

!!! info "Device Security Considerations"
    In ESM/SSM, hardware risks are lower, but it’s still important to avoid unsupported OEMs and poor firmware hygiene. These devices typically handle non-elevated tasks.

### Privileged Mode (PSM)

| Requirement        | Recommendation                              |
|--------------------|----------------------------------------------|
| OS                | Windows 11 Secure Core Certified             |
| CPU               | Intel Core i7 or Ryzen 7 equivalent         |
| RAM               | 32GB recommended (16GB minimum)             |
| Storage           | 256GB+ NVMe SSD                             |
| Certification     | [Secure Core Certified](https://www.microsoft.com/en-us/windows/business/windows-11-secured-core-computers) |

!!! warning "Potential Hardware Backdoors"
    Avoid OEMs that allow firmware-level master password resets or silent security bypasses. SHIELD recommends only certified hardware from Microsoft and Lenovo for PSM operations.

---

## Lifecycle Workflow Diagrams

Each SHIELD lifecycle action is mapped to a standardized backend workflow. The following flowcharts show the logic for each user and device operation.

### Device Workflow Diagrams

#### Commission Device
📊 [Device - Commission](./Diagrams/Device-Commission.md)

#### Decommission Device
📊 [Device - Decommission](./Diagrams/Device-Decommission.md)

#### Assign User to Device
📊 [Device - Assign](./Diagrams/Device-Assign.md)

#### Unassign User from Device
📊 [Device - Unassign](./Diagrams/Device-Unassign.md)

---

### User Workflow Diagrams

#### Commission User
📊 [User - Commission](./Diagrams/User-Commission.md)

#### Decommission User
📊 [User - Decommission](./Diagrams/User-Decommission.md)

---

## Privileged Workflows (Coming Soon)

A dedicated section for advanced Privileged workflows, including intermediary logic and RBAC extensions, will be added in a future release.

📄 Placeholder: [Privileged Device Workflows](./Lifecycle/Privileged Device Workflows.md)

---

## Related Pages

- [Defend Usage Guide](../Usage-Guide/index.md)
- [Device Lifecycle](../Usage-Guide/Device/0-Commission.md)
- [User Lifecycle](../Usage-Guide/User/Commission.md)

