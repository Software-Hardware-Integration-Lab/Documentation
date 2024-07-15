<#
.SYNOPSIS
    Uninstalls the SHI Orchestration Platform Architecture.
.DESCRIPTION
    Uses name based searches to find the configurations placed by the SHI Orchestration Platform system and them removes them.
    This operates by default on ESM, SSM and PSM but can be configured to work with only specific security classes or custom ones.
.EXAMPLE
    PS> Uninstall-ShieldArchitecture.ps1
    Uninstalls the deployed SHIELD architecture with the default settings for the parameters (no name customization).
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
    https://docs.shilab.com
.NOTES
    This script requires the same set of permissions as required by the Install-Shield.ps1 script used to deploy the Azure Web App.
    This script has only been tested with PowerShell 7.
    While theoretically compatible with PS 5, usage with PowerShell 5 has not been tested.

    The Microsoft.Graph.Beta module is required for this script to operate.
#>

#Requires -PSEdition Core
#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication"; RequiredVersion="2.8.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Groups"; RequiredVersion="2.8.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Identity.DirectoryManagement"; RequiredVersion="2.8.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Identity.SignIns"; RequiredVersion="2.8.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement"; RequiredVersion="2.8.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement.Administration"; RequiredVersion="2.8.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.DeviceManagement.Enrollment"; RequiredVersion="2.8.0" }

[CmdletBinding(SupportsShouldProcess)]

param(
    [System.String]$Prefix = 'SOP - ',
    [System.String]$Suffix = '',
    [System.String[]]$SecurityClassList = @('PSM', 'SSM', 'ESM'),
    [System.String]$RootScopeTagName = 'SHI-Orchestration-Platform'
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
    Write-Progress -Id 0 -Activity "Uninstalling SHIELD's Architecture" -Status 'Step 1/3 - M365 Login' -PercentComplete 0

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
    Write-Progress -Id 0 -Activity "Uninstalling SHIELD's Architecture" -Status 'Step 2/3 - Data Retrieval' -PercentComplete 30

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
    Write-Progress -Id 0 -Activity "Uninstalling SHIELD's Architecture" -Status 'Step 3/3 - Configuration Removal' -PercentComplete 60

    # Enable and Render Secondary Progress Bar for removal
    Write-Progress -Id 2 -ParentId 0 -Activity 'Removing Conditional Access Policies' -Status "Step $CurrentStep/$RemoveStepCount" -PercentComplete ($CurrentStep / $RemoveStepCount * 100)

    # Remove SHIELD configurations where the lists are iterated over each on their own loop.
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
    Write-Host -Object 'Successfully uninstalled SHIELD architecture!'
}
