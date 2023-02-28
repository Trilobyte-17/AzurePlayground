@description('Azure Region Locaiton')
param location string = 'UKSouth'
@description('Size of VM')
param vmSize string = 'Standard_B1s'
@description('Admin Account Password')
param adminPassword string
@description('VNET Name')
param existingVnetName string
@description('Subnet Name')
param existingSubnetName string

var dnsLabelPrefix  = 'DC1'
var imagePublisher = 'MicrosoftWindowsServer'
var imageOffer = 'WindowsServer'
var windowsOSVersion = '2019-Datacenter'

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: existingVnetName
}
resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: existingVirtualNetwork
  name: existingSubnetName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'tridevinfradiag'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

//ServerNIC
resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${dnsLabelPrefix}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: publicipv4.id
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: existingSubnet.id
          }
        }        
      }
      
    ]
  }
}

resource publicipv4 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: '${dnsLabelPrefix}-publicip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: dnsLabelPrefix
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: dnsLabelPrefix
      adminUsername: '${dnsLabelPrefix}Admin'
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: windowsOSVersion
        version: 'latest'
      }
      osDisk: {
        name: '${dnsLabelPrefix}-OsDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          name: '${dnsLabelPrefix}-DataDisk'
          caching: 'None'
          createOption: 'Empty'
          diskSizeGB: 1024
          lun: 0
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageAccount.properties.primaryEndpoints.blob
      }
    }
  }
}
