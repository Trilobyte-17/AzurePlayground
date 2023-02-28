module vnet'Vnet.bicep' = {
  name: 'vnet'
  params: {
    enviromentname: 'Demo'
    location: 'UKSouth'
  }
}

module DC 'DC.bicep' = {
  name: 'DC'
  params: {
    adminPassword: 'ItsAllAboutMe23!'
    existingSubnetName: vnet.outputs.InfrastrucutreSNName
    existingVnetName: vnet.outputs.vnetname
  }
}

