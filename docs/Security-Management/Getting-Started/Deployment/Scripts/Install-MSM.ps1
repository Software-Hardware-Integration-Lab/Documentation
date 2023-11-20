<#
.SYNOPSIS
    Deploys the Moot Security Management web app to an Azure App Service.
.DESCRIPTION
    Creates a resource group in the specified subscription and deploys a web app to it.
    In Entra ID, an app registration is created to facilitate user login.
    Configures all the required permissions for operation.
.PARAMETER SubscriptionId
    The ID of the subscription to create an Az Web App for MSM to be hosted in.
.PARAMETER ResourceSubscriptionId
    Optionally, the ID of the subscription to host resources that MSM creates/manages.
    This is different from the 'SubscriptionId' parameter as the other parameter is where to host the MSM web app.
    The web app is not hosted in the resource subscription ID.
.PARAMETER ResourceGroupName
    Name of the resource group to create for the MSM app.
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
    This app service plan will host the web app that hosts the MSM app.
.PARAMETER AppServiceSku
    SKU of the web server cluster.
    The SKU can be changed after deployment if necessary.
    This is not a hard requirement of the app.
.PARAMETER DebugMode
    Enables the debug mode on the azure app service.
    THIS PARAMETER SHOULD NEVER BE USED UNLESS A MOOT EMPLOYEE REQUESTS YOU TO USE IT.
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
    https://docs.mootinc.com
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
    [System.String]$ResourceGroupName = 'Moot-Inc-Security',
    [System.String]$Location = 'East US 2',
    [System.String]$AppRegistrationName = 'Moot Security Management',
    [Parameter(Mandatory)]
    [ValidateScript({ $_ -match '^[a-zA-Z]+[a-zA-Z-]*$' })]
    [System.String]$CompanyName,
    [ValidateScript({ $_ -match '^[a-zA-Z-]*[a-zA-Z]+$' })]
    [System.String]$WebAppNameSuffix = '-MSM',
    [ValidateScript({ $_ -match '^[a-zA-Z-]+$' })]
    [System.String]$ClusterName = 'Moot-Host',
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

# Create an instance of the Moot Server Host setup
process {
    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Creating User Login Entra ID App Registration' -PercentComplete 0

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
            'displayName' = 'Moot Server User Authentication Module'
        }
        'endDateTime'        = (Get-Date).AddYears(2)
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Generating App Secret' -PercentComplete 10

    # Add a secret to the user authentication app registration with an expiration of 2 years
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphPasswordCredential]$UserAuthSecret = Add-MgBetaApplicationPassword -ApplicationId $UserAuthApp.Id -BodyParameter $AppRegSecretRequestBody

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

    # Configure resource subscription if requested
    if ($ResourceSubscriptionId) { $AppSettings['MSM_Subscription_ID'] = "$ResourceSubscriptionId" }

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
    Set-AzResource -Id $WebApp.Id -Properties $WebAppConfig -Force | Out-Null

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
            Get-MgBetaServicePrincipal -ServicePrincipalId $WebApp.Identity.PrincipalId -ErrorAction 'Stop' | Out-Null

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
        Write-Error -Message "The Managed Identity was not found after 60 seconds of waiting! Please check the MI exists or that there isn't a cloud outage"
        
        # Exit script execution with an error code returned
        exit 1
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Granting Web App MI Graph API Permissions' -PercentComplete 70

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
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Granting Web App Azure RBAC self configuring permissions' -PercentComplete 80

    # Permission assignment on another subscription if another is requested
    if ($ResourceSubscriptionId -ne $null) {
        # Grant the managed identity the ability to manage the a resource subscription for various resource needs.
        New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope "/Subscriptions/$ResourceSubscriptionId" -RoleDefinitionName 'Owner' | Out-Null
        
        # Grant the ability to the web app to manage itself, useful for key management and the update engine.
        New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope $WebApp.id -RoleDefinitionName 'Website Contributor' | Out-Null
    } else {
        # Grant the managed identity the ability to self manage the MSM subscription.
        # This is useful for config drift identification and auto secret update for user auth and is also used for intermediaries.
        New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope "/Subscriptions/$SubscriptionId" -RoleDefinitionName 'Owner' | Out-Null
    }

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Uploading MSM Zip file' -PercentComplete 90

    # Deploy the MSM binaries
    Publish-AzWebApp -WebApp $WebApp -ArchivePath $Path -Clean -Restart -Force | Out-Null

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Completed Deployment' -PercentComplete 100
}

end {
    # Log out of the Graph API
    Disconnect-MgGraph -ErrorAction 'SilentlyContinue' | Out-Null

    # Log out of the Azure API
    Disconnect-AzAccount -ErrorAction 'SilentlyContinue' | Out-Null
}

# SIG # Begin signature block
# MIIqTgYJKoZIhvcNAQcCoIIqPzCCKjsCAQExDzANBglghkgBZQMEAgMFADCBmwYK
# KwYBBAGCNwIBBKCBjDCBiTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63
# JNLGKX7zUQIBAAIBAAIBAAIBAAIBADBRMA0GCWCGSAFlAwQCAwUABEDjIvfwlRxl
# 0dK3yyBOm83xpHL6lzGPlad2BgKPCyZqk4bx8U+ttWCChjkwl60o5/e/kviLrLqj
# GELivdzSzxrmoIIOczCCBrAwggSYoAMCAQICEAitQLJg0pxMn17Nqb2TrtkwDQYJ
# KoZIhvcNAQEMBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IElu
# YzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQg
# VHJ1c3RlZCBSb290IEc0MB4XDTIxMDQyOTAwMDAwMFoXDTM2MDQyODIzNTk1OVow
# aTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQD
# EzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4
# NCAyMDIxIENBMTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANW0L0LQ
# KK14t13VOVkbsYhC9TOM6z2Bl3DFu8SFJjCfpI5o2Fz16zQkB+FLT9N4Q/QX1x7a
# +dLVZxpSTw6hV/yImcGRzIEDPk1wJGSzjeIIfTR9TIBXEmtDmpnyxTsf8u/LR1oT
# pkyzASAl8xDTi7L7CPCK4J0JwGWn+piASTWHPVEZ6JAheEUuoZ8s4RjCGszF7pNJ
# cEIyj/vG6hzzZWiRok1MghFIUmjeEL0UV13oGBNlxX+yT4UsSKRWhDXW+S6cqgAV
# 0Tf+GgaUwnzI6hsy5srC9KejAw50pa85tqtgEuPo1rn3MeHcreQYoNjBI0dHs6EP
# bqOrbZgGgxu3amct0r1EGpIQgY+wOwnXx5syWsL/amBUi0nBk+3htFzgb+sm+YzV
# svk4EObqzpH1vtP7b5NhNFy8k0UogzYqZihfsHPOiyYlBrKD1Fz2FRlM7WLgXjPy
# 6OjsCqewAyuRsjZ5vvetCB51pmXMu+NIUPN3kRr+21CiRshhWJj1fAIWPIMorTmG
# 7NS3DVPQ+EfmdTCN7DCTdhSmW0tddGFNPxKRdt6/WMtyEClB8NXFbSZ2aBFBE1ia
# 3CYrAfSJTVnbeM+BSj5AR1/JgVBzhRAjIVlgimRUwcwhGug4GXxmHM14OEUwmU//
# Y09Mu6oNCFNBfFg9R7P6tuyMMgkCzGw8DFYRAgMBAAGjggFZMIIBVTASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRoN+Drtjv4XxGG+/5hewiIZfROQjAfBgNV
# HSMEGDAWgBTs1+OC0nFdZEzfLmc/57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwdwYIKwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhho
# dHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNl
# cnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1Ud
# HwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRy
# dXN0ZWRSb290RzQuY3JsMBwGA1UdIAQVMBMwBwYFZ4EMAQMwCAYGZ4EMAQQBMA0G
# CSqGSIb3DQEBDAUAA4ICAQA6I0Q9jQh27o+8OpnTVuACGqX4SDTzLLbmdGb3lHKx
# AMqvbDAnExKekESfS/2eo3wm1Te8Ol1IbZXVP0n0J7sWgUVQ/Zy9toXgdn43ccsi
# 91qqkM/1k2rj6yDR1VB5iJqKisG2vaFIGH7c2IAaERkYzWGZgVb2yeN258TkG19D
# +D6U/3Y5PZ7Umc9K3SjrXyahlVhI1Rr+1yc//ZDRdobdHLBgXPMNqO7giaG9OeE4
# Ttpuuzad++UhU1rDyulq8aI+20O4M8hPOBSSmfXdzlRt2V0CFB9AM3wD4pWywiF1
# c1LLRtjENByipUuNzW92NyyFPxrOJukYvpAHsEN/lYgggnDwzMrv/Sk1XB+JOFX3
# N4qLCaHLC+kxGv8uGVw5ceG+nKcKBtYmZ7eS5k5f3nqsSc8upHSSrds8pJyGH+PB
# VhsrI/+PteqIe3Br5qC6/To/RabE6BaRUotBwEiES5ZNq0RA443wFSjO7fEYVgcq
# LxDEDAhkPDOPriiMPMuPiAsNvzv0zh57ju+168u38HcT5ucoP6wSrqUvImxB+YJc
# FWbMbA7KxYbD9iYzDAdLoNMHAmpqQDBISzSoUSC7rRuFCOJZDW3KBVAr6kocnqX9
# oKcfBnTn8tZSkP2vhUgh+Vc7tJwD7YZF9LRhbr9o4iZghurIr6n+lB3nYxs6hlZ4
# TjCCB7swggWjoAMCAQICEA9r/fqrnEUh1rTBfPHOuTEwDQYJKoZIhvcNAQELBQAw
# aTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQD
# EzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4
# NCAyMDIxIENBMTAeFw0yMzAyMDMwMDAwMDBaFw0yNDAyMDIyMzU5NTlaMIHAMRMw
# EQYLKwYBBAGCNzwCAQMTAlVTMRkwFwYLKwYBBAGCNzwCAQITCERlbGF3YXJlMR0w
# GwYDVQQPDBRQcml2YXRlIE9yZ2FuaXphdGlvbjEQMA4GA1UEBRMHNjk4MzQzODEL
# MAkGA1UEBhMCVVMxETAPBgNVBAgTCERlbGF3YXJlMRMwEQYDVQQHEwpXaWxtaW5n
# dG9uMRMwEQYDVQQKEwpNb290LCBJbmMuMRMwEQYDVQQDEwpNb290LCBJbmMuMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA1TvZ5sSZjgzkrKn+tsNMObNO
# 4kVpQWznhqZGVisiNW41L3PizjXYHTdhm6xMJ+ovq0tdqgCkYnSVIBgx7WP8WXpm
# 5EyQXaessWO2XoLzXw7haAGkmuC7K6VMJGe/r7EC1WfTkaBkAbd/6zIjWLgQB2pD
# iAxHXvHVPCIkHgjjbRnayKN4E8eC2La9KlVEzCkpxtYkCh7gqZwfHB1YkUxe7P2J
# smBroDh0eUNbd4PaNJGaq0N/pH2GVyBi/L2kLszZEgXGfMCKTDuLYnWtW3SMAwvq
# dejL1ER4+zsQMk87JjTTY1w8F+rfdXK9l+E92sd6rw7deq1xiPYn1DqN+Wce+ned
# vSNoGVo8sJJfVRcyZLBAc+TeCG7Horv9Cdl3TpyDSdyfB42Klq9JoPVBMO3/GWAx
# HvbNSDwT+plghL6Y6rIcoM7XvtRZGkA0p/CNww2KCLKWzeLUaYyaoQZnlgXoVFLo
# +0qoWHfvE/VwqwJl4WnHdYIVRu3FwzjscmbCn8ch6dADW8zlpVeWVRBdKl8ekmS4
# t0VkULFI1A9E3PRMEto4494/hMPPBtPLJOsZ07R+cZYlUsuaISU58P/1vLsBfyDX
# mtWAdo3AAZpI1W243xLdzz6fBWF+TKrwsDhoyn8SOaKeYvYyCCvXMIGvAd12zgzz
# xBWVxnT3fsZndkp9eNUCAwEAAaOCAgUwggIBMB8GA1UdIwQYMBaAFGg34Ou2O/hf
# EYb7/mF7CIhl9E5CMB0GA1UdDgQWBBSxNBTvZpacTdDwlTX2QrEdgW5A1jAOBgNV
# HQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwgbUGA1UdHwSBrTCBqjBT
# oFGgT4ZNaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0
# Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmwwU6BRoE+GTWh0dHA6
# Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVTaWduaW5n
# UlNBNDA5NlNIQTM4NDIwMjFDQTEuY3JsMD0GA1UdIAQ2MDQwMgYFZ4EMAQMwKTAn
# BggrBgEFBQcCARYbaHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMIGUBggrBgEF
# BQcBAQSBhzCBhDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
# MFwGCCsGAQUFBzAChlBodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNydDAM
# BgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4ICAQBIhL2SpiFGWpJDLVmGxc2s
# Bg05isDdU02M51n53WWL9/mabXDHoYu3BxvjMIJoMJkL5e82CTcofDcO53glVBc9
# SGumW+RndzD7nS9VaKfY8mkvvkdyKyqgH3JKj+SY+wGQIIeLdR72Y8NDgZg8OSAc
# kZ9De+NJ/fEZ6IYDnKqgiGcEeGfqtub/Kh7M68asrfTz9NQ9ij73dXtxM21tuz69
# J6lc/VyshH7x+ca+nXsubt5EOfJVa/Icx6D5BqSzkO+3HBHhWJjV4tNgV52iSPap
# KjamkDZ7D6FSUvT63wqrP3RfZ8/8ZGGveVQc2QCO19meWYTv63SZBscK/WusGRbG
# XbNxp7VWAh/LjSKAjAen/rr9mZKsII3mPDy1ghToPiUIeH3W7GHwt6J96U+BmYzL
# dnQDlV2ceVlwwGHcO0R6uWzWs2yfIj2VP6WqUoEPt5RY9TfHioAvW50jxYitUMFx
# UZOHPMSgF6Qn0VnPkX/mnp+rqJgOYqFfWxywM3rqSEECL+Ik4Xyk264m8UU/4cyE
# f0Gymsv96CjUAt15+waFCP2AnQvvPAyu1i73v6KQBNIFBgTtTpl529TRjV3YmM7c
# jtEE0rl/95AUas+n5PE8MsJoKb8AlfKpXpT92BuNETtlCmsC4CRYqTzRm63xPTLK
# Xja8ZynISJ/gTi3kZy32/jGCGw4wghsKAgEBMH0waTELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVk
# IEc0IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMQIQD2v9+quc
# RSHWtMF88c65MTANBglghkgBZQMEAgMFAKCB3DAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTBPBgkqhkiG9w0B
# CQQxQgRAmMo56s+UQFuTBDL6Zzm/MJPQvIt3DH+VzbUkD/Hq990r7VfqukWDqTnI
# Xo0C7VlQ2quwGgLhKcARyuSdYZEM9DBQBgorBgEEAYI3AgEMMUIwQKA+gDwATQBT
# AE0AIAAtACAASQBuAGYAcgBhAHMAdAByAHUAYwB0AHUAcgBlACAASQBuAHMAdABh
# AGwAbABlAHIwDQYJKoZIhvcNAQEBBQAEggIAnlxmhJMNgHJDpALyiqan4jTU5TZy
# lRBXkwkibu516zQYy7j/rGIoVrNZOqt++WXCsi4p+vyZ9IUll9GCNT3t6/dwh3I0
# 8C4+O2pjRSuQl+kYobSB7tK7MzRScFbecxMWjW32X1aRmTqVTxSffAzDCYeUbbMW
# NP5Op7L1hKZ5WmT5xuHMnsgbWgd4ZhoKTuOxQBpMWMgJ3NFGxTrxISrGZjSE7uQn
# uaxozR4Ot83E3CrXckaWv00qLOWBTyF1SqRZjUt1+bP430yOE3JSg0UPjQSDNF8g
# brG2oVzARDV/dXwl7j6HTDfAzCjG12rDfB1p4pZt2Jf2eennwJiz13HwKKbrypEl
# I0+9RNuTsFZSD3UkAIZ5OMThKO+YYegkDkRqyGGAw5CdJBF1IKr2vj70I2odxBJ2
# 4ELSUXskjcv4PgoG5XHgEp6zTRA4Nq1ULpXx1JAMb/uGYzybmgHM7kDUcYst7vXt
# yt0nleIK+YG2ZDUOuRpb0zGw8qcWqw7UKOCy+O81N7hCw1u2mqM5LQqR33wmouqW
# +6ZmORmQi+pzggB/xhzKzYJPLp/s7NKgZsLfVDPw9MU5P1VO0di25OEvWzXbQ0+B
# 38KzNCXHYTcgOHw85mc9+EAod6XReTmQ9GHxjFgcPPyl8JX9eY5U9Zoz0rum8UB8
# sGEZwQi3FTD16bGhgheDMIIXfwYKKwYBBAGCNwMDATGCF28wghdrBgkqhkiG9w0B
# BwKgghdcMIIXWAIBAzEPMA0GCWCGSAFlAwQCAwUAMIGaBgsqhkiG9w0BCRABBKCB
# igSBhzCBhAIBAQYJYIZIAYb9bAcBMFEwDQYJYIZIAWUDBAIDBQAEQD6QrC4oAwPe
# B8fUeM0GownReOQ6/8Yt+tN1mYffHzMHfkQoWh20/Mex/DC/zNmJAGp4K7B9hY3M
# 20olSegTvfsCEDxONyWvY8hudfWp3R6CF/8YDzIwMjMxMDA2MTY1NjM2WqCCEwkw
# ggbCMIIEqqADAgECAhAFRK/zlJ0IOaa/2z9f5WEWMA0GCSqGSIb3DQEBCwUAMGMx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMy
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcg
# Q0EwHhcNMjMwNzE0MDAwMDAwWhcNMzQxMDEzMjM1OTU5WjBIMQswCQYDVQQGEwJV
# UzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xIDAeBgNVBAMTF0RpZ2lDZXJ0IFRp
# bWVzdGFtcCAyMDIzMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAo1NF
# hx2DjlusPlSzI+DPn9fl0uddoQ4J3C9Io5d6OyqcZ9xiFVjBqZMRp82qsmrdECmK
# HmJjadNYnDVxvzqX65RQjxwg6seaOy+WZuNp52n+W8PWKyAcwZeUtKVQgfLPywem
# MGjKg0La/H8JJJSkghraarrYO8pd3hkYhftF6g1hbJ3+cV7EBpo88MUueQ8bZlLj
# yNY+X9pD04T10Mf2SC1eRXWWdf7dEKEbg8G45lKVtUfXeCk5a+B4WZfjRCtK1ZXO
# 7wgX6oJkTf8j48qG7rSkIWRw69XloNpjsy7pBe6q9iT1HbybHLK3X9/w7nZ9MZll
# R1WdSiQvrCuXvp/k/XtzPjLuUjT71Lvr1KAsNJvj3m5kGQc3AZEPHLVRzapMZoOI
# aGK7vEEbeBlt5NkP4FhB+9ixLOFRr7StFQYU6mIIE9NpHnxkTZ0P387RXoyqq1AV
# ybPKvNfEO2hEo6U7Qv1zfe7dCv95NBB+plwKWEwAPoVpdceDZNZ1zY8SdlalJPrX
# xGshuugfNJgvOuprAbD3+yqG7HtSOKmYCaFxsmxxrz64b5bV4RAT/mFHCoz+8LbH
# 1cfebCTwv0KCyqBxPZySkwS0aXAnDU+3tTbRyV8IpHCj7ArxES5k4MsiK8rxKBMh
# SVF+BmbTO77665E42FEHypS34lCh8zrTioPLQHsCAwEAAaOCAYswggGHMA4GA1Ud
# DwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6
# FtltTYUvcyl2mi91jGogj57IbzAdBgNVHQ4EFgQUpbbvE+fvzdBkodVWqWUxo97V
# 40kwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0Rp
# Z2lDZXJ0VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNybDCB
# kAYIKwYBBQUHAQEEgYMwgYAwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2lj
# ZXJ0LmNvbTBYBggrBgEFBQcwAoZMaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29t
# L0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNy
# dDANBgkqhkiG9w0BAQsFAAOCAgEAgRrW3qCptZgXvHCNT4o8aJzYJf/LLOTN6l0i
# kuyMIgKpuM+AqNnn48XtJoKKcS8Y3U623mzX4WCcK+3tPUiOuGu6fF29wmE3aEl3
# o+uQqhLXJ4Xzjh6S2sJAOJ9dyKAuJXglnSoFeoQpmLZXeY/bJlYrsPOnvTcM2Jh2
# T1a5UsK2nTipgedtQVyMadG5K8TGe8+c+njikxp2oml101DkRBK+IA2eqUTQ+OVJ
# dwhaIcW0z5iVGlS6ubzBaRm6zxbygzc0brBBJt3eWpdPM43UjXd9dUWhpVgmagNF
# 3tlQtVCMr1a9TMXhRsUo063nQwBw3syYnhmJA+rUkTfvTVLzyWAhxFZH7doRS4wy
# w4jmWOK22z75X7BC1o/jF5HRqsBV44a/rCcsQdCaM0qoNtS5cpZ+l3k4SF/Kwtw9
# Mt911jZnWon49qfH5U81PAC9vpwqbHkB3NpE5jreODsHXjlY9HxzMVWggBHLFAx+
# rrz+pOt5Zapo1iLKO+uagjVXKBbLafIymrLS2Dq4sUaGa7oX/cR3bBVsrquvczro
# SUa31X/MtjjA2Owc9bahuEMs305MfR5ocMB3CtQC4Fxguyj/OOVSWtasFyIjTvTs
# 0xf7UGv/B3cfcZdEQcm4RtNsMnxYL2dHZeUbc7aZ+WssBkbvQR7w8F/g29mtkIBE
# r4AQQYowggauMIIElqADAgECAhAHNje3JFR82Ees/ShmKl5bMA0GCSqGSIb3DQEB
# CwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQg
# Um9vdCBHNDAeFw0yMjAzMjMwMDAwMDBaFw0zNzAzMjIyMzU5NTlaMGMxCzAJBgNV
# BAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNl
# cnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDGhjUGSbPBPXJJUVXHJQPE8pE3
# qZdRodbSg9GeTKJtoLDMg/la9hGhRBVCX6SI82j6ffOciQt/nR+eDzMfUBMLJnOW
# bfhXqAJ9/UO0hNoR8XOxs+4rgISKIhjf69o9xBd/qxkrPkLcZ47qUT3w1lbU5ygt
# 69OxtXXnHwZljZQp09nsad/ZkIdGAHvbREGJ3HxqV3rwN3mfXazL6IRktFLydkf3
# YYMZ3V+0VAshaG43IbtArF+y3kp9zvU5EmfvDqVjbOSmxR3NNg1c1eYbqMFkdECn
# wHLFuk4fsbVYTXn+149zk6wsOeKlSNbwsDETqVcplicu9Yemj052FVUmcJgmf6Aa
# RyBD40NjgHt1biclkJg6OBGz9vae5jtb7IHeIhTZgirHkr+g3uM+onP65x9abJTy
# UpURK1h0QCirc0PO30qhHGs4xSnzyqqWc0Jon7ZGs506o9UD4L/wojzKQtwYSH8U
# NM/STKvvmz3+DrhkKvp1KCRB7UK/BZxmSVJQ9FHzNklNiyDSLFc1eSuo80VgvCON
# WPfcYd6T/jnA+bIwpUzX6ZhKWD7TA4j+s4/TXkt2ElGTyYwMO1uKIqjBJgj5FBAS
# A31fI7tk42PgpuE+9sJ0sj8eCXbsq11GdeJgo1gJASgADoRU7s7pXcheMBK9Rp61
# 03a50g5rmQzSM7TNsQIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB/wIBADAd
# BgNVHQ4EFgQUuhbZbU2FL3MpdpovdYxqII+eyG8wHwYDVR0jBBgwFoAU7NfjgtJx
# XWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUF
# BwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGln
# aWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJo
# dHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNy
# bDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZIhvcNAQEL
# BQADggIBAH1ZjsCTtm+YqUQiAX5m1tghQuGwGC4QTRPPMFPOvxj7x1Bd4ksp+3CK
# Daopafxpwc8dB+k+YMjYC+VcW9dth/qEICU0MWfNthKWb8RQTGIdDAiCqBa9qVbP
# FXONASIlzpVpP0d3+3J0FNf/q0+KLHqrhc1DX+1gtqpPkWaeLJ7giqzl/Yy8ZCaH
# bJK9nXzQcAp876i8dU+6WvepELJd6f8oVInw1YpxdmXazPByoyP6wCeCRK6ZJxur
# JB4mwbfeKuv2nrF5mYGjVoarCkXJ38SNoOeY+/umnXKvxMfBwWpx2cYTgAnEtp/N
# h4cku0+jSbl3ZpHxcpzpSwJSpzd+k1OsOx0ISQ+UzTl63f8lY5knLD0/a6fxZsNB
# zU+2QJshIUDQtxMkzdwdeDrknq3lNHGS1yZr5Dhzq6YBT70/O3itTK37xJV77Qpf
# MzmHQXh6OOmc4d0j/R0o08f56PGYX/sr2H7yRp11LB4nLCbbbxV7HhmLNriT1Oby
# F5lZynDwN7+YAN8gFk8n+2BnFqFmut1VwDophrCYoCvtlUG3OtUVmDG0YgkPCr2B
# 2RP+v6TR81fZvAT6gt4y3wSJ8ADNXcL50CN/AAvkdgIm2fBldkKmKYcJRyvmfxqk
# hQ/8mJb2VVQrH4D6wPIOK+XW+6kvRBVK5xMOHds3OBqhK/bt1nz8MIIFjTCCBHWg
# AwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0BAQwFADBlMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcN
# MjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQswCQYDVQQGEwJVUzEVMBMG
# A1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEw
# HwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZwuEp
# pz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+
# n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAdYykt
# zuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3T6cw
# 2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjUN6Qu
# BX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC
# 5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK
# 3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyVw4/3
# IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEP
# lAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYiCd98
# THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmpsh3l
# GwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU7NfjgtJx
# XWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8w
# DgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0
# cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MEUGA1Ud
# HwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEB
# DAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyhhyzshV6pGrsi+IcaaVQi
# 7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO0Cre+i1Wz/n096wwepqL
# sl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo8L8vC6bp8jQ87PcDx4eo
# 0kxAGTVGamlUsLihVo7spNU96LHc/RzY9HdaXFSMb++hUD38dglohJ9vytsgjTVg
# HAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5xaiNrIv8SuFQtJ37YOtnw
# toeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMYIDljCCA5ICAQEwdzBjMQswCQYDVQQG
# EwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0
# IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBAhAFRK/z
# lJ0IOaa/2z9f5WEWMA0GCWCGSAFlAwQCAwUAoIHxMBoGCSqGSIb3DQEJAzENBgsq
# hkiG9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMjMxMDA2MTY1NjM2WjArBgsqhkiG
# 9w0BCRACDDEcMBowGDAWBBRm8CsywsLJD4JdzqqKycZPGZzPQDA3BgsqhkiG9w0B
# CRACLzEoMCYwJDAiBCDS9uRt7XQizNHUQFdoQTZvgoraVZquMxavTRqa1Ax4KDBP
# BgkqhkiG9w0BCQQxQgRAbc+vkno4WWiTEVt18aRdTTKUBWLPvyc44ocPXlb//V2K
# gUWX60S6GFpvlaeXtj9wD9E98EF5W7VaFWYCfSUuIzANBgkqhkiG9w0BAQEFAASC
# AgBbwCyHz81ISvJ4D/5mVyYtOjaA/k7/goHSg5IU6UA1bDOuMI3xtSJcwcnLzCCY
# c8SA0Slot23k3SxQ6bEzJ8toNxWBk3ylfXUDa928aiQZV2xxm3FYUqRPDvXNo886
# JGEgbSHZZb1zDzYeYb4O86ufRFJ/+Gw+Y59qjVrpmmcgUH6L9sbGZ9/XZhbUqUX+
# T8b3QscF+/ICTiDuia1/iJ6ckTzfyBSjf5rLLTUCGMZlsYO68SrGYYTOpACJ9ur1
# znDplc44R4fRU/0HiSihX6DiSVtdS4pJksWcw1VyYziUuA3Le9Ego1JxgNutWIGY
# 8mkLhMBsriwxYBOY9frC+9cbq5+jmKq+/Sm1igGpnDCCAO2Ktavyp0UZ2Uujiosq
# A2zcVrqhV3TMfYSe+B9ab/p6jlEYwUTwDH4W0BWpjDltUDBel2INnaYEAcpNffnQ
# 5gyJsmoBIda1Z2cG2fN9P++/wTjdlcFYfQFBFNOJ7IyAxP2Cb7mExwygxL/QIxxn
# ySkMmItA5/IVecRbBcongaOj96fXez4XeMOwdeRtLrLV9cmd53sZoDoflZdQ4x8c
# 3Gaix1Lzy6asg4OYo5yi7xXRZggb2UElQQU+pddLzZoQaR0D/KgpLxsBW4M2UaFP
# LrlUX8fvgZxFVosFKbz9tXEsotybHOCs63qmw8EFk1HvSw==
# SIG # End signature block
