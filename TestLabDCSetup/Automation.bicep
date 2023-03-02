resource automation 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: 'OctopusAutomation'
}
resource domainconfiguration 'Microsoft.Automation/automationAccounts/configurations@2022-08-08' = {
  name: 'DCSetup'
  properties: {
    source: {
      type: 'uri'
      value: 'https://github.com/Trilobyte-17/AzurePlayground/blob/main/TestLabDCSetup/DC-DSC.ps1'
    }
  }
}
