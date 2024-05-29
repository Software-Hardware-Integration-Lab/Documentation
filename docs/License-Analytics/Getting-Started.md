# Getting Started

Please read through the [prerequisites](Deployment/0-Prerequisites.md) to make sure you have all you need before you begin.

If you have not already installed the SLA app, please follow the [installation guide](Deployment/Standard-Install.md).

## Default Mode

Default mode runs SLA authentication in a InPrivate/Incognito window.
It also uses all of the configured database settings and can't be overridden.
The majority of the time, this is what should be run. Please reach out to SHI or your security department if other options are required.

1. Double click the desktop icon titled `Run License Analytics`

2. Log into the Az SQL Database (Only first log in screen)

3. Log into the tenant to be analyzed (All subsequent login screens)

    !!! info "Authentication Info"
        The first authentication prompt is for the tenant that the reports will be saved in.
        Log in with the account that is authorized to write to the reports DB.

        The next set of login prompts are for the tenant that should be analyzed for license compliance.
        You will need to log into the account more than once due to the type of systems that will be analyzed.

4. Sit back and relax while the engine retrieves and reports the compliance status of the target tenant.

## CLI Mode

1. Open PowerShell 7

2. Run `Get-LicenseCompliance`

    !!! info "Configuration Info"
        For information on the various modes of operation, parameters, and configurations, please run `Get-Help Get-LicenseCompliance` to get the latest information.

3. Log into the Az SQL and tenant to be analyzed.

    !!! info "Authentication Info"
        The first authentication prompt is for the tenant that the reports will be saved in.
        Log in with the account that is authorized to write to the reports DB.

        The next set of login prompts are for the tenant that should be analyzed for license compliance.
        You will need to log into the account more than once due to the type of systems that will be analyzed.

4. Sit back and relax while the engine retrieves and reports the compliance status of the target tenant.

## See Also

- [Prerequisites](Deployment/0-Prerequisites.md)
- [Installation Guide](Deployment/Standard-Install.md)
- [Silent Installation](Deployment/Silent-Installation.md)
- [Installing PowerShell on Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
