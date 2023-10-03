variable "vcd_org_user" {
  description = "vcd Tenant User"
}

variable "vcd_org_password" {
  description = "vcd Tenant Password"
}

variable "vcd_org_org" {
  description = "vcd Tenant Org"
}

variable "vcd_org_url" {
  default     = "https://some_url.ru/api"
  description = "vcd Tenant URL"
}

variable "vcd_org_vdc" {
  description = "vcd Tenant VDC"
}

variable "vcd_org_max_retry_timeout" {
  description = "Retry Timeout"
  default     = "240"
}

variable "vcd_org_allow_unverified_ssl" {
  description = "vcd allow unverified SSL"
  default     = "true"
}

variable "vcd_org_edge_name" {
  description = "vcd edge name"
}

variable "vcd_vapp_name" {
  description = "vcd_vapp_name name"
}

variable "vm_admin_password" {
  description = "vm_admin_password name"
}

variable "vcd_org_catalog" {
  description = "vcd Catalog Name"
}

variable "vcd_template_os_centos7" {
  description = "template vm"
}

variable "vcd_org_network" {
  description = "vcd network Name"
}

variable "vms" {
  type = list(map(string))
  default = [
     {
      name  = "vm-01"
      cpu   = 1
      ram   = 1
      cores = 1
      hdd   = 41200
      roles = "some, role, with, comma, separate"
    },
     {
      name  = "vm-02"
      cpu   = 1
      ram   = 2
      cores = 2
      hdd   = 32400
      roles = "some, role, with, comma, separate"
    }
  ]
}

variable "dns_ip" {
  description = "vcd network Name"
}

variable "tsig_key" {
  description = "vcd network Name"
}

variable "tsig_value" {
  description = "vcd network Name"
}
