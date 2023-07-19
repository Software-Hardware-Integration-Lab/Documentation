<#
.SYNOPSIS
    Deploys the Moot Security Management web app to an Azure App Service.
.DESCRIPTION
    Creates a resource group in the specified subscription and deploys a web app to it.
    In Azure AD, an app registration is created to facilitate user login.
    Configures all the required permissions for operation.
.PARAMETER SubscriptionId
    The ID of the subscription to create an Az Web App for MSM to be hosted in.
.PARAMETER ResourceGroupName
    Name of the resource group to create for the MSM app.
.PARAMETER Location
    Azure Region to create all of the resources in.
.PARAMETER AppRegistrationName
    Name prefix of the app registration to create in Azure AD.
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

#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Applications"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Az"; RequiredVersion="10.1.0" }

# Enable cmdlet binding for advanced functionality
[CmdletBinding(SupportsShouldProcess)]

# Define the parameter input to make this app customizable
param(
    [Parameter(Mandatory)]
    [System.Guid]$SubscriptionId,
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
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Creating User Login AAD Registration' -PercentComplete 0

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

    # Managed identity object ID
    Grant-MIGraphPermission.ps1 -CLIMode -AccessToken (ConvertTo-SecureString -AsPlainText -String $AccessToken.Token) -ObjectID $WebApp.Identity.PrincipalId -PermissionName 'Application.ReadWrite.All', 'User.ReadWrite.All', 'Group.ReadWrite.All', 'AdministrativeUnit.ReadWrite.All', 'Device.ReadWrite.All', 'DeviceManagementManagedDevices.Read.All', 'DeviceManagementConfiguration.ReadWrite.All', 'DeviceManagementApps.ReadWrite.All', 'DeviceManagementServiceConfig.ReadWrite.All', 'DeviceManagementManagedDevices.PrivilegedOperations.All', 'DeviceManagementRBAC.ReadWrite.All', 'RoleManagement.ReadWrite.Directory', 'Policy.Read.All', 'Policy.ReadWrite.ConditionalAccess' | Out-Null

    # Display progress bar
    Write-Progress -Activity 'Deploying MSM to Az Web App' -Status 'Granting Web App Azure RBAC self configuring permissions' -PercentComplete 80

    # Grant the managed identity the ability to self manage the MSM web app. This is useful for config drift identification and auto secret update for user auth
    New-AzRoleAssignment -ObjectId $WebApp.Identity.PrincipalId -Scope $WebApp.id -RoleDefinitionName 'Website Contributor' | Out-Null

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
# MIIqQwYJKoZIhvcNAQcCoIIqNDCCKjACAQExDzANBglghkgBZQMEAgMFADCBmwYK
# KwYBBAGCNwIBBKCBjDCBiTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63
# JNLGKX7zUQIBAAIBAAIBAAIBAAIBADBRMA0GCWCGSAFlAwQCAwUABEDuFvlV4WA+
# ZyivxRaii1pQO1Z2RtzrBovv4BrjeRUx9oazCM777hub9V4SEWh3qZwFGzeCahrX
# 5tZGhaG6racZoIIOczCCBrAwggSYoAMCAQICEAitQLJg0pxMn17Nqb2TrtkwDQYJ
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
# Xja8ZynISJ/gTi3kZy32/jGCGwMwghr/AgEBMH0waTELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVk
# IEc0IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMQIQD2v9+quc
# RSHWtMF88c65MTANBglghkgBZQMEAgMFAKCB0jAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTBGBgorBgEEAYI3
# AgEMMTgwNqA0gDIATQBTAE0AIAAtACAAUwBlAHIAdgBlAHIAIABJAG4AcwB0AGEA
# bABsACAAVABvAG8AbDBPBgkqhkiG9w0BCQQxQgRANzTIQ4bx/JykoOO8F9KfzraC
# SjbkCiamGnWwEAflu8V2OTfXFTcSQbBgcR6v1BiI5OhX9lALlHTdnXYYJl3sZDAN
# BgkqhkiG9w0BAQEFAASCAgDNEB9/DXLd/kOc2OqXdowPryu+jr2tzTrKxUUe4nXf
# yanfyyVHInmW1J1zQoYvrIRAqBbk3o+dk/mPhg9fRO7QQ7FX2z7DIbjJ79XzwDP+
# xthvZrWEpViNgJjX2nT289hzE9B/+LNQMW/iWHi9OqauTaBT+z0ElWYM+oiiJBSV
# ysDggQeXRgGA+e2kA1I2dCVUCypPJ6wMCndFN72WaV84BqCaPynK0D2F4mjPtYPm
# ThHreoW0r2oqlUkmdg4r5tE0ikCBsG0B0ypVEKm0c0RnRMSp7+qpS4cnseq80jNb
# r4t8xW+qeNmtPvKUS+zd0d0BCw1PpRp/DjaS30UoBYU1HRlh/kBVgvl7mf9LvmWB
# zDKZJZhu4i+Sdxg2jz1l9ksZL8PZT4VbRBUSZRasN3/BAf8CXAz1B36cM7ybGzIx
# wIoxzizmoYcnaFj8GpDdteByWLxRj+KAtDRzl1z40Husw5iolAzJNjk6lh/Oa/pb
# 3AS6z5Pm1rIl92Wp2vmfnVrBBkxng/+WSwD+N5ajwhpxyZjpXLYbzRnHaoVUhUJQ
# rvqM/1HdI8O/gTBj9QKBzf9bSrGcPlLH1wZ64wP7zm7TSGiye0CEAqae/VY84VnF
# MR5zVgSI0fm941Db3RsU9Cp3Oo96HStT/ccDSFPPmzzK7zSmXUmE4MshE9bmlybB
# 16GCF4Iwghd+BgorBgEEAYI3AwMBMYIXbjCCF2oGCSqGSIb3DQEHAqCCF1swghdX
# AgEDMQ8wDQYJYIZIAWUDBAIDBQAwgZsGCyqGSIb3DQEJEAEEoIGLBIGIMIGFAgEB
# BglghkgBhv1sBwEwUTANBglghkgBZQMEAgMFAARAiTDKNwPTVISWQiHV7NSZy6tJ
# yv/pS4F833NtoN8YVcJ4AgkSKYJ3Jc92QDFha5Dzlb2CaVfGaq+011OKzLpevQIR
# AKd/fK2fd0l3fSMOJDqFXmgYDzIwMjMwNzE5MTk0MzI0WqCCEwcwggbAMIIEqKAD
# AgECAhAMTWlyS5T6PCpKPSkHgD1aMA0GCSqGSIb3DQEBCwUAMGMxCzAJBgNVBAYT
# AlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQg
# VHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwHhcNMjIw
# OTIxMDAwMDAwWhcNMzMxMTIxMjM1OTU5WjBGMQswCQYDVQQGEwJVUzERMA8GA1UE
# ChMIRGlnaUNlcnQxJDAiBgNVBAMTG0RpZ2lDZXJ0IFRpbWVzdGFtcCAyMDIyIC0g
# MjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAM/spSY6xqnya7uNwQ2a
# 26HoFIV0MxomrNAcVR4eNm28klUMYfSdCXc9FZYIL2tkpP0GgxbXkZI4HDEClvty
# sZc6Va8z7GGK6aYo25BjXL2JU+A6LYyHQq4mpOS7eHi5ehbhVsbAumRTuyoW51BI
# u4hpDIjG8b7gL307scpTjUCDHufLckkoHkyAHoVW54Xt8mG8qjoHffarbuVm3eJc
# 9S/tjdRNlYRo44DLannR0hCRRinrPibytIzNTLlmyLuqUDgN5YyUXRlav/V7QG5v
# FqianJVHhoV5PgxeZowaCiS+nKrSnLb3T254xCg/oxwPUAY3ugjZNaa1Htp4WB05
# 6PhMkRCWfk3h3cKtpX74LRsf7CtGGKMZ9jn39cFPcS6JAxGiS7uYv/pP5Hs27wZE
# 5FX/NurlfDHn88JSxOYWe1p+pSVz28BqmSEtY+VZ9U0vkB8nt9KrFOU4ZodRCGv7
# U0M50GT6Vs/g9ArmFG1keLuY/ZTDcyHzL8IuINeBrNPxB9ThvdldS24xlCmL5kGk
# ZZTAWOXlLimQprdhZPrZIGwYUWC6poEPCSVT8b876asHDmoHOWIZydaFfxPZjXnP
# YsXs4Xu5zGcTB5rBeO3GiMiwbjJ5xwtZg43G7vUsfHuOy2SJ8bHEuOdTXl9V0n0Z
# KVkDTvpd6kVzHIR+187i1Dp3AgMBAAGjggGLMIIBhzAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAgBgNVHSAEGTAX
# MAgGBmeBDAEEAjALBglghkgBhv1sBwEwHwYDVR0jBBgwFoAUuhbZbU2FL3Mpdpov
# dYxqII+eyG8wHQYDVR0OBBYEFGKK3tBh/I8xFO2XC809KpQU31KcMFoGA1UdHwRT
# MFEwT6BNoEuGSWh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0
# ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdDQS5jcmwwgZAGCCsGAQUFBwEB
# BIGDMIGAMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wWAYI
# KwYBBQUHMAKGTGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRy
# dXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdDQS5jcnQwDQYJKoZIhvcN
# AQELBQADggIBAFWqKhrzRvN4Vzcw/HXjT9aFI/H8+ZU5myXm93KKmMN31GT8Ffs2
# wklRLHiIY1UJRjkA/GnUypsp+6M/wMkAmxMdsJiJ3HjyzXyFzVOdr2LiYWajFCpF
# h0qYQitQ/Bu1nggwCfrkLdcJiXn5CeaIzn0buGqim8FTYAnoo7id160fHLjsmEHw
# 9g6A++T/350Qp+sAul9Kjxo6UrTqvwlJFTU2WZoPVNKyG39+XgmtdlSKdG3K0gVn
# K3br/5iyJpU4GYhEFOUKWaJr5yI+RCHSPxzAm+18SLLYkgyRTzxmlK9dAlPrnuKe
# 5NMfhgFknADC6Vp0dQ094XmIvxwBl8kZI4DXNlpflhaxYwzGRkA7zl011Fk+Q5oY
# rsPJy8P7mxNfarXH4PMFw1nfJ2Ir3kHJU7n/NBBn9iYymHv+XEKUgZSCnawKi8ZL
# FUrTmJBFYDOA4CPe+AOk9kVH5c64A0JH6EE2cXet/aLol3ROLtoeHYxayB6a1cLw
# xiKoT5u92ByaUcQvmvZfpyeXupYuhVfAYOd4Vn9q78KVmksRAsiCnMkaBXy6cbVO
# epls9Oie1FqYyJ+/jbsYXEP10Cro4mLueATbvdH7WwqocH7wl4R44wgDXUcsY6gl
# OJcB0j862uXl9uab3H4szP8XTE0AotjWAQ64i+7m4HJViSwnGWH2dwGMMIIGrjCC
# BJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzANBgkqhkiG9w0BAQsFADBiMQswCQYD
# VQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGln
# aWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwHhcN
# MjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5WjBjMQswCQYDVQQGEwJVUzEXMBUG
# A1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0ZWQg
# RzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1ySVFVxyUDxPKRN6mXUaHW0oPRnkyi
# baCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50fng8zH1ATCyZzlm34V6gCff1DtITa
# EfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW1OcoLevTsbV15x8GZY2U
# KdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12sy+iEZLRS8nZH92GDGd1ftFQLIWhu
# NyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYNXNXmG6jBZHRAp8ByxbpOH7G1WE15
# /tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCYJn+gGkcgQ+NDY4B7dW4n
# JZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucfWmyU8lKVEStYdEAoq3ND
# zt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLcGEh/FDTP0kyr75s9/g64
# ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixXNXkrqPNFYLwjjVj33GHek/45wPmy
# MKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtbiiKowSYI+RQQEgN9XyO7ZONj4Kbh
# PvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O6V3IXjASvUaetdN2udIOa5kM0jO0
# zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFLoW
# 2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/nupiu
# HA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3BggrBgEF
# BQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBB
# BggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybDMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0gBBkw
# FzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQB9WY7A
# k7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJLKftwig2qKWn8acHPHQfp
# PmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExiHQwIgqgWvalWzxVzjQEiJc6VaT9H
# d/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2MvGQmh2ySvZ180HAKfO+o
# vHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj+sAngkSumScbqyQeJsG33irr9p6x
# eZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJxLafzYeHJLtPo0m5d2aR
# 8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZJyw9P2un8WbDQc1PtkCbISFA0LcT
# JM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SVe+0KXzM5h0F4ejjpnOHd
# I/0dKNPH+ejxmF/7K9h+8kaddSweJywm228Vex4Ziza4k9Tm8heZWcpw8De/mADf
# IBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJDwq9gdkT/r+k0fNX2bwE
# +oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr5n8apIUP/JiW9lVUKx+A
# +sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8/DCCBY0wggR1oAMCAQICEA6bGI75
# 0C3n79tQ4ghAGFowDQYJKoZIhvcNAQEMBQAwZTELMAkGA1UEBhMCVVMxFTATBgNV
# BAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIG
# A1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTIyMDgwMTAwMDAw
# MFoXDTMxMTEwOTIzNTk1OVowYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lD
# ZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGln
# aUNlcnQgVHJ1c3RlZCBSb290IEc0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAv+aQc2jeu+RdSjwwIjBpM+zCpyUuySE98orYWcLhKac9WKt2ms2uexuE
# DcQwH/MbpDgW61bGl20dq7J58soR0uRf1gU8Ug9SH8aeFaV+vp+pVxZZVXKvaJNw
# wrK6dZlqczKU0RBEEC7fgvMHhOZ0O21x4i0MG+4g1ckgHWMpLc7sXk7Ik/ghYZs0
# 6wXGXuxbGrzryc/NrDRAX7F6Zu53yEioZldXn1RYjgwrt0+nMNlW7sp7XeOtyU9e
# 5TXnMcvak17cjo+A2raRmECQecN4x7axxLVqGDgDEI3Y1DekLgV9iPWCPhCRcKtV
# gkEy19sEcypukQF8IUzUvK4bA3VdeGbZOjFEmjNAvwjXWkmkwuapoGfdpCe8oU85
# tRFYF/ckXEaPZPfBaYh2mHY9WV1CdoeJl2l6SPDgohIbZpp0yt5LHucOY67m1O+S
# kjqePdwA5EUlibaaRBkrfsCUtNJhbesz2cXfSwQAzH0clcOP9yGyshG3u3/y1Yxw
# LEFgqrFjGESVGnZifvaAsPvoZKYz0YkH4b235kOkGLimdwHhD5QMIR2yVCkliWzl
# DlJRR3S+Jqy2QXXeeqxfjT/JvNNBERJb5RBQ6zHFynIWIgnffEx1P2PsIV/EIFFr
# b7GrhotPwtZFX50g/KEexcCPorF+CiaZ9eRpL5gdLfXZqbId5RsCAwEAAaOCATow
# ggE2MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFOzX44LScV1kTN8uZz/nupiu
# HA9PMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA4GA1UdDwEB/wQE
# AwIBhjB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRp
# Z2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDBFBgNVHR8EPjA8MDqgOKA2
# hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290
# Q0EuY3JsMBEGA1UdIAQKMAgwBgYEVR0gADANBgkqhkiG9w0BAQwFAAOCAQEAcKC/
# Q1xV5zhfoKN0Gz22Ftf3v1cHvZqsoYcs7IVeqRq7IviHGmlUIu2kiHdtvRoU9BNK
# ei8ttzjv9P+Aufih9/Jy3iS8UgPITtAq3votVs/59PesMHqai7Je1M/RQ0SbQyHr
# lnKhSLSZy51PpwYDE3cnRNTnf+hZqPC/Lwum6fI0POz3A8eHqNJMQBk1RmppVLC4
# oVaO7KTVPeix3P0c2PR3WlxUjG/voVA9/HYJaISfb8rbII01YBwCA8sgsKxYoA5A
# Y8WYIsGyWfVVa88nq2x2zm8jLfR+cWojayL/ErhULSd+2DrZ8LaHlv1b0VysGMNN
# n3O3AamfV6peKOK5lDGCA5YwggOSAgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNV
# BAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0
# IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQQIQDE1pckuU+jwqSj0pB4A9
# WjANBglghkgBZQMEAgMFAKCB8TAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQw
# HAYJKoZIhvcNAQkFMQ8XDTIzMDcxOTE5NDMyNFowKwYLKoZIhvcNAQkQAgwxHDAa
# MBgwFgQU84ciTYYzgpI1qZS8vY+W6f4cfHMwNwYLKoZIhvcNAQkQAi8xKDAmMCQw
# IgQgx/ThvjIoiSCr4iY6vhrE/E/meBwtZNBMgHVXoCO1tvowTwYJKoZIhvcNAQkE
# MUIEQDVGN4DT00IKLF9FRrnZPOwJ5MmPyWqmL4ZfcJ+in4Z8ZDd9oQE54LAi570L
# GurOP44zg2WlcWq7l7L36NbINNswDQYJKoZIhvcNAQEBBQAEggIAvL5ZQJlivn8P
# tJt5UDG5+Bau4B6tDS3ThWxnGvB9etU9faaShwNZBYPbctyToorrGB6WvOsxKVil
# m5q6lV51r+4b0cHjvlJ3j7zUtm73AGvGajT258OtlFmI3blJhDG4y4+gQhWomQR/
# fbTYcqF74a4KDtYnbE7puhhPJrG4N2/+eECJD8K0exC5+CZjqX2I+WRUTMbRLyTj
# e7t38ZsZYv0MXRxtRNbL/BWXoEZOmFoiOnXnBpxZVkO82paRwAeUgMh5oah940SI
# 23/WXnAuGbVs6mr62Zrrcp0R1YF+OD+7ICjwWvqNX6CdFr9cshMpKbz4Rb45umIh
# SDpQwwfo78cHw61wJ5vF29Jm74cYVCNatipZ4NNVaBoPI4PdxqSIH1UDF2xRiGi2
# xi4HZviiNTivkhcK3OA6QinrST/kjxsDdMtGdqUMKb18PLWy9dgnQzNBGioppp1C
# LNXd7Sd5tsdVqGQ/tTDCFStRA3iqMPoMXO6bBgPBnTsmMcjUZYw/CZ8sDW0x+0gR
# 8uOwNHKd4122ao15Naj1GTUbPbANbarIKWfkYfDD4MieAb1IGjTzfC+cDQiwVdsk
# FgZy3n7+nFRq6WgxK00qKEeD4Q5l5QwI1EMINTVJMTT9OOcbmm4TdUjazj/kc6ow
# OupfqQph9Qm2kTbwNLVpr051dPrgPEE=
# SIG # End signature block
