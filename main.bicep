targetScope='subscription'

param resourceGroupName string
param resourceGroupLocation string

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

module webapp 'WebApp.bicep' = {
  name: 'WebApp'
  scope: newRG
  params: {
    AppServicePlanID: AppServicePlan.outputs.AppServicePlanID
    location: resourceGroupLocation
  }
}
