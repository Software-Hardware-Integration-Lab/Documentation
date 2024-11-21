<#
.SYNOPSIS
    Deploys the SHIELD Platform web app to an Azure App Service.
.DESCRIPTION
    Creates a resource group in the specified subscription and deploys a web app to it.
    In Entra ID, an app registration is created to facilitate user login.
    Configures all the required permissions for operation.
.PARAMETER SubscriptionId
    The ID of the subscription to create an Az Web App for SOP to be hosted in.
.PARAMETER ResourceSubscriptionId
    Optionally, the ID of the subscription to host resources that SOP creates/manages.
    This is different from the 'SubscriptionId' parameter as the other parameter is where to host the SOP web app.
    The web app is not hosted in the resource subscription ID.
.PARAMETER ResourceGroupName
    Name of the resource group to create for the SOP app.
.PARAMETER Location
    Azure Region to create all of the resources in.
.PARAMETER AppRegistrationName
    Name prefix of the app registration to create in Entra ID.
.PARAMETER CompanyName
    Prefix of the Web App's unique name.
    Can only contain letters and the hyphen character.
    Must be globally unique.
.PARAMETER WebAppNameSuffix
    Text to append on the end of the web app that will be deployed.
.PARAMETER ClusterName
    Name of the Azure App Service Plan to create.
    This app service plan will host the web app that hosts the SOP app.
.PARAMETER AppServiceSku
    SKU of the web server cluster.
    The SKU can be changed after deployment if necessary.
    This is not a hard requirement of the app.
.PARAMETER DebugMode
    Enables the debug mode on the azure app service.
    THIS PARAMETER SHOULD NEVER BE USED UNLESS A SHI EMPLOYEE REQUESTS YOU TO USE IT.
    THIS PARAMETER WILL DISABLE ALL SECURITY SYSTEMS ON THE WEB APP AND ENABLE DEBUGGING APIs.
.PARAMETER Path
    Path to the Zip file to deploy to the azure app service.
    Relative paths are supported.
    Only Zip files are allowed.
.ROLE
    Security Architect
    Identity Architect
.INPUTS
    System.Guid
    System.String
    Switch (Boolean)
.OUTPUTS
    Void
.LINK
    https://docs.shilab.com
.NOTES
    This script requires the Az and Microsoft.Graph.Beta modules
    Exit Codes:
        1 - The Managed identity was not found after hitting the retry time out
        2 - The requested location is not valid for this subscription.
#>

#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Applications"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Az"; RequiredVersion="10.4.1" }

# Enable cmdlet binding for advanced functionality
[CmdletBinding(SupportsShouldProcess)]

# Define the parameter input to make this app customizable
param(
    [Parameter(Mandatory)]
    [System.Guid]$SubscriptionId,
    [ValidateNotNullOrEmpty()]
    [System.Guid]$ResourceSubscriptionId,
    [ValidateScript({ $_ -match '^[-\w\._\(\)]+$' })]
    [System.String]$ResourceGroupName = 'SHI-Inc-Security',
    [System.String]$Location = 'East US 2',
    [System.String]$AppRegistrationName = 'SHIELD',
    [Parameter(Mandatory)]
    [ValidateScript({ $_ -match '^[a-zA-Z]+[a-zA-Z-]*$' })]
    [System.String]$CompanyName,
    [ValidateScript({ $_ -match '^[a-zA-Z-]*[a-zA-Z]+$' })]
    [System.String]$WebAppNameSuffix = '-SOP',
    [ValidateScript({ $_ -match '^[a-zA-Z-]+$' })]
    [System.String]$ClusterName = 'SHI-Host',
    [ValidateSet('PremiumV3', 'Free', 'Basic')]
    [System.String]$AppServiceSku = 'PremiumV3',
    [Switch]$DebugMode,
    [ValidateScript({ Test-Path -Path $_ -PathType 'Leaf' -Include '*.zip' })]
    [Parameter(Mandatory)]
    [System.String]$Path
)

begin {
    # Get the metadata for the latest version of the Grant-MIGraphPermission script from the PS Gallery
    $GalleryScriptMeta = Find-Script -Name 'Grant-MIGraphPermission'

    # Get the required script's install state
    $InstalledScriptList = Get-InstalledScript -Name 'Grant-MIGraphPermission' -RequiredVersion $GalleryScriptMeta.Version -ErrorAction 'SilentlyContinue'

    # List of package providers installed
    [Microsoft.PackageManagement.Implementation.PackageProvider[]]$PackageProviderList = Get-PackageProvider

    # Check that the version of PS is below 6
    if ($PackageProviderList.Name -NotContains 'NuGet') {
        # Install package manager pre-req for legacy platform
        Install-PackageProvider -Name 'NuGet' -Scope 'CurrentUser' -Force | Out-Null
    }

    # Check if the required script is installed
    if ($InstalledScriptList.Name -ne 'Grant-MIGraphPermission') {
        # Install the script used to permission up managed identities
        Install-Script -Name 'Grant-MIGraphPermission' -Scope 'CurrentUser' -Force | Out-Null
    }

    # Log into the MS Graph API
    Connect-AzAccount -WarningAction 'SilentlyContinue' | Out-Null

    # Set the current Azure Working Location to the specified subscription
    Set-AzContext -Subscription $SubscriptionId | Out-Null

    # Get a list of locations (regions) that Azure supports based on the current auth session context
    [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceProviderLocation[]]$LocationList = Get-AzLocation

    # Check if the request location is present in the supported location list
    if ($LocationList.DisplayName -NotContains $Location) {
        # Write an error message to the console
        Write-Error -Message 'The location specified in the parameter is not available for the specified subscription.'

        # Stop execution with error code 2, see notes for details
        exit 2
    }

    # Get an access token that is good for the MS Graph API
    [Microsoft.Azure.Commands.Profile.Models.PSAccessToken]$AccessToken = Get-AzAccessToken -ResourceUrl 'https://graph.microsoft.com'

    # Log into the Microsoft Graph API
    Connect-MgGraph -AccessToken (ConvertTo-SecureString -AsPlainText -String $AccessToken.Token) | Out-Null
}

# Create an instance of the SHI Server Host setup
process {
    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Creating User Login Entra ID App Registration' -PercentComplete 0

    # Check if an app registration exists already
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphApplication]$UserAuthApp = Get-MgBetaApplication -Filter "displayName eq '$AppRegistrationName - User Login'"

    # Check if no App Registration was found
    if ($null -eq $UserAuthApp) {
        # Create the app tha handles the user authentication
        $UserAuthApp = New-MgBetaApplication -DisplayName "$AppRegistrationName - User Login" -Web @{redirectUris = "https://$CompanyName$WebAppNameSuffix.azurewebsites.net/Auth/Redirect" }
    }

    # Create the Graph API request body to create the App Reg's secret
    $AppRegSecretRequestBody = @{
        'PasswordCredential' = @{
            'displayName' = 'SHI Server User Authentication Module'
        }
        'endDateTime'        = (Get-Date).AddYears(2)
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Generating App Secret' -PercentComplete 10

    # Add a secret to the user authentication app registration with an expiration of 2 years
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphPasswordCredential]$UserAuthSecret = Add-MgBetaApplicationPassword -ApplicationId $UserAuthApp.Id -BodyParameter $AppRegSecretRequestBody

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Creating App Service Resource Group' -PercentComplete 20

    # Create a resource group for the server and other cloud resources to be hosted in
    [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup]$TargetRg = New-AzResourceGroup -Name $ClusterName -Location $Location

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Creating App Service Plan' -PercentComplete 30

    # Create a new Azure App Service Plan (server cluster) to host the Web App
    [Microsoft.Azure.Commands.WebApps.Models.WebApp.PSAppServicePlan]$WebHostCluster = New-AzAppServicePlan -Name $ClusterName -Linux -Tier $AppServiceSku -ResourceGroupName $TargetRg.ResourceGroupName -Location $TargetRg.Location

    # Define a hash table that configures the app settings for the SOP client auth
    [System.Collections.Hashtable]$AppSettings = @{
        'SOP_ClientAuth_TenantId'     = $AccessToken.TenantId
        'SOP_ClientAuth_ClientId'     = $UserAuthApp.AppId
        'SOP_ClientAuth_ClientSecret' = $UserAuthSecret.SecretText
    }

    # Inject debug mode if requested
    if ($DebugMode) { $AppSettings['SOP_Debug'] = 'true' }

    # Configure resource subscription if requested
    if ($ResourceSubscriptionId) { $AppSettings['SOP_Subscription_ID'] = "$ResourceSubscriptionId" }

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Creating Web App' -PercentComplete 40

    # Create the web app on the app service
    [Microsoft.Azure.Commands.WebApps.Models.PSSite]$WebApp = New-AzWebApp -Name "$CompanyName$WebAppNameSuffix" -IgnoreSourceControl -AppSettingsOverrides $AppSettings -AppServicePlan $WebHostCluster.Name -ResourceGroupName $TargetRg.ResourceGroupName -Location $TargetRg.Location

    # Define the configuration the web app should have
    [System.Collections.Hashtable]$WebAppConfig = @{
        'clientAffinityEnabled' = $true
        'siteConfig'            = @{
            'linuxFxVersion' = 'NODE|20-lts'
            'http20Enabled'  = $true
        }
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Configuring Web App, part 1/2' -PercentComplete 50

    # Configure the Web App settings that are not natively available via cmdlet
    Set-AzResource -Id $WebApp.Id -Properties $WebAppConfig -Force | Out-Null

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Configuring Web App, part 2/2' -PercentComplete 60

    # Set Web App settings for maximum performance and security and update the current Web App instance with the new data
    [Microsoft.Azure.Commands.WebApps.Models.PSSite]$WebApp = Set-AzWebApp -ResourceGroupName $TargetRg.ResourceGroupName -Name $WebApp.Name -AssignIdentity $true -HttpsOnly $true -AppSettings $AppSettings -AlwaysOn $true -FtpsState 'Disabled'

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Waiting for Managed Identity Replication' -PercentComplete 65

    # Set the presence detection to false
    [System.Boolean]$ManagedIdentityNotFound = $true
    [System.Int64]$LoopCycleCounter = 0

    # Wait for service principal to be replicated by periodically requesting the MI and looping on failure
    do {
        # Catch execution failures
        try {
            # Request the specified MI
            Get-MgBetaServicePrincipal -ServicePrincipalId $WebApp.Identity.PrincipalId -ErrorAction 'Stop' | Out-Null

            # Indicate MI is found
            $ManagedIdentityNotFound = $false
        }
        catch {
            # Wait for 5 seconds and then check again
            Start-Sleep -Seconds 5

            # Increment the loop counter
            $LoopCycleCounter++
        }
    } while ($ManagedIdentityNotFound -or $LoopCycleCounter -gt 12)

    # Check if the loop counter exited after timing out
    if ($LoopCycleCounter -gt 12) {
        # Write an error
        Write-Error -Message "The Managed Identity was not found after 60 seconds of waiting! Please check the MI exists or that there isn't a cloud outage"

        # Exit script execution with an error code returned
        exit 1
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Granting Web App MI Graph API Permissions' -PercentComplete 70

    # List of permissions to grant to the managed identity
    [System.String[]]$PermissionList = @(
        'Application.ReadWrite.All',
        'User.ReadWrite.All',
        'Group.ReadWrite.All',
        'AdministrativeUnit.ReadWrite.All',
        'Device.ReadWrite.All',
        'DeviceManagementManagedDevices.ReadWrite.All',
        'DeviceManagementConfiguration.ReadWrite.All',
        'DeviceManagementApps.ReadWrite.All',
        'DeviceManagementServiceConfig.ReadWrite.All',
        'DeviceManagementManagedDevices.PrivilegedOperations.All',
        'DeviceManagementRBAC.ReadWrite.All',
        'Directory.Write.Restricted',
        'RoleManagement.ReadWrite.Directory',
        'Policy.Read.All',
        'Policy.ReadWrite.ConditionalAccess'
    )

    # Managed identity object ID
    Grant-MIGraphPermission.ps1 -CLIMode -AccessToken (ConvertTo-SecureString -AsPlainText -String $AccessToken.Token) -ObjectID $WebApp.Identity.PrincipalId -PermissionName $PermissionList | Out-Null

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Granting Web App Azure RBAC self configuring permissions' -PercentComplete 80

    # Permission assignment on another subscription if another is requested
    if ($ResourceSubscriptionId -ne $null) {
        # Grant the managed identity the ability to manage the a resource subscription for various resource needs.
        New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope "/Subscriptions/$ResourceSubscriptionId" -RoleDefinitionName 'Owner' | Out-Null

        # Grant the ability to the web app to manage itself, useful for key management and the update engine.
        New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope $WebApp.id -RoleDefinitionName 'Website Contributor' | Out-Null
    }
    else {
        # Grant the managed identity the ability to self manage the SOP subscription.
        # This is useful for config drift identification and auto secret update for user auth and is also used for intermediaries.
        New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope "/Subscriptions/$SubscriptionId" -RoleDefinitionName 'Owner' | Out-Null
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Uploading SOP Zip file' -PercentComplete 90

    # Deploy the SOP binaries
    Publish-AzWebApp -WebApp $WebApp -ArchivePath $Path -Clean -Restart -Force | Out-Null

    # Display progress bar
    Write-Progress -Activity 'Deploying SOP to Az Web App' -Status 'Completed Deployment' -PercentComplete 100
}

end {
    # Log out of the Graph API
    Disconnect-MgGraph -ErrorAction 'SilentlyContinue' | Out-Null

    # Log out of the Azure API
    Disconnect-AzAccount -ErrorAction 'SilentlyContinue' | Out-Null
}
