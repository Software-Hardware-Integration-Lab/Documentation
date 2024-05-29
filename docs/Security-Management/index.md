# SHI Environment Lockdown & Defense

## Overview

SHIELD is an orchestration tool that simplifies the deployment, management, and maintenance of Microsoft's Securing Privileged Access architecture. With SHIELD, you can automate the deployment of complex security infrastructures, device management, and user management while adhering to security best practices. SOP helps organizations to reduce the time and expertise required for deployment from a year or more to just a few minutes.

## Audience

This documentation is primarily intended for technical users who are responsible for the deployment, management, and maintenance of security infrastructures. However, the documentation is designed to be accessible to non-technical users as well.

## Key Features and Benefits

SOP comes with a range of features that simplify the deployment and management of complex security infrastructures. Some of the key features and benefits of SOP are:

- Automate the deployment of complex security infrastructures
- Manage devices, users, intermediaries, and server/interfaces with ease
- Adhere to security best practices
- Reduce maintenance efforts

## SOP in the Security Landscape

SOP is an orchestration tool in the larger security landscape. It does not bring new security functionality, but instead automates the tools that already exist. SOP operates as an orchestrator for the rest of the security landscape, simplifying the deployment and management of complex security infrastructures.

## Prerequisites

Check out this page for more details: [Getting Started - Prerequisites](Getting-Started/Prerequisites.md)

## Recommended Environment

While not mandatory, it is highly recommended to use SOP in the following environment:

- An `Azure Subscription` for hosting the application, as it is a security best practice to run the app in Azure
- All objects to be managed by SOP (devices, users, apps, etc.) synced/connected to Entra ID, the primary identity provider used by SOP

By following these recommendations, you can speed up the adoption process for SOP.

## Summary

In the rest of the documentation, we will provide detailed instructions on how to install, configure, and use SOP to achieve these benefits.

## See Also

- [Usage Guides](Getting-Started/Usage-Guide/index.md)
- Change Log - Coming Soon!
- [SOP Architecture](Reference/Architecture/index.md)
- [API Documentation](Reference/Development/OpenAPI.md)
- [Troubleshooting](Troubleshooting/Uninstall.md)
- [Contact Us](https://shilab.com/contact)
