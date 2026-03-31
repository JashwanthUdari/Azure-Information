variable "RG_name" {
  type = string
  description = "Name of Resource Group"
}

variable "Vnet_name" {
    type = string
    description = "Name of the virtual network"

}

variable "Vnet_address" {
    type = list(string)
    description = "The address space for the virtual network."
  
}

variable "Subnet_name" {
    type = string
    description = "Name of the subnet"
}

variable "Subnet_address" {
    type = list(string)
    description = "The address prefix for the subnet."
  
}
variable "Public_ip_name" {
    type = string
    description = "Name of the public IP address"

}

variable "NIC_name" {
    type = string
    description = "Name of the network interface"
  
}

variable "NSG_name" {
    type = string
    description = "Name of the network security group"
  
}

variable "VM_name" {
    type = string
    description = "Name of the virtual machine"
  
}

variable "VM_SKU" {
    type = string
    description = "The SKU of the virtual machine (e.g., Standard_DS1_v2)"
  
}
variable "admin_username" {
    type = string
    description = "Admin username for the virtual machine"
  
}

variable "admin_password" {
  description = "The password for the admin user."
  type        = string
  sensitive   = true
  
}

variable "Datadisk_name" {
    type = string
    description = "Name of the data disk"
  
}

variable "Datadisk_type" {
    type = string
    description = "Type of the data disk (e.g., Standard_LRS, Premium_LRS)"
  
}

variable "Datadisk_size" {
    type = number
    description = "Size of the data disk in GB"
  
}