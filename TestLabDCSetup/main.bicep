param scrd string = 'ItsAllAboutMe23!'
param dcred string = 'ItsAllAboutMe23!'

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
    adminPassword: dcred
    existingSubnetName: vnet.outputs.InfrastrucutreSNName
    existingVnetName: vnet.outputs.vnetname
  }
}

module automation 'Automation.bicep' = {
  name: 'OctopusAutomation'
  params:{
    location: 'UKSouth'
    safemodecredental: scrd
    domaincredental: dcred
  }
}

//TODO: Add DC to Automation Node and assign DSC to it




