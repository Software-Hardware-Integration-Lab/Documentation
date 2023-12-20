# Prerequisites

Moot License Analytics is an enterprise product from Moot, Inc. that requires permissions and software to run.

## Software/System Configuration

- [X] The latest version of PowerShell 64Bit installed[^1]
- [X] Internet access with no traffic inspection for the Microsoft owned domains[^2]
- [X] 1GB of available RAM
- [X] [Azure SQL Database Configured](./Azure-SQL-Database.md)

!!! info "Assumptions"
    Our technical requirements are based off performance within an enterprise containing ~10,000 users performing data collection twice a month. For larger enterprises, or varying frequency of report generation, consider having a higher power machine and/or increasing storage capacity of the database.

## Permissions

The below Entra ID roles are required to be able to read all of the service configuration information.
The sub-bullet points are the description of what configurations are read by the permissions.

!!! info "Permissions Usage"
    Moot License Analytics will never change your service configuration in any way during an audit. All permissions are used only for data retrieval and are the set of least privilege possible for the data that is being gathered.

- [X] Global Reader
    - [Defender for Endpoint](../Plugins/DefenderEndpoint.md)
    - [Defender for Identity](../Plugins/DefenderIdentity.md)
    - [Entra ID P1 and P2](../Plugins/EntraID.md)
- [X] Security Administrator
    - [Defender for Endpoint](../Plugins/DefenderEndpoint.md)
    - [Defender for Identity](../Plugins/DefenderIdentity.md)
- [X] User Administrator
    - [Entra ID P1](../Plugins/EntraID.md)

## See Also

- [Getting Started](../Getting-Started.md)
- [Azure SQL Database Configuration](./Azure-SQL-Database.md)

[^1]: 7.4.0 is the latest at the time of writing.
[^2]: The software should work even if this is present, it just isn't guaranteed to work. You can read more about this requirement that Microsoft lays out on [this Microsoft Docs page](https://learn.microsoft.com/en-us/microsoft-365/enterprise/microsoft-365-network-connectivity-principles){:target="_blank"}.
