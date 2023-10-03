terraform {
  required_providers {
      vcd = {
        version = "3.6.0"
      }
      local = {
        version = "2.2.3"
      }
       dns = {
        version = "3.2.3"
      }
  }
  
backend "http" { }
}

provider "dns" {
  update {
    server        = var.dns_ip
    key_name      = var.tsig_key
    key_algorithm = "hmac-md5"
    key_secret    = var.tsig_value
  }
}

provider "vcd" {
  user                          =     var.vcd_org_user
  password                      =     var.vcd_org_password
  org                           =     var.vcd_org_org
  vdc                           =     var.vcd_org_vdc
  url                           =     var.vcd_org_url
  max_retry_timeout             =     var.vcd_org_max_retry_timeout
  allow_unverified_ssl          =     var.vcd_org_allow_unverified_ssl
}

data "vcd_vapp" "servers" {
  name                          =     "${var.vcd_vapp_name}"
  org                           =     var.vcd_org_org
  vdc                           =     var.vcd_org_vdc
}

data "vcd_vapp_org_network" "vcd_vapp_org_network_block"  {
  vapp_name                     =     "${var.vcd_vapp_name}"
  vdc                           =     var.vcd_org_vdc
  org_network_name              =     var.vcd_org_network
}

#some problem with parallel creating can be solved by this block:
resource "vcd_vm" "TestMultiStandalone" {
  for_each                      =     {for vm in var.vms:  vm.name => vm}
  name                          =     "${each.value.name}"
  vdc                           =     var.vcd_org_vdc
  catalog_name                  =     var.vcd_org_catalog
  template_name                 =     var.vcd_template_os_centos7
  power_on                      =     false
  computer_name                 =     "${each.value.name}"
  memory                        =     512
  cpus                          =     1
  cpu_cores                     =     1
  #depends_on                    =     [vcd_independent_disk.Disk_1]
  # u can destroy that shit by command
  # terraform destroy -target  vcd_vm.TestMultiStandalone -var-file=<(cat *.tfvars)
}

resource "vcd_vapp_vm" "vapp_vm_block" {
  for_each                      =     {for vm in var.vms:  vm.name => vm}
  name                          =     "${each.value.name}"
  vdc                           =     var.vcd_org_vdc
  vapp_name                     =     data.vcd_vapp.servers.name
  catalog_name                  =     var.vcd_org_catalog
  template_name                 =     var.vcd_template_os_centos7
  power_on                      =     true
  computer_name                 =     "${each.value.name}"
  memory                        =     "${each.value.ram}"
  cpus                          =     "${each.value.cpu}"
  cpu_cores                     =     "${each.value.cores}"
  
  metadata = {
    key   = "roles"
    value = "${each.value.roles}"
  }
  disk {
    name                  =       "${each.value.name}-hdd"
    bus_number            =       1
    unit_number           =       1
  }

  network {
          name                        =     data.vcd_vapp_org_network.vcd_vapp_org_network_block.org_network_name
          type                        =     "org"
          ip_allocation_mode          =     "MANUAL"
          is_primary                  =     true
          ip                          =     "${each.value.ip}"
  }
  customization {
          allow_local_admin_password  =     true
          auto_generate_password      =     false
          enabled                     =     true
          admin_password              =     var.vm_admin_password
          #initscript                  =     templatefile("${path.module}/userdata.tpl", {
          #  hostname                  =     "${each.value.name}"
          #  })
  }
  depends_on = [vcd_independent_disk.Disk_1]

}

resource "local_file" "output" {
  for_each = vcd_vapp_vm.vapp_vm_block
  content  = "- vm-name: ${each.value.name}\n  ip: ${each.value.network[0].ip}\n  ${each.value.metadata.key}: [${each.value.metadata.value}]\n"
  filename = "vms/ip-${each.value.name}.txt"
}

resource "vcd_independent_disk" "Disk_1" {
  for_each              =   {for vm in var.vms:  vm.name => vm}
  org                   =   var.vcd_org_org
  vdc                   =   var.vcd_org_vdc
  name                  =   "${each.value.name}-hdd"
  size_in_mb            =   "${each.value.hdd}"
}

resource "dns_a_record_set" "master" {
  for_each = vcd_vapp_vm.vapp_vm_block
  zone  = "select-zone.ru."
  name  = each.value.name
  addresses = [each.value.network[0].ip,]
  ttl        = 300
  depends_on = [vcd_vapp_vm.vapp_vm_block]
}
