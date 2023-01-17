param location string
param appName string

var vnetName = '${appName}vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetName = '${appName}-sn'
var subnetAddressPrefix = '10.0.0.0/24'
var ServersSubnetName = 'servers-sn'
var serversubnetAddressPrefix = '10.0.1.0/24'

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
      {
        name: ServersSubnetName
        properties: {
          addressPrefix: serversubnetAddressPrefix
        }
      }
    ]
  }
}

output ventId string = vnet.id
output vnetname string = vnet.name
output WebappSNID string = vnet.properties.subnets[0].id
output ServerSNID string = vnet.properties.subnets[1].id
output ServerSNName string = vnet.properties.subnets[1].name
