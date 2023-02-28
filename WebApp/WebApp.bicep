param location string = resourceGroup().location
param AppServicePlanID string

param vnetsn string



resource WebAppFrontEnd 'Microsoft.Web/sites@2022-03-01' = {
  name: 'WebFrontEndqweqweqweqweqweq'
  location: location
  properties: {
    serverFarmId: AppServicePlanID
    virtualNetworkSubnetId: vnetsn
    siteConfig: {
      windowsFxVersion: 'DOTNETCORE|7'
    }
  }
}

resource sourceControls 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  name: '${WebAppFrontEnd.name}/web'
  properties:{
    repoUrl: 'https://github.com/Trilobyte-17/Website'
    branch: 'main'
    isManualIntegration: true
  }
}





