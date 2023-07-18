<#
.SYNOPSIS
    Uninstalls the Moot Security Management Architecture.
.DESCRIPTION
    Uses name based searches to find the configurations placed by the Moot Security Management system and them removes them.
    This operates by default on ESM, SSM and PSM but can be configured to work with only specific security classes or custom ones.
.EXAMPLE
    PS> Uninstall-MsmArchitecture.ps1
    Uninstalls the deployed MSM architecture with the default settings for the parameters (no name customization).
.INPUTS
    System.String
    System.string[]
.PARAMETER Prefix
    The set of text that will appear before the objects to be deleted.
.PARAMETER Suffix
    The set of text that will appear after the objects to be deleted.
.PARAMETER SecurityClassList
    An array of names that will be appended directly after the suffix to separate similar yet different sets of policy.
.PARAMETER RootScopeTagName
    Full name of the root scope tag as it will not follow the prefix, suffix or the security class list by default.
.LINK
    https://docs.mootinc.com
.NOTES
    This script requires the same set of permissions as required by the Install-MSM.ps1 script used to deploy the Azure Web App.
    This script has only been tested with PowerShell 7.
    While theoretically compatible with PS 5, usage with PowerShell 5 has not been tested.

    The Microsoft.Graph.Beta module is required for this script to operate.
#>

#Requires -PSEdition Core
#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Groups"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Identity.DirectoryManagement"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Identity.SignIns"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement.Administration"; RequiredVersion="2.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement.Enrollment"; RequiredVersion="2.1.0" }

[CmdletBinding(SupportsShouldProcess)]

param(
    [System.String]$Prefix = 'MSM - ',
    [System.String]$Suffix = '',
    [System.String[]]$SecurityClassList = @('PSM', 'SSM', 'ESM'),
    [System.String]$RootScopeTagName = 'Moot-Security-Management'
)

begin {
    # Computed prefix for autopilot profiles
    [System.String]$AutopilotCompatiblePrefix = $Prefix -replace "[%!#)(^*+=';<>/-]", '_'

    # Number of steps for the progress bars to render
    [System.Int64]$GetStepCount = 48
    [System.Int64]$RemoveStepCount = 14

    # Current place in the child progress bar
    [System.Int64]$CurrentStep = 0
    
    # Computed suffix for autopilot profiles
    # [System.String]$AutopilotCompatibleSuffix = $Suffix -replace "[%!#)(^*+=';<>/-]", '_'
    
    # Render Main Progress Bar
    Write-Progress -Id 0 -Activity "Uninstalling MSM's Architecture" -Status 'Step 1/3 - M365 Login' -PercentComplete 0
    
    # List of permissions to log in with
    [System.String[]]$DelegatedPermissionList = @(
        'AdministrativeUnit.ReadWrite.All',
        'Application.ReadWrite.All',
        'DeviceManagementManagedDevices.Read.All',
        'DeviceManagementConfiguration.ReadWrite.All',
        'DeviceManagementServiceConfig.ReadWrite.All',
        'DeviceManagementApps.ReadWrite.All',
        'DeviceManagementManagedDevices.PrivilegedOperations.All',
        'DeviceManagementRBAC.ReadWrite.All',
        'Device.ReadWrite.All',
        'Directory.Write.Restricted',
        'Group.ReadWrite.All',
        'Policy.Read.All',
        'Policy.ReadWrite.ConditionalAccess',
        'RoleManagement.ReadWrite.Directory',
        'User.ReadWrite.All'
    )

    # Log into the Graph API
    Connect-MgGraph -ContextScope 'Process' -Scopes $DelegatedPermissionList | Out-Null
}

process {
    # Update Main Progress Bar
    Write-Progress -Id 0 -Activity "Uninstalling MSM's Architecture" -Status 'Step 2/3 - Data Retrieval' -PercentComplete 30
        
    # List of AAD CA Policies
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphConditionalAccessPolicy[]]$CaPolicyList = @()

    # Lit of AAD CA Policy Named Locations
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphNamedLocation[]]$CaNamedLocationList = @()

    # List of AAD CA Authentication Strength Policies
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphAuthenticationStrengthPolicy[]]$CaAuthStrengthPolicyList = @()

    # Render Secondary Progress Bar
    Write-Progress -Id 1 -ParentId 0 -Activity 'Getting Break Glass Group' -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)

    # List of AAD Groups
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphGroup[]]$GroupList = Get-MgBetaGroup -Filter "displayName eq '$($Prefix)Break Glass 🚨'" -All

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 1 -ParentId 0 -Activity 'Getting Admin Units' -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)

    # List of AAD Admin Units
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphAdministrativeUnit[]]$AdminUnitList = Get-MgBetaAdministrativeUnit -Filter "displayName in ('$($Prefix)Privileged Objects$Suffix', '$($Prefix)Specialized Objects$Suffix', '$($Prefix)Enterprise Objects$Suffix')" -All

    # List of Intune Settings Policy Templates
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphDeviceConfiguration[]]$IntuneSettingTemplateList = @()

    # List of Intune Settings Catalogs
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphDeviceManagementConfigurationPolicy[]]$IntuneSettingsCatalogList = @()

    # List of Intune Windows Feature Update Policy
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphWindowsFeatureUpdateProfile[]]$IntuneWindowsFeatureUpdate = @()

    # List of Intune Device Configuration Intents (Settings Catalog Templates)
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphDeviceManagementIntent[]]$IntuneDeviceConfigIntent = @()

    # List of Intune device compliance policy
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphDeviceCompliancePolicy[]]$IntuneDeviceCompliancePolicy = @()

    # List of Intune Enrollment configurations
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphDeviceEnrollmentConfiguration[]]$IntuneEnrollmentConfigList = @()

    # List of Intune Windows Autopilot Profiles
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphWindowsAutopilotDeploymentProfile[]]$IntuneAutopilotProfileList = @()

    # List of Intune Assignment Filters
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphDeviceAndAppManagementAssignmentFilter[]]$IntuneAssignmentFilterList = @()

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 1 -ParentId 0 -Activity 'Getting Root Intune Scope Tag' -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)

    # List of Intune Role Scope tags plus the root scope tag as defined by the parameter
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphRoleScopeTag[]]$IntuneRoleScopeTagList = Get-MgBetaDeviceManagementRoleScopeTag -Filter "displayName eq '$RootScopeTagName'"

    # List of Intune Quality Update configurations 
    [hashtable[]]$IntuneQualityUpdateConfigList = @()
    
    # List of Intune Driver & Firmware update configurations 
    [hashtable[]]$IntuneDriverUpdateConfigList = @()

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 1 -ParentId 0 -Activity 'Removing Admin Units' -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)    

    # Remove the admin units sooner rather than later to start unlocking the objects held in the AUs if the AUs are in restricted mode
    $AdminUnitList | ForEach-Object -Process { Remove-MgBetaAdministrativeUnit -AdministrativeUnitId $_.Id }

    # Loop through each security class 
    foreach ($SecurityClass in $SecurityClassList) {
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Conditional Access Policies" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)    

        # Get a list of conditional access policies for the current security class
        $CaPolicyList += Get-MgBetaIdentityConditionalAccessPolicy -Filter "contains(displayName, '$Prefix$SecurityClass')" -All

        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Conditional Access Named Locations" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)            

        # Get a list of conditional access policy named locations
        $CaNamedLocationList += Get-MgBetaIdentityConditionalAccessNamedLocation -Filter "startsWith(displayName, '$Prefix$SecurityClass')" -All
                
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Conditional Access Auth Strength Policies" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)            
        
        # Get a list of conditional access policy authentication strengths
        $CaAuthStrengthPolicyList += Get-MgBetaIdentityConditionalAccessAuthenticationStrengthPolicy -Filter "startsWith(displayName, '$Prefix$SecurityClass')" -All

        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Device Settings Templates" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)            
        
        # Retrieve a list of Intune settings templates for the current security class
        $IntuneSettingTemplateList += Get-MgBetaDeviceManagementDeviceConfiguration -Filter "startsWith(displayName, '$Prefix$SecurityClass')" -All
        
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Device Settings Catalogs" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)

        # Retrieve a list of Intune settings catalogs for the current security class
        $IntuneSettingsCatalogList += Get-MgBetaDeviceManagementConfigurationPolicy -Filter "startsWith(Name, '$Prefix$SecurityClass')" -All
        
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Windows Feature Update Configurations" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)                            

        # Retrieve a list of Windows feature update configurations from Intune
        $IntuneWindowsFeatureUpdate += Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -All | Where-Object -FilterScript { $_.DisplayName -like "$Prefix$SecurityClass*" }
        
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Settings Catalog Templates" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)

        # Retrieve a list of settings catalog templates
        $IntuneDeviceConfigIntent += Get-MgBetaDeviceManagementIntent -Filter "startsWith(displayName, '$Prefix$SecurityClass')" -All

        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Device Compliance Policies" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)        

        # Retrieve a list of all Intune device compliance policies
        $IntuneDeviceCompliancePolicy += Get-MgBetaDeviceManagementDeviceCompliancePolicy -All | Where-Object -FilterScript { $_.DisplayName -like "$Prefix$SecurityClass*" }
        
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Device Enrollment Configurations" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)                

        # Retrieve a list of enrollment configurations from Intune
        $IntuneEnrollmentConfigList += Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Filter "startsWith(displayName, '$Prefix$SecurityClass')" -All

        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Autopilot Profiles" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)        

        # Retrieves a list of autopilot profiles from Intune
        $IntuneAutopilotProfileList += Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -Filter "startsWith(displayName, '$AutopilotCompatiblePrefix$SecurityClass')" -ExpandProperty 'Assignments' -All

        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Filters" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)        

        # Retrieves a list of filters from Intune
        $IntuneAssignmentFilterList += Get-MgBetaDeviceManagementAssignmentFilter -All | Where-Object -FilterScript { $_.DisplayName -like "$Prefix$SecurityClass*" }

        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Scope Tags" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)        

        # Retrieves a list of role scope tags from Intune
        $IntuneRoleScopeTagList += Get-MgBetaDeviceManagementRoleScopeTag -Filter "startsWith(displayName, '$Prefix$SecurityClass')" -All

        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Quality Update Policies" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)        

        # Retrieves a list of Quality Update profiles
        $IntuneQualityUpdateConfigList += (Invoke-MgGraphRequest -Method 'Get' -Uri 'https://graph.microsoft.com/beta/deviceManagement/windowsQualityUpdateProfiles').Value | Where-Object -FilterScript { $_.displayName -like "$Prefix$SecurityClass*" }
        
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Intune Driver & Firmware Policies" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)        

        # Retrieves a list of driver & firmware update profiles
        $IntuneDriverUpdateConfigList += (Invoke-MgGraphRequest -Method 'Get' -Uri 'https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles').Value | Where-Object -FilterScript { $_.displayName -like "$Prefix$SecurityClass*" }
        
        # Increment the current step to make the child progress bar move up
        $CurrentStep++

        # Render Secondary Progress Bar
        Write-Progress -Id 1 -ParentId 0 -Activity "$($SecurityClass): Getting Remaining Security Groups" -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)        

        # Get a list of security groups for the current security class
        $GroupList += Get-MgBetaGroup -Filter "startsWith(displayName, '$Prefix$SecurityClass')" -All
    }

    # Reset the current step of the child progress bar
    $CurrentStep = 0

    # Shut off retrieval progress bar
    Write-Progress -Id 1 -Activity 'Done Retrieving Objects' -Completed

    # Update Main Progress Bar
    Write-Progress -Id 0 -Activity "Uninstalling MSM's Architecture" -Status 'Step 3/3 - Configuration Removal' -PercentComplete 60

    # Enable and Render Secondary Progress Bar for removal
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Conditional Access Policies' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100) 

    # Remove MSM configurations where the lists are iterated over each on their own loop.
    if ($PSCmdlet.ShouldProcess('Conditional Access Policy List', 'Remove')) {
        $CaPolicyList | ForEach-Object -Process { Remove-MgBetaIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $_.Id }
    }

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Conditional Access Named Locations' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100) 

    $CaNamedLocationList | ForEach-Object -Process { Remove-MgBetaIdentityConditionalAccessNamedLocation -NamedLocationId $_.Id }
    
    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Conditional Access Auth Strength Policies' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100) 
    
    $CaAuthStrengthPolicyList | ForEach-Object -Process { Remove-MgBetaIdentityConditionalAccessAuthenticationStrengthPolicy -AuthenticationStrengthPolicyId $_.Id }

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Device Settings Templates' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)    

    $IntuneSettingTemplateList | ForEach-Object -Process { Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $_.Id }
   
    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Device Settings Catalogs' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)        

    $IntuneSettingsCatalogList | ForEach-Object -Process { Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $_.Id }

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Windows Feature Update Configurations' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)            

    $IntuneWindowsFeatureUpdate | ForEach-Object -Process { Remove-MgBetaDeviceManagementWindowsFeatureUpdateProfile -WindowsFeatureUpdateProfileId $_.Id }

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Settings Catalog Templates' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)            

    $IntuneDeviceConfigIntent | ForEach-Object -Process { Remove-MgBetaDeviceManagementIntent -DeviceManagementIntentId $_.Id }

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Settings Catalog Templates' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                

    $IntuneDeviceCompliancePolicy | ForEach-Object -Process { Remove-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $_.Id }
    
    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Device Enrollment Configurations' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                
    
    $IntuneEnrollmentConfigList | ForEach-Object -Process { Remove-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $_.Id }
    
    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Autopilot Profiles' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                

    foreach ($AutopilotProfile in $IntuneAutopilotProfileList) {
        # Remove the assignments before removing the autopilot profile
        $AutopilotProfile.Assignments.Id | ForEach-Object -Process { Remove-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment -WindowsAutopilotDeploymentProfileId $AutopilotProfile.Id -WindowsAutopilotDeploymentProfileAssignmentId $_ }
        
        # Remove the Autopilot profile since it has been un-assigned
        Remove-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -WindowsAutopilotDeploymentProfileId $AutopilotProfile.Id
    }

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Filter' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                
    
    $IntuneAssignmentFilterList | ForEach-Object -Process { Remove-MgBetaDeviceManagementAssignmentFilter -DeviceAndAppManagementAssignmentFilterId $_.Id }
    
    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Scope Tag' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                
    
    $IntuneRoleScopeTagList | ForEach-Object -Process { Remove-MgBetaDeviceManagementRoleScopeTag -RoleScopeTagId $_.Id }

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Quality Update Policies' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                
    
    $IntuneQualityUpdateConfigList | ForEach-Object -Process { Invoke-MgGraphRequest -Method 'DELETE' -Uri "https://graph.microsoft.com/beta/deviceManagement/windowsQualityUpdateProfiles/$($_.Id)" }
    
    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Intune Driver & Firmware Policies' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                    

    $IntuneDriverUpdateConfigList | ForEach-Object -Process { Invoke-MgGraphRequest -Method 'DELETE' -Uri "https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles/$($_.Id)" }
    
    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Remaining Security Groups' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)                
    
    $GroupList | ForEach-Object -Process { Remove-MgBetaGroup -GroupId $_.Id }

    # Disable progress bars
    Write-Progress -Id 2 -Activity 'Done' -Completed
    Write-Progress -Id 0 -Activity 'Done' -Completed
}

end {
    # Log out of the Graph API
    Disconnect-MgGraph | Out-Null

    # Clear the console before rendering the completion message.
    Clear-Host

    # Notify the end user that the process has completed.
    Write-Host -Object 'Successfully uninstalled MSM architecture!'
}

# SIG # Begin signature block
# MIIqUwYJKoZIhvcNAQcCoIIqRDCCKkACAQExDzANBglghkgBZQMEAgMFADCBmwYK
# KwYBBAGCNwIBBKCBjDCBiTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63
# JNLGKX7zUQIBAAIBAAIBAAIBAAIBADBRMA0GCWCGSAFlAwQCAwUABEBP5IX97fap
# m1USSmdzY5dRggECEtoRm237rIW89HgI+ZCYciukNd5SEO3JjaLcS6kh1XR4aHaE
# qkCP9ZD4l1N/oIIOczCCBrAwggSYoAMCAQICEAitQLJg0pxMn17Nqb2TrtkwDQYJ
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
# Xja8ZynISJ/gTi3kZy32/jGCGxMwghsPAgEBMH0waTELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVk
# IEc0IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMQIQD2v9+quc
# RSHWtMF88c65MTANBglghkgBZQMEAgMFAKCB4jAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTBPBgkqhkiG9w0B
# CQQxQgRASBSsyo64L6ZVeh0esYfcs9jIkR+6oslGWN+zeZotz0wrBjKoKTrlsaBx
# Y73iOF+JrE2x6h2j8BhaWaKGGxc8fDBWBgorBgEEAYI3AgEMMUgwRqBEgEIATQBT
# AE0AIAAtACAAQQByAGMAaABpAHQAZQBjAHQAdQByAGUAIABVAG4AaQBuAHMAdABh
# AGwAbAAgAFQAbwBvAGwwDQYJKoZIhvcNAQEBBQAEggIA0ZM+NNMRiKaUmB1p5LYy
# 58bNx6GsYN2DBJe7jiYC1rhX9d9P2H3COzQPAtCQ3R1G02sqUrD9yj7cMZEfIx1A
# r0bTK4KCZjII69AmJzR6PPCAMjQOeHsbsKLW7UD0IxKTe6wXDSzUaHnPc8vAW9qr
# fMw9rylAAuI6faoqp7cufdsrN4F2UxMrz9A8DL7p5jST63WwEVYJ4F3EHV3CBVOb
# 1CpqWoup2uNsDyzAH6jJQsAX1uU8TelMAE3bdr8tbc+0jU86hWmlh7SGVgCE6qPE
# q4CEwY4UCcjYPaxlvPX1oi3+UYa/5D1/8vEWd60AwcT3g9A1Qzo0qmG1I0snxuzb
# bmUulBcGsQl7lqSe7wmB/AZgnuM1ez/r0ME3R1wgNbmck7OHRKfAdGCjfRVfzgZ+
# zoNUzmkNx9w0TvmCsTymzGO8c1WwciW2gXCUUQw7ZXDDdTi3h68t6Q7mkaUUQH1O
# HrchPkpN/6j9Ae1PNc+9F28arDSlV1PLowAZfndEdlumoGit2P2tB2oN7D7EnHaA
# yi6fb7Ln2y5feQ6mJ9kd4ilLZ4K48B584/VHXmAKyKlWh5zESbfLSeXmALfsTDEb
# aesxOO3pp4hopPGAcfoebBEcpOcCvPoHiLX5UpO027uEwdkkeQ8MLZnY7VWRxFeI
# sxacmdYeneZ6kD2qfxQLn2KhgheCMIIXfgYKKwYBBAGCNwMDATGCF24wghdqBgkq
# hkiG9w0BBwKgghdbMIIXVwIBAzEPMA0GCWCGSAFlAwQCAwUAMIGbBgsqhkiG9w0B
# CRABBKCBiwSBiDCBhQIBAQYJYIZIAYb9bAcBMFEwDQYJYIZIAWUDBAIDBQAEQOKr
# eYHB0Vo2iYEZSNwHcWbXTNu4RAbQa9JNqvAPcAuW73+AO1Ijjlbp+FcV7MJwmbn2
# qylDc6Hck1wJ5evACzwCEQCWlUUj5DpfXWOJR0tXg6e8GA8yMDIzMDcxODAzMzgz
# OVqgghMHMIIGwDCCBKigAwIBAgIQDE1pckuU+jwqSj0pB4A9WjANBgkqhkiG9w0B
# AQsFADBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5
# BgNVBAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0
# YW1waW5nIENBMB4XDTIyMDkyMTAwMDAwMFoXDTMzMTEyMTIzNTk1OVowRjELMAkG
# A1UEBhMCVVMxETAPBgNVBAoTCERpZ2lDZXJ0MSQwIgYDVQQDExtEaWdpQ2VydCBU
# aW1lc3RhbXAgMjAyMiAtIDIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDP7KUmOsap8mu7jcENmtuh6BSFdDMaJqzQHFUeHjZtvJJVDGH0nQl3PRWWCC9r
# ZKT9BoMW15GSOBwxApb7crGXOlWvM+xhiummKNuQY1y9iVPgOi2Mh0KuJqTku3h4
# uXoW4VbGwLpkU7sqFudQSLuIaQyIxvG+4C99O7HKU41Agx7ny3JJKB5MgB6FVueF
# 7fJhvKo6B332q27lZt3iXPUv7Y3UTZWEaOOAy2p50dIQkUYp6z4m8rSMzUy5Zsi7
# qlA4DeWMlF0ZWr/1e0BubxaompyVR4aFeT4MXmaMGgokvpyq0py2909ueMQoP6Mc
# D1AGN7oI2TWmtR7aeFgdOej4TJEQln5N4d3CraV++C0bH+wrRhijGfY59/XBT3Eu
# iQMRoku7mL/6T+R7Nu8GRORV/zbq5Xwx5/PCUsTmFntafqUlc9vAapkhLWPlWfVN
# L5AfJ7fSqxTlOGaHUQhr+1NDOdBk+lbP4PQK5hRtZHi7mP2Uw3Mh8y/CLiDXgazT
# 8QfU4b3ZXUtuMZQpi+ZBpGWUwFjl5S4pkKa3YWT62SBsGFFguqaBDwklU/G/O+mr
# Bw5qBzliGcnWhX8T2Y15z2LF7OF7ucxnEweawXjtxojIsG4yeccLWYONxu71LHx7
# jstkifGxxLjnU15fVdJ9GSlZA076XepFcxyEftfO4tQ6dwIDAQABo4IBizCCAYcw
# DgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYB
# BQUHAwgwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMB8GA1UdIwQY
# MBaAFLoW2W1NhS9zKXaaL3WMaiCPnshvMB0GA1UdDgQWBBRiit7QYfyPMRTtlwvN
# PSqUFN9SnDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0Eu
# Y3JsMIGQBggrBgEFBQcBAQSBgzCBgDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Au
# ZGlnaWNlcnQuY29tMFgGCCsGAQUFBzAChkxodHRwOi8vY2FjZXJ0cy5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5n
# Q0EuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQBVqioa80bzeFc3MPx140/WhSPx/PmV
# OZsl5vdyipjDd9Rk/BX7NsJJUSx4iGNVCUY5APxp1MqbKfujP8DJAJsTHbCYidx4
# 8s18hc1Tna9i4mFmoxQqRYdKmEIrUPwbtZ4IMAn65C3XCYl5+QnmiM59G7hqopvB
# U2AJ6KO4ndetHxy47JhB8PYOgPvk/9+dEKfrALpfSo8aOlK06r8JSRU1NlmaD1TS
# sht/fl4JrXZUinRtytIFZyt26/+YsiaVOBmIRBTlClmia+ciPkQh0j8cwJvtfEiy
# 2JIMkU88ZpSvXQJT657inuTTH4YBZJwAwuladHUNPeF5iL8cAZfJGSOA1zZaX5YW
# sWMMxkZAO85dNdRZPkOaGK7DycvD+5sTX2q1x+DzBcNZ3ydiK95ByVO5/zQQZ/Ym
# Mph7/lxClIGUgp2sCovGSxVK05iQRWAzgOAj3vgDpPZFR+XOuANCR+hBNnF3rf2i
# 6Jd0Ti7aHh2MWsgemtXC8MYiqE+bvdgcmlHEL5r2X6cnl7qWLoVXwGDneFZ/au/C
# lZpLEQLIgpzJGgV8unG1TnqZbPTontRamMifv427GFxD9dAq6OJi7ngE273R+1sK
# qHB+8JeEeOMIA11HLGOoJTiXAdI/Otrl5fbmm9x+LMz/F0xNAKLY1gEOuIvu5uBy
# VYksJxlh9ncBjDCCBq4wggSWoAMCAQICEAc2N7ckVHzYR6z9KGYqXlswDQYJKoZI
# hvcNAQELBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZ
# MBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1
# c3RlZCBSb290IEc0MB4XDTIyMDMyMzAwMDAwMFoXDTM3MDMyMjIzNTk1OVowYzEL
# MAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJE
# aWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBD
# QTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMaGNQZJs8E9cklRVccl
# A8TykTepl1Gh1tKD0Z5Mom2gsMyD+Vr2EaFEFUJfpIjzaPp985yJC3+dH54PMx9Q
# Ewsmc5Zt+FeoAn39Q7SE2hHxc7Gz7iuAhIoiGN/r2j3EF3+rGSs+QtxnjupRPfDW
# VtTnKC3r07G1decfBmWNlCnT2exp39mQh0YAe9tEQYncfGpXevA3eZ9drMvohGS0
# UvJ2R/dhgxndX7RUCyFobjchu0CsX7LeSn3O9TkSZ+8OpWNs5KbFHc02DVzV5huo
# wWR0QKfAcsW6Th+xtVhNef7Xj3OTrCw54qVI1vCwMROpVymWJy71h6aPTnYVVSZw
# mCZ/oBpHIEPjQ2OAe3VuJyWQmDo4EbP29p7mO1vsgd4iFNmCKseSv6De4z6ic/rn
# H1pslPJSlRErWHRAKKtzQ87fSqEcazjFKfPKqpZzQmiftkaznTqj1QPgv/CiPMpC
# 3BhIfxQ0z9JMq++bPf4OuGQq+nUoJEHtQr8FnGZJUlD0UfM2SU2LINIsVzV5K6jz
# RWC8I41Y99xh3pP+OcD5sjClTNfpmEpYPtMDiP6zj9NeS3YSUZPJjAw7W4oiqMEm
# CPkUEBIDfV8ju2TjY+Cm4T72wnSyPx4JduyrXUZ14mCjWAkBKAAOhFTuzuldyF4w
# Er1GnrXTdrnSDmuZDNIztM2xAgMBAAGjggFdMIIBWTASBgNVHRMBAf8ECDAGAQH/
# AgEAMB0GA1UdDgQWBBS6FtltTYUvcyl2mi91jGogj57IbzAfBgNVHSMEGDAWgBTs
# 1+OC0nFdZEzfLmc/57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYI
# KwYBBQUHAwgwdwYIKwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
# cC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNlcnRzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1UdHwQ8MDowOKA2
# oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290
# RzQuY3JsMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATANBgkqhkiG
# 9w0BAQsFAAOCAgEAfVmOwJO2b5ipRCIBfmbW2CFC4bAYLhBNE88wU86/GPvHUF3i
# Syn7cIoNqilp/GnBzx0H6T5gyNgL5Vxb122H+oQgJTQxZ822EpZvxFBMYh0MCIKo
# Fr2pVs8Vc40BIiXOlWk/R3f7cnQU1/+rT4osequFzUNf7WC2qk+RZp4snuCKrOX9
# jLxkJodskr2dfNBwCnzvqLx1T7pa96kQsl3p/yhUifDVinF2ZdrM8HKjI/rAJ4JE
# rpknG6skHibBt94q6/aesXmZgaNWhqsKRcnfxI2g55j7+6adcq/Ex8HBanHZxhOA
# CcS2n82HhyS7T6NJuXdmkfFynOlLAlKnN36TU6w7HQhJD5TNOXrd/yVjmScsPT9r
# p/Fmw0HNT7ZAmyEhQNC3EyTN3B14OuSereU0cZLXJmvkOHOrpgFPvT87eK1MrfvE
# lXvtCl8zOYdBeHo46Zzh3SP9HSjTx/no8Zhf+yvYfvJGnXUsHicsJttvFXseGYs2
# uJPU5vIXmVnKcPA3v5gA3yAWTyf7YGcWoWa63VXAOimGsJigK+2VQbc61RWYMbRi
# CQ8KvYHZE/6/pNHzV9m8BPqC3jLfBInwAM1dwvnQI38AC+R2AibZ8GV2QqYphwlH
# K+Z/GqSFD/yYlvZVVCsfgPrA8g4r5db7qS9EFUrnEw4d2zc4GqEr9u3WfPwwggWN
# MIIEdaADAgECAhAOmxiO+dAt5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJ
# BgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5k
# aWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBD
# QTAeFw0yMjA4MDEwMDAwMDBaFw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK
# 2FnC4SmnPVirdprNrnsbhA3EMB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/G
# nhWlfr6fqVcWWVVyr2iTcMKyunWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJ
# IB1jKS3O7F5OyJP4IWGbNOsFxl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4M
# K7dPpzDZVu7Ke13jrclPXuU15zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN
# 2NQ3pC4FfYj1gj4QkXCrVYJBMtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I
# 11pJpMLmqaBn3aQnvKFPObURWBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KIS
# G2aadMreSx7nDmOu5tTvkpI6nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9
# HJXDj/chsrIRt7t/8tWMcCxBYKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4
# pncB4Q+UDCEdslQpJYls5Q5SUUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpy
# FiIJ33xMdT9j7CFfxCBRa2+xq4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS31
# 2amyHeUbAgMBAAGjggE6MIIBNjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs
# 1+OC0nFdZEzfLmc/57qYrhwPTzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd
# 823IDzAOBgNVHQ8BAf8EBAMCAYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzAB
# hhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9j
# YWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQw
# RQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZI
# hvcNAQEMBQADggEBAHCgv0NcVec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4
# hxppVCLtpIh3bb0aFPQTSnovLbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3
# rDB6mouyXtTP0UNEm0Mh65ZyoUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs
# 9wPHh6jSTEAZNUZqaVSwuKFWjuyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K
# 2yCNNWAcAgPLILCsWKAOQGPFmCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0n
# ftg62fC2h5b9W9FcrBjDTZ9ztwGpn1eqXijiuZQxggOWMIIDkgIBATB3MGMxCzAJ
# BgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGln
# aUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EC
# EAxNaXJLlPo8Kko9KQeAPVowDQYJYIZIAWUDBAIDBQCggfEwGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3DQEJBTEPFw0yMzA3MTgwMzM4MzlaMCsG
# CyqGSIb3DQEJEAIMMRwwGjAYMBYEFPOHIk2GM4KSNamUvL2Plun+HHxzMDcGCyqG
# SIb3DQEJEAIvMSgwJjAkMCIEIMf04b4yKIkgq+ImOr4axPxP5ngcLWTQTIB1V6Aj
# tbb6ME8GCSqGSIb3DQEJBDFCBEBvshFrY5erbl/PmLPbfOfYHuEyzc92X8Fbbw+g
# rKW1dH2ozROZh0madMDzq3X8R0MpsLjuUfoSp8uipGZtpXLOMA0GCSqGSIb3DQEB
# AQUABIICAKo3GMT5rLLGFx+dO6qP4RloO2WYLNoneXJJt5bnOLXtOxfsH/Tm+q/R
# F8cs2ix0UgwvUoCXVsfcz+8AdjZIFykq4SbbL9nkpDEH13lylH0J5pGcfPFFa0Kf
# 4NOe46/DIFzU5GR0IAyDKy8pvvmaPi3hRMaj9LEvwvRDQ2kMSolTSqXws4iva3A5
# D+XPoYT9gPlucF99g33dskCZMjxdUUzgmElRVhSY5vnVqIsah5RN/p8SVUCdzXDH
# PC97xA3SVu4BsNpPwJZ2Y1aCM1NOMIXlLDM/bif/hvmhIgVHxTdNUUDyZIZq9d3Q
# 3qesvg6nrzaI70YaO+OsZf3eEslrccAVvT90XebWt79nVg3yXc2nDgNJa6lZUCMe
# UswB+efsZLzcYKZtk+4oEFtCkH3pYZowhsMrK3TRFli0df++B3ZT99FmcOoPKPqb
# S5E2D0O3sbscrrmFeSa/ZtEab5NUIZl3rKgBRCAsKJRk1pnc2C1OuYu/LuZkrblB
# 4KzC/cZBm59nuXc10ec7PHIo2l8v0XV1ohBgs+rV2rBpBZEbYIf23frGpkHAQm/t
# xGX1eitROVO3eGc+3vIAuPXbjVnnImfH6KH2Zn9RpdDFaSKsvaPgcwo+7/NVV+wv
# Zm0pztcouOU3aKOvDcvDGq18BvCHUVwniaypMtBH5BGmKIPq9nHq
# SIG # End signature block
