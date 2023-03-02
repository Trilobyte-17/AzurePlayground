param location string
@description('Domain Password')
param domaincredental string
@description('SafeMode Password')
param safemodecredental string

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

resource DCNode 'Microsoft.Automation/automationAccounts/nodes@2020-01-13-preview' existing = {
  name: 'DC1'
  parent: automation
}

//note: had to find the RAW link
resource DomainControllerConfig 'Microsoft.Automation/automationAccounts/configurations@2022-08-08' = {
  name: 'DomainControllerConfig'
  location: location
  parent: automation
  properties: {
    source: {
      type: 'uri'
      value: 'https://raw.githubusercontent.com/Trilobyte-17/AzurePlayground/main/TestLabDCSetup/DomainControllerConfig.ps1'
      
    }
  }
}

resource compiledDomainContollerConfig 'Microsoft.Automation/automationAccounts/compilationjobs@2020-01-13-preview' = {
  name: 'DCBuild'
  parent: automation
  properties: {
    configuration: {
      name: DomainControllerConfig.name
    }
  }
  dependsOn: [
    xActiveDirectory,xPendingReboot,xStorage,domaincred,safecred
  ]
}

//Load Modules Needed for Domain Controller Config
resource xActiveDirectory 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
  name: 'xActiveDirectory'
  parent: automation
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/xActiveDirectory/3.0.0.0'
      version: '3.0.0.0'
    }
  }
}

resource xStorage 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
  name: 'xStorage'
  parent: automation
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/xStorage/3.4.0.0'
      version: '3.4.0.0'
    }
  }
}

resource xPendingReboot 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
  name: 'xPendingReboot'
  parent: automation
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/xPendingReboot/3.4.0.0'
      version: '3.4.0.0'
    }
  }
}

//Create Credentals Needed
resource domaincred 'Microsoft.Automation/automationAccounts/credentials@2022-08-08' = {
  name: 'Domain Credental'
  parent: automation
  properties: {
    password: domaincredental
    userName: 'Administrator'
  }
}

resource safecred 'Microsoft.Automation/automationAccounts/credentials@2022-08-08' = {
  name: 'SafeMode Credental'
  parent: automation
  properties: {
    password: safemodecredental
    userName: 'Administrator'
  }
}
