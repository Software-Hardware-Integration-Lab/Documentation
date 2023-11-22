# Plugins

The MLA product uses plugins to retrieve data, normalize it and send it to the core engine for processing.

Each plugin can represent one or more license levels. A license level is a set of features that a customer can access based on their subscription plan. For example, the P1 license level includes basic features such as access reviews and identity protection, while the P2 license level includes advanced features such as entitlement management and identity governance.

Plugins are written in PowerShell and use the MLA PowerShell module to interact with the core engine. The MLA PowerShell module provides cmdlets for authentication, data validation, logging, error handling, and sending data to the core engine. Plugins can also use external APIs to retrieve data from different sources, such as Azure, Microsoft 365, or EntraID.
