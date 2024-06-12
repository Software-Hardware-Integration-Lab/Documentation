# Manual Deployment

Deploy the SOP app into an Azure App service by using a local deployment script and the zip file containing the SOP Server software.

!!! info "Access Requirements"
    This is currently a manual process and can only be performed if you have the zip file. Because of this, it can only be performed by SHI employees or partners.

1. Download the PowerShell based installer script:
[Install-SOP.ps1](Scripts/Install-Sop.ps1)

2. Make a note of the `Azure Subscription ID` you want to deploy SOP to.

    !!! Danger "Security Best Practice"
        To achieve the best permission and quota isolation, this app should be deployed into an un-used/empty and independent subscription.

3. Make sure that the SOP Zip file is in the same folder as the PowerShell deployment script.

4. Run the deployment script with the below minimal parameters:

    ``` PowerShell title="PowerShell"
    Install-SOP.ps1 -SubscriptionId "{Your Azure Subscription ID}" -Path ".\{SOP Zip File Name.zip}" -CompanyName "{YourCompanyNameHere}"
    ```

    !!! question "Script Help"
        Please replace the content in the curly brackets and the brackets themselves with the value you expect.
        If you would like more help on how to run the script, including examples and additional settings, please run the following command:
        `#!PowerShell Get-Help .\Install-Sop.ps1 -Full`

5. After the SOP has been deployed, please clean up all of the files used to deploy the app service. They are no longer needed.

    !!! note "Errors During Deployment"
        The deployment is idempotent, if errors occur, just run the script a second time. It will correct any missing deployment items the second time around.

6. Please see the app usage docs for next steps.
