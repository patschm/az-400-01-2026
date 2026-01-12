param automation_name string = 'ps-automon'
param vm_name string = 'vm1'
param username string = 'Student'
@secure()
param password string = 'Test_1234567'
param location string = resourceGroup().location
param nic_name string = '${vm_name}-nic'
param ip_name string = '${vm_name}-ip'
param network_name string = 'my-network'
param subnet_name string = 'public'
param image object = {
  publisher: 'microsoftwindowsdesktop'
  offer:'windows-11'
  sku:'win11-24h2-pro'
  version:'latest'
  license: 'Windows_Client'
}


resource automation_name_resource 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: automation_name
  location: 'westeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: true
    disableLocalAuth: false
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
      identity: {}
    }
  }
}


resource ip 'Microsoft.Network/publicIPAddresses@2024-07-01' =  {
  name: ip_name
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vm_name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: image.publisher
        offer: image.offer
        sku: image.sku
        version: image.version
      }
      osDisk: {
        osType: 'Windows'
        name: '${vm_name}-os-disk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        diskSizeGB: 127
      }
    }
    osProfile: {
      computerName: vm_name
      adminUsername: username
      adminPassword: password
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    licenseType: image.license
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: nic_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: resourceId('Microsoft.Network/networkInterfaces/ipConfigurations', nic_name, 'ipconfig1')
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: true ? {
            id: ip.id
          }: null
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', network_name, subnet_name)
          }
        }
      }
    ]
  }
}
