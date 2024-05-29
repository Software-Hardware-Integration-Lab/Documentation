# License Analytics

## Overview

The SHI License Analytics (SLA) is a system that retrieves the Microsoft Service configurations and performs analysis against the data to evaluate the count of license records that are required to satisfy the service configuration.
SLA also retrieves a count of purchased licenses so that it can make the determination if a license violation is in progress so that easy review of the overall compliance state of an organization can be saved into an Azure SQL Database of choice.

Once the data is in the Azure SQL Database, it is easy to integrate it into Business Intelligence software such as PowerBI to create reports.

Because the service configuration of each license is expressed differently, plugins are used to interface the core engine into the various configurations for the license in question.

---

## Technical Breakdown

SLA is broken into three distinct parts:

- Core Engine
- Database Boilerplate
- Plugins

## Core Engine

The core engine is responsible for authenticating to the various APIs, such as the M365 substrate, Graph API and Azure Rest API.

The core engine is also responsible for making sure the DB Tables are present and have the correct Schema.

The core engine's final responsibility is to enumerate, validate and execute the plugins.

## Database Boilerplate

The DB boilerplate system is responsible for ensuring data is in the correct format and running the SQL statements against the DB.

## Plugins

Plugins are responsible for retrieving and standardizing the service configuration data.

---

## See Also

- [Supported Licenses](Supported-Licenses.md)
- [Plugins](Plugins/Overview.md)
