# Environmental Variable Reference

Environmental variables are used to configure core behaviors/configurations of the server software.

The configurations are exposed as environmental variables rather than config files or registry keys to provide maximum support for wherever the server is hosted.
Config files don't work well in serverless environments where the state should not change, and the registry is only available on Windows.
Serverless, Windows, and Linux all share a common option: Environmental Variables. This works equally well across all of them.

Below is a list of all environmental variable configurations that the server can use. There are data format examples and descriptions so that you are not going blind to what a config can look like and does.

The title of the section is the name of the environmental variable.

For authentication configuration, please see here for more environmental variables that are supported by SHI URL Shortener via the Microsoft Authentication Library for Node.JS (@azure/identity):
<https://www.npmjs.com/package/@azure/identity#environment-variables>

---

## `SUS_TenantId`

- Mandatory: `true`
- Expected string format: GUID
- Allowed values: GUID
- Description: Tenant ID of the tenant that the app considers home/authenticates to. Defaults to NULL if not defined and should be overridden during authentication engine start.

## `SUS_DB_Host`

- Mandatory: `false`
- Expected string format: string
- Allowed values: string
- Description: Host name of the Azure SQL DB that should be used for storing simple data.

## `SUS_DB_Name`

- Mandatory: `false`
- Expected string format: string
- Allowed values: string
- Description: Name of the DB to access and use for relational data storage. This is necessary for Azure SQL DBs as the DB has to be created ahead of time and shouldn't be created inline as a best practice.

## `SUS_Debug`

- Mandatory: `false`
- Expected string format: boolean
- Allowed values: true
- Description: Flag that indicates if the API service should be in debug mode.

## `SUS_Headless`

- Mandatory: `false`
- Expected string format: boolean
- Allowed values: true
- Description: Flag that indicates the system should run with no user interface render.

## `SUS_LocalDb`

- Mandatory: `false`
- Expected string format: boolean
- Allowed values: true
- Description: Flag that indicates the SQLite should be used for the ORM. All other functions are untouched.

## `SUS_Local`

- Mandatory: `false`
- Expected string format: boolean
- Allowed values: true
- Description: Flag that controls if the server should run with local resources only. This uses SQLite and Azurite as the storage engines and endpoints.

## `SUS_DefaultTarget`

- Mandatory: `false`
- Expected string format: URL
- Allowed values: URL
- Description: Location that the service will redirect to if a match is not found.

## `SUS_AuthAudience`

- Mandatory: `false`
- Expected string format: GUID
- Allowed values: GUID
- Description: Ensure that a client ID is provided if not in debug mode for authentication

## `SUS_Test`

- Mandatory: `false`
- Expected string format: boolean
- Allowed values: true
- Description: Flag that indicates if the application should have special behavior based on if the system is running through automated QA.
