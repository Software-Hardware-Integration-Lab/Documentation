# Reference

This page provides a complete reference for the Discover module, including plugins, schema, licensing models, and core configuration expectations.

---

## Plugin Overview

Discover uses a plugin architecture to retrieve data from Microsoft 365 services. Each plugin is executed independently, and the results are standardized before being uploaded to the Azure SQL database.

### Included Plugins

| Plugin | Description |
|--------|-------------|
| **EntraID** | Retrieves directory and user-level settings |
| **Defender for Endpoint** | Retrieves licensing status |
| **Defender for Identity** | Retrieves licensing status |

📖 Plugin logic is described in the [Execution Flow Diagram](./Architecture/Process-Flow.md)

---

## Supported Licenses

Discover analyzes how Microsoft 365 licenses are configured and applied. This includes SKUs across all verticals:

- Enterprise (E1, E3, E5)
- Education (A1, A3, A5)
- Government (G1, G3, G5)
- Frontline (F1, F3)

📖 License breakdown and mappings: [Supported Licenses](../Supported-Licenses.md)

---

## Reserved Principals

Some Entra ID accounts are marked as reserved and should not be altered by automation. Discover recognizes these automatically and excludes them from plugin evaluations.

📖 See list of principals in: [Reserved Principals](Reserved-Principals.md)

---

## Architecture and Flow Diagrams

### Infrastructure Diagram

📖 See [Infrastructure Diagram](../../../Data-Gateway/Architecture/Infrastructure.md)

- Shows PowerShell client to Entra ID + SQL interaction
- Includes threat model reference: [infrastructure.tm7](../../../Data-Gateway/assets/threat-models/Data-Gateway.tm7)

### Execution Flow

📖 See [Execution Flow](./Architecture/Process-Flow.md)

- Describes correlation record creation, plugin execution loop, and upload pattern

---

## Related Pages

- [Discover Overview](index.md)
- [Deployment](../Deployment/index.md)
- [Usage Guide](../Usage-Guide.md)
- [Troubleshooting](../Troubleshooting.md)
