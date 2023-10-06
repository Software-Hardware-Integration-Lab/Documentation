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
#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Groups"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Identity.DirectoryManagement"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Identity.SignIns"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement.Administration"; RequiredVersion="2.7.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement.Enrollment"; RequiredVersion="2.7.0" }

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
        
    # List of Entra ID CA Policies
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphConditionalAccessPolicy[]]$CaPolicyList = @()

    # Lit of Entra ID CA Policy Named Locations
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphNamedLocation[]]$CaNamedLocationList = @()

    # List of Entra ID CA Authentication Strength Policies
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphAuthenticationStrengthPolicy[]]$CaAuthStrengthPolicyList = @()

    # Render Secondary Progress Bar
    Write-Progress -Id 1 -ParentId 0 -Activity 'Getting Break Glass Group' -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)

    # List of Entra ID Groups
    [Microsoft.Graph.Beta.PowerShell.Models.MicrosoftGraphGroup[]]$GroupList = Get-MgBetaGroup -Filter "displayName eq '$($Prefix)Break Glass 🚨'" -All

    # Increment the current step to make the child progress bar move up
    $CurrentStep++

    # Render Secondary Progress Bar
    Write-Progress -Id 1 -ParentId 0 -Activity 'Getting Admin Units' -Status "Step $CurrentStep/$GetStepCount" -PercentComplete ($CurrentStep / $GetStepCount * 100)

    # List of Entra ID Admin Units
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
# MIIqUgYJKoZIhvcNAQcCoIIqQzCCKj8CAQExDzANBglghkgBZQMEAgMFADCBmwYK
# KwYBBAGCNwIBBKCBjDCBiTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63
# JNLGKX7zUQIBAAIBAAIBAAIBAAIBADBRMA0GCWCGSAFlAwQCAwUABEAC6yD6zsVj
# sIDHDWozFKQISdjW8SMhww4wUlRwp7UlB/1U1Mvq2xvqfvp0e+S8nuR6cs0f8J3I
# 9GK8YIttAhIYoIIOczCCBrAwggSYoAMCAQICEAitQLJg0pxMn17Nqb2TrtkwDQYJ
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
# Xja8ZynISJ/gTi3kZy32/jGCGxIwghsOAgEBMH0waTELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVk
# IEc0IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMQIQD2v9+quc
# RSHWtMF88c65MTANBglghkgBZQMEAgMFAKCB4DAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTBPBgkqhkiG9w0B
# CQQxQgRAb6xd9JFqB7CMnna2EuCOvpKwvtc56cubGmf43sfA8MlwhSIYaRfxZbuL
# r3i2r9wVy94h9TGb9FqhHtYTZnhdJzBUBgorBgEEAYI3AgEMMUYwRKBCgEAATQBT
# AE0AIAAtACAASQBuAGYAcgBhAHMAdAByAHUAYwB0AHUAcgBlACAAVQBuAGkAbgBz
# AHQAYQBsAGwAZQByMA0GCSqGSIb3DQEBAQUABIICAMHvt1PzGo1dnLMKIq+QSjTA
# 1t9Udih1Lj4xUbACHGvCV3GkhE1Esz8FUPzcu4QR01HaSnEgwZ/e+Pe367mY5D9/
# x6UiVOF0k746y+HX/XC1eIYYEYGou3DEXHEcVv9bUJ6IPdHh9ELtWfhdDJCSjQa0
# MoYGO4MrGx0+y0QSb2qQYxbfLrh9mbmltAS8XQONgzmDQD55kcGfe5uvteF07+aQ
# TSGzEELE9Af/aBAxMceLKfiP1AsdP6oFS1pXFyE/ARGEmBVNCvXMHZ1rencIuR31
# A0INVg9ggTtp4j7n3MxFWS/rscMSGd/hRrZ8m/t/pcvHJpvfYgBXyV5xcyrz5CqC
# s3Hp8SoZcT9FZzaLvfmD6kotTUETm6SsYOg74C07iDdBHC9kn7BPNlCSuInfrIpa
# msCnI5MWadykEdL73fq/qbhWuxYlgJpdpzbpE6/9cAwoLktSmIJbPb3Ujm22PkPH
# 3bBxhQLkT3a77L8+7IdKEwOwQKQgy9LnguhsI7rniC6wU9rjJebAM6lgezumm1oq
# kHMWjQJspnP1+9SrY6tlQoy1/csO7Pk47DL7oOj3agw6nOba0nYxWORlkvuqbdMT
# VKonOlogahO+q82RyeP4x40CUSsTeBxmV9ayNrzl2/QAER1xpbohophK2BOnh8BT
# DF/8njgF20krtm6rLMmqoYIXgzCCF38GCisGAQQBgjcDAwExghdvMIIXawYJKoZI
# hvcNAQcCoIIXXDCCF1gCAQMxDzANBglghkgBZQMEAgMFADCBmgYLKoZIhvcNAQkQ
# AQSggYoEgYcwgYQCAQEGCWCGSAGG/WwHATBRMA0GCWCGSAFlAwQCAwUABECc2341
# I6X8+Y5V8U/JpnJlxp3j8q/qX3i2y6Yu59FZqShRvcJfeTrmcenxo05bUuyb5hdM
# c17Q0uDJlhKdX0MqAhBBVB54wmT9uPPtxfn2DOZaGA8yMDIzMTAwNjE2NDAzNFqg
# ghMJMIIGwjCCBKqgAwIBAgIQBUSv85SdCDmmv9s/X+VhFjANBgkqhkiG9w0BAQsF
# ADBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNV
# BAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1w
# aW5nIENBMB4XDTIzMDcxNDAwMDAwMFoXDTM0MTAxMzIzNTk1OVowSDELMAkGA1UE
# BhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMSAwHgYDVQQDExdEaWdpQ2Vy
# dCBUaW1lc3RhbXAgMjAyMzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AKNTRYcdg45brD5UsyPgz5/X5dLnXaEOCdwvSKOXejsqnGfcYhVYwamTEafNqrJq
# 3RApih5iY2nTWJw1cb86l+uUUI8cIOrHmjsvlmbjaedp/lvD1isgHMGXlLSlUIHy
# z8sHpjBoyoNC2vx/CSSUpIIa2mq62DvKXd4ZGIX7ReoNYWyd/nFexAaaPPDFLnkP
# G2ZS48jWPl/aQ9OE9dDH9kgtXkV1lnX+3RChG4PBuOZSlbVH13gpOWvgeFmX40Qr
# StWVzu8IF+qCZE3/I+PKhu60pCFkcOvV5aDaY7Mu6QXuqvYk9R28mxyyt1/f8O52
# fTGZZUdVnUokL6wrl76f5P17cz4y7lI0+9S769SgLDSb495uZBkHNwGRDxy1Uc2q
# TGaDiGhiu7xBG3gZbeTZD+BYQfvYsSzhUa+0rRUGFOpiCBPTaR58ZE2dD9/O0V6M
# qqtQFcmzyrzXxDtoRKOlO0L9c33u3Qr/eTQQfqZcClhMAD6FaXXHg2TWdc2PEnZW
# pST618RrIbroHzSYLzrqawGw9/sqhux7UjipmAmhcbJsca8+uG+W1eEQE/5hRwqM
# /vC2x9XH3mwk8L9CgsqgcT2ckpMEtGlwJw1Pt7U20clfCKRwo+wK8REuZODLIivK
# 8SgTIUlRfgZm0zu++uuRONhRB8qUt+JQofM604qDy0B7AgMBAAGjggGLMIIBhzAO
# BgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEF
# BQcDCDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwHwYDVR0jBBgw
# FoAUuhbZbU2FL3MpdpovdYxqII+eyG8wHQYDVR0OBBYEFKW27xPn783QZKHVVqll
# MaPe1eNJMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydFRydXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdDQS5j
# cmwwgZAGCCsGAQUFBwEBBIGDMIGAMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5k
# aWdpY2VydC5jb20wWAYIKwYBBQUHMAKGTGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydFRydXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdD
# QS5jcnQwDQYJKoZIhvcNAQELBQADggIBAIEa1t6gqbWYF7xwjU+KPGic2CX/yyzk
# zepdIpLsjCICqbjPgKjZ5+PF7SaCinEvGN1Ott5s1+FgnCvt7T1IjrhrunxdvcJh
# N2hJd6PrkKoS1yeF844ektrCQDifXcigLiV4JZ0qBXqEKZi2V3mP2yZWK7Dzp703
# DNiYdk9WuVLCtp04qYHnbUFcjGnRuSvExnvPnPp44pMadqJpddNQ5EQSviANnqlE
# 0PjlSXcIWiHFtM+YlRpUurm8wWkZus8W8oM3NG6wQSbd3lqXTzON1I13fXVFoaVY
# JmoDRd7ZULVQjK9WvUzF4UbFKNOt50MAcN7MmJ4ZiQPq1JE3701S88lgIcRWR+3a
# EUuMMsOI5ljitts++V+wQtaP4xeR0arAVeOGv6wnLEHQmjNKqDbUuXKWfpd5OEhf
# ysLcPTLfddY2Z1qJ+Panx+VPNTwAvb6cKmx5AdzaROY63jg7B145WPR8czFVoIAR
# yxQMfq68/qTreWWqaNYiyjvrmoI1VygWy2nyMpqy0tg6uLFGhmu6F/3Ed2wVbK6r
# r3M66ElGt9V/zLY4wNjsHPW2obhDLN9OTH0eaHDAdwrUAuBcYLso/zjlUlrWrBci
# I0707NMX+1Br/wd3H3GXREHJuEbTbDJ8WC9nR2XlG3O2mflrLAZG70Ee8PBf4NvZ
# rZCARK+AEEGKMIIGrjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzANBgkqhkiG
# 9w0BAQsFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkw
# FwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVz
# dGVkIFJvb3QgRzQwHhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5WjBjMQsw
# CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRp
# Z2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENB
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1ySVFVxyUD
# xPKRN6mXUaHW0oPRnkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50fng8zH1AT
# CyZzlm34V6gCff1DtITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW
# 1OcoLevTsbV15x8GZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12sy+iEZLRS
# 8nZH92GDGd1ftFQLIWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYNXNXmG6jB
# ZHRAp8ByxbpOH7G1WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCY
# Jn+gGkcgQ+NDY4B7dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucf
# WmyU8lKVEStYdEAoq3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLc
# GEh/FDTP0kyr75s9/g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixXNXkrqPNF
# YLwjjVj33GHek/45wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtbiiKowSYI
# +RQQEgN9XyO7ZONj4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O6V3IXjAS
# vUaetdN2udIOa5kM0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8C
# AQAwHQYDVR0OBBYEFLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX
# 44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggr
# BgEFBQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDag
# NIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RH
# NC5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3
# DQEBCwUAA4ICAQB9WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJL
# Kftwig2qKWn8acHPHQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExiHQwIgqgW
# valWzxVzjQEiJc6VaT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2M
# vGQmh2ySvZ180HAKfO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj+sAngkSu
# mScbqyQeJsG33irr9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJ
# xLafzYeHJLtPo0m5d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZJyw9P2un
# 8WbDQc1PtkCbISFA0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SV
# e+0KXzM5h0F4ejjpnOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228Vex4Ziza4
# k9Tm8heZWcpw8De/mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJ
# Dwq9gdkT/r+k0fNX2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr
# 5n8apIUP/JiW9lVUKx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8/DCCBY0w
# ggR1oAMCAQICEA6bGI750C3n79tQ4ghAGFowDQYJKoZIhvcNAQEMBQAwZTELMAkG
# A1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRp
# Z2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENB
# MB4XDTIyMDgwMTAwMDAwMFoXDTMxMTEwOTIzNTk1OVowYjELMAkGA1UEBhMCVVMx
# FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNv
# bTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAv+aQc2jeu+RdSjwwIjBpM+zCpyUuySE98orY
# WcLhKac9WKt2ms2uexuEDcQwH/MbpDgW61bGl20dq7J58soR0uRf1gU8Ug9SH8ae
# FaV+vp+pVxZZVXKvaJNwwrK6dZlqczKU0RBEEC7fgvMHhOZ0O21x4i0MG+4g1ckg
# HWMpLc7sXk7Ik/ghYZs06wXGXuxbGrzryc/NrDRAX7F6Zu53yEioZldXn1RYjgwr
# t0+nMNlW7sp7XeOtyU9e5TXnMcvak17cjo+A2raRmECQecN4x7axxLVqGDgDEI3Y
# 1DekLgV9iPWCPhCRcKtVgkEy19sEcypukQF8IUzUvK4bA3VdeGbZOjFEmjNAvwjX
# WkmkwuapoGfdpCe8oU85tRFYF/ckXEaPZPfBaYh2mHY9WV1CdoeJl2l6SPDgohIb
# Zpp0yt5LHucOY67m1O+SkjqePdwA5EUlibaaRBkrfsCUtNJhbesz2cXfSwQAzH0c
# lcOP9yGyshG3u3/y1YxwLEFgqrFjGESVGnZifvaAsPvoZKYz0YkH4b235kOkGLim
# dwHhD5QMIR2yVCkliWzlDlJRR3S+Jqy2QXXeeqxfjT/JvNNBERJb5RBQ6zHFynIW
# IgnffEx1P2PsIV/EIFFrb7GrhotPwtZFX50g/KEexcCPorF+CiaZ9eRpL5gdLfXZ
# qbId5RsCAwEAAaOCATowggE2MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFOzX
# 44LScV1kTN8uZz/nupiuHA9PMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3z
# bcgPMA4GA1UdDwEB/wQEAwIBhjB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGG
# GGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2Nh
# Y2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDBF
# BgNVHR8EPjA8MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRBc3N1cmVkSURSb290Q0EuY3JsMBEGA1UdIAQKMAgwBgYEVR0gADANBgkqhkiG
# 9w0BAQwFAAOCAQEAcKC/Q1xV5zhfoKN0Gz22Ftf3v1cHvZqsoYcs7IVeqRq7IviH
# GmlUIu2kiHdtvRoU9BNKei8ttzjv9P+Aufih9/Jy3iS8UgPITtAq3votVs/59Pes
# MHqai7Je1M/RQ0SbQyHrlnKhSLSZy51PpwYDE3cnRNTnf+hZqPC/Lwum6fI0POz3
# A8eHqNJMQBk1RmppVLC4oVaO7KTVPeix3P0c2PR3WlxUjG/voVA9/HYJaISfb8rb
# II01YBwCA8sgsKxYoA5AY8WYIsGyWfVVa88nq2x2zm8jLfR+cWojayL/ErhULSd+
# 2DrZ8LaHlv1b0VysGMNNn3O3AamfV6peKOK5lDGCA5YwggOSAgEBMHcwYzELMAkG
# A1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdp
# Q2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQQIQ
# BUSv85SdCDmmv9s/X+VhFjANBglghkgBZQMEAgMFAKCB8TAaBgkqhkiG9w0BCQMx
# DQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIzMTAwNjE2NDAzNFowKwYL
# KoZIhvcNAQkQAgwxHDAaMBgwFgQUZvArMsLCyQ+CXc6qisnGTxmcz0AwNwYLKoZI
# hvcNAQkQAi8xKDAmMCQwIgQg0vbkbe10IszR1EBXaEE2b4KK2lWarjMWr00amtQM
# eCgwTwYJKoZIhvcNAQkEMUIEQN921b1pgyrbOhBzrjSs0IvTy31y2flfhYvrrOil
# H5drb23DyecYQe+Y+klbUNd87Z+YAd0AWngDqvrm/NUltNowDQYJKoZIhvcNAQEB
# BQAEggIAmM0jl0Jd7Cl7UMfX9Vz6wE/T3UUPLYEhDfKU9CrVudmANM0mAnRFsuSy
# LTY6CN/G4JEv/xlweHUIVY0w/gdpc8MV2rGYDlynL4CC8xbmivbkK6VkNtLr40qY
# Fd8asmFgu/kD2L3PMEleKxai2j0oyGXlaFVOOuceGv8GIspEhNVR+xtMoRgtnTtr
# YH7YiSFvtyfhbxReWLVILrbiF7zTEHAS7lRhdgmX8IZY+Su94i1Sal3LaxxgN+aM
# TcVxOqeW8QPoXhHsjSw/WzVNI2alhr4j6rrxeikhaJgoykrmk7/3q4kIElEMZfEi
# f9jHZeqXmydcr6q5juVSvmqj6U06/lmHI8/JdW41srBHeObbF7Uc92mHIuCNDMnX
# UW/0NE39S3Aaxn5YYQfWB9ohPeAjADae7QA+oaoyMjHX961gWocVep3y29QFRai2
# Uoxp0grEV+Ds4FxQqlqLxoOtotdu9J1CTjAKCgY8tTFuqqyEoD+bhcaB63jj+UUa
# ZfgVHqRg2ZStghYtdPBKVxUpJzuHcVjPywlGnKA8S3ECYZqQiBX2sFHWR7AFrYrP
# lZ8a31J5vwIZBj1PcQqzbhHnoIzRkd+aDbdS0Sgf461GLRzP7O/8AZi/TBJrc04V
# UJJAz0gBqBdR23TiaUOvgc8B2WKL0BL5ADEPtU1K7e4J0YW4314=
# SIG # End signature block
