vcd:
- .terraformrc defining paths to local archives with providers
- localproviders is the directory itself with archives of providers
- variables.tf defining variables as entities
- userdata.tpl archive with post steps when creating a VM
- main.tf logic
- vcd.tfvars sensitive variables for cloud, credentials and path to vapp
- vcd_vm.tfvars definition of the list of VMs
- config.http.tfbackend gitlab terraform state backend configuration



#####
- export TF_CLI_CONFIG_FILE=./.terraformrc
- terraform init  -backend-config=config.http.tfbackend -var-file=<(cat *.tfvars)
- chmod 700 .terraform/providers/registry.terraform.io/hashicorp/*/*/*
- terraform validate
- terraform plan -var-file=<(cat *.tfvars)
- terraform apply -auto-approve -var-file=<(cat *.tfvars)
- terraform destroy  -auto-approve -target  vcd_vm.TestMultiStandalone -var-file=<(cat *.tfvars)