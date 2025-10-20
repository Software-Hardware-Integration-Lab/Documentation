This section describes setting up a production instance of the URL redirect server.

Deploy the bicep template (urlShortener.bicep) found in the ./infrastructureTemplates folder. To deploy the template, you will need the Entra ID Cloud Application Administrator role or higher.

How to deploy bicep templates:
```https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-powershell```

If you want to set this up on-prem or in a different environment, please refer to the configurations in the bicep template for infra specific configurations. If you wish to not authenticate with a managed identity, please see here for alternate authentication configurations:
```https://www.npmjs.com/package/@azure/identity#environment-variables```
