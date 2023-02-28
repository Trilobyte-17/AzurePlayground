param location string
param enviromentname string

var vnetName = '${enviromentname}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetName = 'Infrastructure-sn'
var subnetAddressPrefix = '10.0.0.0/24'

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
          }
      }
    ]
  }
}

output ventId string = vnet.id
output vnetname string = vnet.name
output InfrastrucutreSNId string = vnet.properties.subnets[0].id
output InfrastrucutreSNName string = vnet.properties.subnets[0].name
