# Silent Installation

## Overview

The installer is an MSI file, and the standard `/qn` switch for quiet no GUI installation works as expected.
In addition to the `/qn`, the SQL Server host name needs to be specified as a property at install time.

This additional property is mandatory as the default operation of MLA doesn't prompt for this value.

## Configuration Reference

|            Name            |     Mandatory    | Default Value |                           Description                            |
| :------------------------: | :--------------: | :-----------: | :--------------------------------------------------------------- |
|     `AZSQL_SERVER_FQDN`    | :material-check: |    nothing    |  FQDN of the Azure SQL Server that hosts the.                    |
|  `CORRELATION_TABLE_NAME`  | :material-close: | `Correlation` | Name of the table to use to store all of the corelation records. |
|      `DATABASE_NAME`       | :material-close: |   `Results`   | Name of the database that all of the records are saved to.       |
| `LICENSE_COUNT_TABLE_NAME` | :material-close: | `LicenseData` | Name of the table that contains all of the license data records. |

## Examples

```CMD title="Deploy MLA Silently"
License-Analytics.msi /qn AZSQL_SERVER_FQDN=moot-example.database.windows.net
```

!!! note "Naming Format"
    Replace `moot-example.database.windows.net` with the hostname of your Azure SQL Database Server. The hostname should be the name only, without any protocol specifiers (such as `sql://` or `https://`) or virtual directories.

```CMD title="Deploy with custom DB name"
License-Analytics.msi /qn AZSQL_SERVER_FQDN=moot-example.database.windows.net DATABASE_NAME=CustomerTracker
```

```CMD title="Custom Correlation Table Name"
License-Analytics.msi /qn AZSQL_SERVER_FQDN=moot-example.database.windows.net CORRELATION_TABLE_NAME=RunTracker
```

```CMD title="Custom License Data Table Name"
License-Analytics.msi /qn AZSQL_SERVER_FQDN=moot-example.database.windows.net LICENSE_COUNT_TABLE_NAME=CustomerTracker
```

## See Also

- [Getting Started](../Getting-Started.md)
