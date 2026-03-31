locals {
  location= "East US"
}

#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.RG_name
  location = local.location
  
}

#Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.Vnet_name
  address_space       = var.Vnet_address
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#Subnet
resource "azurerm_subnet" "subnet" {
  name = var.Subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = var.Subnet_address
  
}


#Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = var.Public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard"
}


#Network Interface
resource "azurerm_network_interface" "nic" {
  name                = var.NIC_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}


#Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.NSG_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Network Interface association
resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


#Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.VM_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.VM_SKU
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"

  }
}

#Data Disk
resource "azurerm_managed_disk" "Win_data_disk" {
  name                 = var.Datadisk_name
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = var.Datadisk_type
  create_option        = "Empty"
  disk_size_gb         = var.Datadisk_size
  
}

#Data Disk Attachment
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attach" {
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  managed_disk_id   = azurerm_managed_disk.Win_data_disk.id
  lun               = 0
  caching           = "ReadWrite"
}