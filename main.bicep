targetScope='subscription'

param resourceGroupName string
param resourceGroupLocation string
param appName string

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module AppServicePlan 'AppServicePlan.bicep' = {
  scope: newRG
  name: 'AppServicePlan'
  params:{
    location: resourceGroupLocation
  }
}

module virtualnet 'VirtualNetwork.bicep' = {
  scope: newRG
  name: 'vnet'
  params: {
    appName: appName
    location: resourceGroupLocation
  }
}
module webapp 'WebApp.bicep' = {
  name: 'WebApp'
  scope: newRG
  params: {
    AppServicePlanID: AppServicePlan.outputs.AppServicePlanID
    location: resourceGroupLocation
    vnetsn: virtualnet.outputs.WebappSNID
  }
}

module Server 'SQLServer.bicep' = {
  scope: newRG
  name: 'Server'
  params: {
    adminPassword: 'Qwertyuiop1234567890*'
    adminUsername: 'ApAdmin'
    dnsLabelPrefix: 'aptestapapapap'
    domainPassword: ''
    domainToJoin: ''
    domainUsername: ''
    existingSubnetName: virtualnet.outputs.ServerSNName
    existingVnetName: virtualnet.outputs.vnetname
  }
}


