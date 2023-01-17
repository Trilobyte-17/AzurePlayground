param location string = resourceGroup().location
param AppServicePlanID string

var appName = 'testapp'
var vnetName = '${appName}vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetName = '${appName}sn'
var subnetAddressPrefix = '10.0.0.0/24'


resource WebAppFrontEnd 'Microsoft.Web/sites@2022-03-01' = {
  name: 'WebFrontEndqweqweqweqweqweq'
  location: location
  properties: {
    serverFarmId: AppServicePlanID
    virtualNetworkSubnetId: vnet.properties.subnets[0].id
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

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}
