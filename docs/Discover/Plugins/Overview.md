# Overview

The Discover product uses plugins to retrieve data, normalize it and send it to the core engine for processing.

Each plugin can represent one or more license levels. A license level is a set of features that a customer can access based on their subscription plan. For example, the P1 license level includes basic features such as access reviews and identity protection, while the P2 license level includes advanced features such as entitlement management and identity governance.

Plugins are written in PowerShell and use the Discover PowerShell module to interact with the core engine. The Discover PowerShell module provides cmdlets for authentication, data validation, logging, error handling, and sending data to the core engine. Plugins can also use external APIs to retrieve data from different sources, such as Azure, Microsoft 365, or EntraID.

When evaluating the available licenses, container licenses are taken into account.
e.g. if you have E3 and E5 licenses and the Entra ID plugin is executed, the available P1 license count will be retrieved from both the E3 and E5 since both of those container licenses have P1 licenses.

Some plugins may have different behavior, please read the plugin details page for more information on the specific plugin in question.

Each plugin accesses a different set of service configurations and some plugins access configurations that are not available to global reader. Because of this, each plugin will have the necessary set of permissions documented on the plugin's page. Only the minimum set of permissions needed to operate are listed and the list doesn't inherit from other plugins.
