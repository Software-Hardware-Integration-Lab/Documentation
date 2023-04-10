<#
.SYNOPSIS
    Deploys the Moot Security Management web app to Azure
.DESCRIPTION
    Creates a resource group in the specified subscription and deploys a web app to it.
    In Azure AD, an app registration is created to facilitate user login.
.PARAMETER SubscriptionId
    The ID of the subscription to deploy the Azure Web to.
.PARAMETER ResourceGroupName
    Name of the resource group to create.
.PARAMETER Location
    Azure Region to create all of the resources in.
.PARAMETER AppRegistrationName
    Name prefix of the app registration to create in Azure AD
.LINK
    https://docs.mootinc.com
.NOTES
    Exit Codes:
        1 - The Managed identity was not found after hitting the retry time out
#>

# Enable cmdlet binding for advanced functionality
[CmdletBinding(SupportsShouldProcess)]

# Define the parameter input to make this app customizable
param(
    [Parameter(Mandatory)]
    [System.Guid]$SubscriptionId,
    [System.String]$ResourceGroupName = 'Moot-Inc-Security',
    [System.String]$Location = 'East US 2',
    [System.String]$AppRegistrationName = 'Moot Security Management',
    [Parameter(Mandatory)]
    [System.String]$CompanyName,
    [System.String]$WebAppNameSuffix = '-MSM',
    [System.String]$ClusterName = 'Moot-Host',
    [ValidateSet('PremiumV3', 'Free', 'Basic')]
    [System.String]$AppServiceSku = 'PremiumV3',
    [Switch]$DebugMode,
    [System.String]$Path = '.\Azure.App.Service.zip'
)

begin {
    # List of modules required to run this script
    [System.String[]]$RequiredModuleList = 'Microsoft.Graph.Authentication', 'Microsoft.Graph.Applications', 'Az.Accounts', 'Az.Resources', 'Az.Websites'

    # Get the required script's install state
    $InstalledScriptList = Get-InstalledScript -Name 'Grant-MIGraphPermission' -ErrorAction 'SilentlyContinue'
    
    # List of modules installed
    [System.Management.Automation.PSModuleInfo[]]$InstalledModuleList = Get-Module -Name $RequiredModuleList -ListAvailable

    # List of package providers installed
    [Microsoft.PackageManagement.Implementation.PackageProvider[]]$PackageProviderList = Get-PackageProvider

    # Check that the version of PS is below 6
    if ($PackageProviderList.Name -NotContains 'NuGet') {
        # Install package manager pre-req for legacy platform
        Install-PackageProvider -Name 'NuGet' -Scope 'CurrentUser' -Force | Out-Null
    }

    # Loop through each required module
    foreach ($ModuleName in $RequiredModuleList) {
        # Check if the current requested module is not installed
        if ($InstalledModuleList.Name -NotContains $ModuleName) {
            # Install it silently
            Install-Module -Name $ModuleName -Scope 'CurrentUser' -Force | Out-Null
        }
    }

    # Check if the required script is installed
    if ($InstalledScriptList.Name -ne 'Grant-MIGraphPermission') {
        # Install the script used to permission up managed identities
        Install-Script -Name 'Grant-MIGraphPermission' -Scope 'CurrentUser' -Force | Out-Null
    }

    # Log into the MS Graph API
    Connect-AzAccount | Out-Null

    # Set the current Azure Working Location to the specified subscription
    Set-AzContext -Subscription $SubscriptionId

    # Get an access token that is good for the MS Graph API
    [Microsoft.Azure.Commands.Profile.Models.PSAccessToken]$AccessToken = Get-AzAccessToken -ResourceUrl 'https://graph.microsoft.com'

    # Log into the Microsoft Graph API
    Connect-MgGraph -AccessToken $AccessToken.Token
}

# Create an instance of the Moot Server Host setup
process {
    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Creating User Login AAD Registration' -PercentComplete 0

    # Create the app tha handles the user authentication
    [Microsoft.Graph.PowerShell.Models.MicrosoftGraphApplication1]$UserAuthApp = New-MgApplication -DisplayName "$AppRegistrationName - User Login" -Web @{redirectUris = "https://$CompanyName$WebAppNameSuffix.azurewebsites.net/Auth/Redirect" }

    # Create the Graph API request body to create the App Reg's secret
    $AppRegSecretRequestBody = @{
        'PasswordCredential' = @{
            'displayName' = 'Moot Server User Authentication Module'
        }
        'endDateTime'        = (Get-Date).AddYears(2)
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Generating App Secret' -PercentComplete 10

    # Add a secret to the user authentication app registration with an expiration of 2 years
    [Microsoft.Graph.PowerShell.Models.MicrosoftGraphPasswordCredential]$UserAuthSecret = Add-MgApplicationPassword -ApplicationId $UserAuthApp.Id -BodyParameter $AppRegSecretRequestBody

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Creating App Service Resource Group' -PercentComplete 20

    # Create a resource group for the server and other cloud resources to be hosted in
    [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup]$TargetRg = New-AzResourceGroup -Name $ClusterName -Location $Location

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Creating App Service Plan' -PercentComplete 30

    # Create a new Azure App Service Plan (server cluster) to host the Web App
    [Microsoft.Azure.Commands.WebApps.Models.WebApp.PSAppServicePlan]$WebHostCluster = New-AzAppServicePlan -Name $ClusterName -Linux -Tier $AppServiceSku -ResourceGroupName $TargetRg.ResourceGroupName -Location $TargetRg.Location

    # Define a hash table that configures the app settings for the MSM client auth
    [System.Collections.Hashtable]$AppSettings = @{
        'MSM_ClientAuth_TenantId'     = $AccessToken.TenantId
        'MSM_ClientAuth_ClientId'     = $UserAuthApp.AppId
        'MSM_ClientAuth_ClientSecret' = $UserAuthSecret.SecretText
    }

    # Inject debug mode if requested
    if ($DebugMode) { $AppSettings['MSM_Debug'] = 'true' }

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Creating Web App' -PercentComplete 40

    # Create the web app on the app service
    [Microsoft.Azure.Commands.WebApps.Models.PSSite]$WebApp = New-AzWebApp -Name "$CompanyName$WebAppNameSuffix" -IgnoreSourceControl -AppSettingsOverrides $AppSettings -AppServicePlan $WebHostCluster.Name -ResourceGroupName $TargetRg.ResourceGroupName -Location $TargetRg.Location

    # Define the configuration the web app should have
    [System.Collections.Hashtable]$WebAppConfig = @{
        'clientAffinityEnabled' = $true
        'siteConfig'            = @{
            'linuxFxVersion' = 'NODE|18-lts'
            'http20Enabled'  = $true
        }
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Configuring Web App, part 1/2' -PercentComplete 50

    # Configure the Web App settings that are not natively available via cmdlet
    Set-AzResource -Id $WebApp.Id -Properties $WebAppConfig -Force

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Configuring Web App, part 2/2' -PercentComplete 60

    # Set Web App settings for maximum performance and security and update the current Web App instance with the new data
    [Microsoft.Azure.Commands.WebApps.Models.PSSite]$WebApp = Set-AzWebApp -ResourceGroupName $TargetRg.ResourceGroupName -Name $WebApp.Name -AssignIdentity $true -HttpsOnly $true -AppSettings $AppSettings -AlwaysOn $true -FtpsState 'Disabled'

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Waiting for Managed Identity Replication' -PercentComplete 65

    # Set the presence detection to false
    [System.Boolean]$ManagedIdentityNotFound = $true
    [System.Int64]$LoopCycleCounter = 0
    
    # Wait for service principal to be replicated by periodically requesting the MI and looping on failure
    do {
        # Catch execution failures
        try {
            # Request the specified MI
            Get-MgServicePrincipal -ServicePrincipalId $WebApp.Identity.PrincipalId

            # Indicate MI is found
            $ManagedIdentityNotFound = $false
        } catch {
            # Wait for 5 seconds and then check again
            Start-Sleep -Seconds 5

            # Increment the loop counter
            $LoopCycleCounter++
        }
    } while ($ManagedIdentityNotFound -or $LoopCycleCounter -gt 12)

    # Check if the loop counter exited after timing out
    if ($LoopCycleCounter -gt 12) {
        # Write an error
        Write-Error -Message "The Managed IDentity was not found after 60 seconds of waiting! Please check the MI exists or that there isn't a cloud outage"
        
        # Exit script execution with an error code returned
        exit 1
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Granting Web App MI Graph API Permissions' -PercentComplete 70

    # Managed identity object ID
    Grant-MIGraphPermission -CLIMode -AccessToken $AccessToken.Token -ObjectID $WebApp.Identity.PrincipalId -PermissionName 'Application.ReadWrite.All', 'User.ReadWrite.All', 'Group.ReadWrite.All', 'AdministrativeUnit.ReadWrite.All', 'Device.ReadWrite.All', 'DeviceManagementManagedDevices.Read.All', 'DeviceManagementConfiguration.ReadWrite.All', 'DeviceManagementServiceConfig.ReadWrite.All', 'DeviceManagementManagedDevices.PrivilegedOperations.All', 'DeviceManagementRBAC.ReadWrite.All', 'RoleManagement.ReadWrite.Directory', 'Policy.Read.All', 'Policy.ReadWrite.ConditionalAccess'

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Granting Web App Azure RBAC self configuring permissions' -PercentComplete 80

    # Grant the managed identity the ability to self manage the MSM web app. This is useful for config drift identification and auto secret update for user auth
    New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope $WebApp.id -RoleDefinitionName 'Website Contributor'

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Uploading MSM Zip file' -PercentComplete 90

    # Deploy the MSM binaries
    Publish-AzWebApp -WebApp $WebApp -ArchivePath $Path -Force

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Completed Deployment' -PercentComplete 100
}

end {
    # Log out of the Graph API
    Disconnect-MgGraph -ErrorAction 'SilentlyContinue'

    # Log out of the Azure API
    Disconnect-AzAccount -ErrorAction 'SilentlyContinue'
}
