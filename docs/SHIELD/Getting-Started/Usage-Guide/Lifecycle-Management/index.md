# Overview

Lifecycle management is the system that manages the various types of managed objects, such as users, devices, intermediaries (in development), interfaces/servers (also in development), and their unique configurations after the core infrastructure is deployed. It can adopt and abandon managed objects from the managed architecture.

The lifecycle management feature in the SHIELD app provides an easy-to-use UI that makes managing the relationship between security levels easy and the adoption of managed security controls feel familiar to the M365 environment. The lifecycle management engine is responsible for manipulating the device identity properly so that the correct set of metadata, categorization, microsegmentation, and management are applied. All lifecycle operations are designed to be scalable.

## How it works

The lifecycle management system gets triggered when a command is executed from the app's UI or API. Depending on the command, the back-end system may create unique configurations, edit existing ones, or create new user accounts. More specifics will be located in each child page for the respective category of actions (e.g., devices, users, interfaces, etc.).

## Managed Objects

### Devices

The SHIELD app manages two types of devices: privileged and enterprise. Privileged class managed devices can only be selected from a list of autopilot-enabled devices. Enterprise devices can be any device in Entra ID. For privileged devices, we recommend using devices that have never been turned on before and are ideally still in their packages. Also, for privileged devices, we only recommend Microsoft Surface or Lenovo devices. It is possible to use other devices, but we have not tested them and do not plan on supporting others. For privileged devices, we only recommend the laptop or slate form factor for security reasons.

Lifecycle management operations for devices include commission and decommission for all devices, assign user for privileged devices, and other specific operations depending on the device's security class.

### Users

The SHIELD app manages three types of users: privileged, specialized, and enterprise. These are security levels that determine the level of protection each user requires. Privileged users are the most secure, followed by specialized and enterprise.

Lifecycle management operations for users include creating, and removing user accounts, depending on the user's security class.

## Summary

Lifecycle management is a critical feature in the SHIELD app that enables the management of various managed objects, such as users and devices. With this feature, you can easily manage the relationship between security levels and adopt managed security controls in a familiar environment. The lifecycle management engine is scalable and responsible for manipulating device identities properly, so the correct set of metadata, categorization, microsegmentation, and management are applied.

## See Also

- Intermediaries Lifecycle Management - Coming Soon
- Interfaces/Servers Lifecycle Management - Coming Soon
