# Getting Started

Bicep is a domain-specific language that uses declarative syntax to deploy Azure resources.The bicep template (urlShortener.bicep) is found in the `./infrastructureTemplates` folder. To deploy the template, you will need the Entra ID Cloud Application Administrator role or higher.

<<<<<<< Updated upstream
### Steps
=======
How to deploy bicep templates: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-powershell>
>>>>>>> Stashed changes

If you want to set this up on-prem or in a different environment, please refer to the configurations in the bicep template for infra specific configurations. If you wish to not authenticate with a managed identity, please see here for alternate authentication configurations: <https://www.npmjs.com/package/@azure/identity#environment-variables>

## Deployment Steps

1. Navigate to `./infrastructureTemplates` folder in the terminal.
2. Issue the bicep template build command: `bicep build .\urlShortener.bicep`

    Note: Whenever you issue the bicep build command against the bicep template it will compile it into an ARM template which is the language that Azure speaks. Azure does not support bicep natively

3. Ensure that you are logged into your Azure tenant and select your subscription.
4. Make a new Azure resource group with the naming and location convention through the CLI: `New-AzResourceGroup -Name Host -Location EastUs2`

    Note: Resource group has to be created before deployment.

5. Make a new Azure resource group deployment:

    ```powershell
    New-AzResourceGroupDeployment -ResourceGroupName Host -TemplateFile .\urlShortener.json
    ```

    It is pointed to the resource group name that was just created as well as the ARM resource that was just created. This will begin the deployment process.

6. Head over to your as portal at `https://portal.azure.com` and browse to Resource Group > Deployments. This will replicate your Deployment

7. The bicep template also creates an End User Login for the application. This is located at `https://entra.microsoft.com`. This will be under Entra ID > App Registrations on the left hand column.

8. Navigate to API Permissions inside the app that was registered and grant admin consent for your tenant. Once you admin consent, the user interface is able to do delegated operations for this.

    Note: There are two parts where the graph API is called. The app registration and the web app. After the web app is created, it updates the app registration with the login redirect URL which is mandatory for public client authentication where we don't need to have a secret ahead of time. This allows for perfect forward secrecy. You can view the single-page application Redirect URIs under App Registration > the app that was created > Manage > Authentication.

9. Now that the End User Login is created - access must be granted to a user to be able to use the application. Inside the app that was registered go to Overview > Managed application in local directory and click the link. For the very first user or break glass users, add the intended user and Select a role > "Read and Write Everything" and assign it. Remove the Default Access role that is assigned.

    Note: If you do want access restricted, go to the End User Login > Manage > Properties and toggle "Assignment Required?" to Yes.

10. Return to your terminal so you can compile the project in order to upload it. Ensure all your dependencies are up to date with:

    ```powershell
    npm install
    ```

11. Deploy a production build of the server by issuing the command:

    ```powershell
    npm run build:Prod
    ```

    If there are any developer components remove with:

    ```powershell
    npm install --omit=dev
    ```

    and leave only the production runtime components.

12. Open up Explorer app with  

    ```powershell
    explorer .
    ```

    in your terminal and navigate to the `bin` folder and delete the `test` folder.

13. Using a file archiver of your choice, such as 7zip, select `bin` folder, `node_modules` folder, and the `package.json` folder, and drag it into your file archiver to create a .zip package that is Azure compatible.
    The bin folder contains all of the URL shortener command and control logic.
    The node modules contains all of the dependencies.
    The package.json contains the package manifest, which is used to launch the application.

14. Once the deployment is complete, you can now run the upload command which is:

    ```powershell
    Publish-AzWebApp -ArchivePath <Path/of/zip/package> -ResourceGroupName Host -Name <name of webapp> -Restart -Clean -Async
    ```

    Note: The name of the Web App may be a random string of numbers and letters which can be observed under Deployment details as its being deployed. The Type that the resource is associated with should match to `Microsoft Web /sites`.

    Click `Y` to Confirm

15. Type `Microsoft.Sql/servers/azureADO` should now be created which means that the app is now single sign on admin of the system.

16. The azure app service should have the binaries able to run the application, which can be confirmed by going to the web app > going to Deployment Center > Logs > status should be Succeeded (Active)

17. The default domain may prove to be an inconvenience and you may want to add a custom domain. This will be under Settings > Custom domains > Domain. This is operating under the assumption that you are using a valid domain that you own. This allows the Vhost to be able to process the HTTP traffic. After the domain is added, it will need to be added to the SUS UI to process the domain.

18. Next, you are going to set the database Schema. In the azure portal, navigate to the resource group > Overview and select the resource that coincides with the Type `SQL database`. Click on *Set Server Firewall* then under Public access choose Selected networks and under Firewall Rules and `Add your client IPv4 address` to create a rule to allow access to your personal IP address.

19. From here, you need to run the Migration command. In the terminal issue command:

    ```powershell
    disconnect-AzAccount
    ```

    to log out of Azure. Run `npm install` to get all your dependencies back since the migration script is technically a developer dependency. Next set an environment variable. This was done by left clicking on Powertoys and selecting Environment Variables, Underneath Default varaibles > User click on `Add variable`.

    **Variable:**

    Name:

    ```text
    SUS_DB_Host
    ```

    Value:

    ```text
    Value of the server name SQL database. This should end in .database.windows.net
    ```

20. Next, temporarily retrieve the Azure access token to put as an environment variable. Log back into your azure account with admin rights using `connect-AzAccount` and choose the corresponding Subscription and Tenant. Then input:

     ```powershell
     [Microsoft.Azure.Commands.Profile.Models.PSSecureAccessToken]$DbToken = Get-AzAccessToken -ResourceUrl 'https://database.windows.net/'
     ```

    to retrieve the DB access token. You can confirm that it is associated by typing `$DbToken` into the terminal and you will see the associated Token. Convert this from secure string to a usable format.

    ```powershell
    echo "dbAccessToken=$($DbToken.Token | ConvertFrom-SecureString -AsPlainText)" >> $env:GITHUB_OUTPUT
    ```

    Copy out the entire string and make it part of the environment variable similar to what was done for the SQL database. Relaunch your editor so that it replicates the environment variables. These are only available at time of launch by the kernel on process launch.

21. In the terminal, run

    ```powershell
    npm run build:Prod
    ```

    then run

    ```powershell
    npm run migrate:Up:Db:Prod
    ```

    Now the schema is in place and you can remove the environment variables to reset.

22. In the azure portal in the SQL Server, underneath Settings and Microsoft Entra ID, take the name of the application and search it and save it so that the application is an Entra Admin of the database. Then set the firewalls back so that it is no longer exposed internally. Disable the public network access and remove the firewall rule.

    Note: The intended way for this to be deployed is through the CI/CD process and deployed through github actions.

23. Next, you can start the web application and begin using it. Underneath the web app go to Monitoring > Log Stream and open it. An access token is needed for the application. Open an authenticated Node.js terminal:

    Commands:

    ```powershell
    const azIdent = require('@azure/identity')
    ```

    ```powershell
    let cred = new azIdent.DefaultAzureCredential()
    ```

    ```powershell
    await cred.getToken('Resource App id of End User Login/.default')
    ```

    Use the access token provided for accessing the server. In the terminal:

    ```powershell
    $header = @{'Authorization'= "bearer copied-token"}
    ```

    ```powershell
    Invoke-RestMethod -Headers $header -ContentType 'application/json' -Uri 'https://name-of-the-server/Api/Domain' -Method Post -Body '{"allowHTTP": false, "count": 0, "hidden": false, "hostName": "host-of-your-choice", "type": "vanity"}'
    ```

    The name-of-the-server placeholder can be located at Web app > Overview > Copy the Default Domain . Should end in something reminiscent to `.azurewebsites.net`

    The host-of-your-choice placeholder will be the valid domain of your choosing.

24. Afterwards, you can continue with the creation of the redirect. In the terminal:

```powershell
$Body = @{
    'sourceUrl' = 'https://host-of-your-choice/spa'
    'customUserAgentMatcher' = $null
    'expectedBrokenScanStatusCode' = $null
    'enabled' = $true
    'enableLinkBrokenScan' = $false
    'targetUrl' = "https://aka.ms/spa"
    'notEnabledAfter' = $null
    'notEnabledBefore' = $null
    'targetUrlCustom' = $null
    'targetUrlMobile' = $null
    'targetUrlNodeJs' = $null
    'targetUrlPowerShell' = $null
    'targetUrlPython' = $null
    'type' = 'temporary'
}
```

Then,

```powershell
Invoke-RestMethod -Headers $header -ContentType 'application/json' -Uri 'https://name-of-the-server/Api/Redirect' -Method Post -Body $Body | ConvertTo-Json
```

This should allow for redirect on the server side.
