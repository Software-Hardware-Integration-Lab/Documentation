# Getting Started

[Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) is the IaC format used by the SUS project. The bicep template `urlShortener.bicep` is found in the `./infrastructureTemplates` folder. To deploy the template, you will need the [Entra ID Cloud Application Administrator](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#cloud-application-administrator) role or higher.

## Steps

How to deploy bicep templates: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-powershell>

If you want to set this up on-prem or in a different environment, please refer to the configurations in the bicep template for infra specific configurations. If you wish to not authenticate with a managed identity, please see here for alternate authentication configurations: <https://www.npmjs.com/package/@azure/identity#environment-variables>

## Deployment Steps

1. Navigate to `infrastructureTemplates` folder in the terminal. It is found in the root of the `URL-Shortener` repository.

2. Issue the bicep build command: `bicep build .\urlShortener.bicep`

    !!! info "Azure Bicep Support"
        Whenever you issue the bicep build command against the bicep template it will compile it into an ARM template which is the language that Azure speaks. Azure does not support bicep natively.

3. Ensure that you are logged into your Azure tenant and select the correct Azure Subscription.
4. Make a new Azure resource group with the naming and location convention through the CLI:

    ```PowerShell
    New-AzResourceGroup -Name 'Host' -Location 'EastUs2'
    ```

    Note: Resource group has to be created before deployment.

5. Make a new Azure resource group deployment:

    ```PowerShell
    New-AzResourceGroupDeployment -ResourceGroupName 'Host' -TemplateFile '.\urlShortener.json'
    ```

    It is pointed to the resource group name that was just created as well as the ARM resource that was just created. This will begin the deployment process.

6. Head over to your Azure portal at `https://portal.azure.com` and browse to Subscriptions -> `your subscription` -> Resource Groups -> `your resource group` -> Deployments. This will replicate your Deployment

7. The bicep template also creates an `SHI - URL Shortener` service principal to facilitate SSO. This is located at `https://entra.microsoft.com` be under `App Registrations` on the blade menu (left-most navigation menu).

8. Navigate to API Permissions inside the app that was registered and grant admin consent for your tenant. Once you admin consent, the end user is able to log in without needing to consent to permissions or reach out to an admin.

    !!! note
        There are two parts of SUS where it is granted Graph API permissions. The App Registration and the web app's managed identity. After the web app is created, it updates the app registration with the login redirect URL which is mandatory for public client authentication where we don't need to have a secret ahead of time. This allows for perfect forward secrecy. You can view the single-page application Redirect URIs under App Registration > the app that was created > Manage > Authentication.

9. Now that the `SHI - URL Shortener` app is created - access must be granted to a user to be able to use the application. Inside the app that was registered go to Overview > Managed application in local directory and click the link. For the break glass users, add the intended user/group and Select a role > "Read and Write Everything" (`Everything.ReadWrite.All`) and assign it. Remove the Default Access role that is assigned.

    !!! note
        If you do want access restricted, go to the End User Login > Manage > Properties and toggle "Assignment Required?" to Yes. For non-privileged access, you can grant the "General Access" (`Nothing.At.All`) role to the principals that are expected to operate it in a restricted context.

10. Return to your terminal and create a production build of the server:

    ```PowerShell title="CWD: Project Root"
    npm install
    npm run build:Prod
    npm install --omit=dev
    Remove-Item -Path '.\bin\test\' -Force -Recurse
    ```

11. Using the file archiver of your choice, such as *Windows File Explorer* or *7-Zip*, select the `bin` folder, `node_modules` folder, and the `package.json` file, and create a `.zip` package with them at the root.

    !!! info "File/Folder Descriptions"
        - The `bin` folder contains all of the URL Shortener's business logic (the compiled app code).
        - The `node_modules` folder contains all of the runtime dependencies.
        - The `package.json` file contains the package manifest, which is used to launch the application.

12. Once the packaging is complete, you can now run the upload command which is:

    ```PowerShell
    Publish-AzWebApp -ArchivePath '<full/path/to/zip/package>.zip' -ResourceGroupName 'Host' -Name '<name of webapp>' -Restart -Clean -Async
    ```

    Enter `Y` to Confirm

    !!! note
        The name of the Web App may be a random string of numbers and letters which can be observed under Deployment details as its being deployed. The type that the resource is associated with should match to `Microsoft.Web/sites`.

    !!! tip
        The default domain may prove to be an inconvenience and you may want to add a custom domain. This will be under Web App -> Settings > Custom domains. This is operating under the assumption that you are using a valid domain that you own. This allows the vHost to be able to process the HTTP traffic. After the domain is added, it will need to be added to the SUS UI to process the domain.

13. Next, you are going to set up the database schema. In the azure portal, navigate to the resource group > Overview and select the resource that coincides with the Type `SQL database`. Click on *Set Server Firewall* then under Public access choose Selected networks and under Firewall Rules and `Add your client IPv4 address` to create a rule to allow access to your personal IP address.

14. From here, you need to run the Migration command. Run `npm install` to get all your dependencies back since the migration script is technically a developer dependency. Next set an environment variable. This can be done by left clicking on Microsoft PowerToys and selecting Environment Variables, Underneath Default variables > User click on `Add variable`.

    **Variable:**

    Name:

    ```text
    SUS_DB_Host
    ```

    Value:

    ```text
    Value of the server name SQL database. This should end in .database.windows.net
    ```

15. Next, retrieve a short-lived token Azure access token for the Azure SQL DB to put as a temp environment variable:

     ```PowerShell
     [Microsoft.Azure.Commands.Profile.Models.PSSecureAccessToken]$DbToken = Get-AzAccessToken -ResourceUrl 'https://database.windows.net/'
     ```

    to retrieve the DB access token. You can confirm that it is associated by typing `$DbToken` into the terminal and you will see the associated Token. Convert this from secure string to a usable text format.

    ```PowerShell
    $DbToken.Token | ConvertFrom-SecureString -AsPlainText
    ```

    Copy out the entire string and make it part of the environment variable `DB_ACCESS_TOKEN`, using a similar process to step 14. Relaunch your terminal (if using the IDE's terminal, you will need to relaunch the IDE) so that teh host process gets an updated list of the environment variables. Env vars are only injected into the process image at time of launch by the OS kernel.

16. In the terminal, run:

    ```PowerShell
    npm run migrate:Up:Db:Prod
    ```

    Now the schema is in place and you can remove the environment variables.

17. In the azure portal in the Azure SQL Server, underneath Settings and Microsoft Entra ID, take the name of the application and search it and save it so that the application is an Entra Admin of the database. Disable the public network access and remove the firewall rule.

    !!! note
        The intended way for this to be deployed is through a CI/CD process via GitHub Actions.

## See Also

- [Usage Guide](./Usage-Guide.md)
