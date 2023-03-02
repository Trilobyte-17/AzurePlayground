param location string

resource automation 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: 'OctopusAutomation'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Basic'
    }
    publicNetworkAccess: true
  }
}
resource domainconfiguration 'Microsoft.Automation/automationAccounts/configurations@2022-08-08' = {
  name: 'domainconfiguration'
  location: location
  parent: automation
  properties: {
    source: {
      type: 'uri'
      value: 'https://github.com/Trilobyte-17/AzurePlayground/blob/main/TestLabDCSetup/DomainControllerConfig.ps1'
      
    }
  }
}
