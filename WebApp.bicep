param location string = resourceGroup().location

resource WebAppFrontEnd 'Microsoft.Web/sites@2022-03-01' = {
  name: 'WebFrontEndqweqweqweqweqweq'
  location: location
  properties: {
    serverFarmId: AppServicePlan.id 
    siteConfig: {
      windowsFxVersion: 'DOTNETCORE|7'
    }
  }
}

resource AppServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'AppServicePlanName'
  location: location
  sku: {
    name: 'F1'
  } 
  kind: 'Windows'
}

resource sourceControls 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  name: '${WebAppFrontEnd.name}/web'
  properties:{
    repoUrl: 'https://github.com/Trilobyte-17/Website'
    branch: 'main'
    isManualIntegration: true
  }
}
