param location string = resourceGroup().location

resource AppServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'AppServicePlanName'
  location: location
  sku: {
    name: 'B1'
  } 
  kind: 'Windows'
}

output AppServicePlanID string = AppServicePlan.id
