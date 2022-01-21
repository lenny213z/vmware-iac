#!/usr/bin/env bash

set -o pipefail
set -e

ROOTDIR="$( cd -- "$( dirname -- "$(dirname -- "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"
ENV=""
APP=""

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Create and Cofigure Apps With Terraform and Ansible"
   echo
   echo "Usage: $0 [-e Environment] [-a App]" 1>&2
   echo "options:"
   echo "-e     select the defined environment. default to 'dev'."
   echo "-a     select the App that's going to be created. default 'all'."
   echo "-h     this :)."   
   echo
}
#################################################################################
while getopts "he:a:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      e) # environment
         ENV=${OPTARG}
         ;;
      a) # application
         APP=${OPTARG}
         ;;
      \?)
         echo "Invalid option: -${OPTARG}. Use -h flag for help."
         exit
         ;;
      :)  # If expected argument omitted:
         echo "Error: -${OPTARG} requires an argument."
         exit
         ;;
      *) # run with no arguments
         ;;
   esac
done

if [ -z "$ENV" ]; then
 ENV="dev"
fi

function apply_ansible() {
  local app=$1
  local app_name=$(basename "$app")

  if [[ -e "${ROOTDIR}/ansible/${app_name}.yaml" ]]; then
    printf "We have a playbook for '%s'. Appling Ansible...\n" $APP
    export VAULT_ADDR=https://hvp.akeyless.io
    export ANSIBLE_CONFIG="${ROOTDIR}/ansible/ansible.cfg"
    ansible-playbook -i "${ROOTDIR}/environment/${ENV}/" "${ROOTDIR}/ansible/${app_name}.yaml" --key-file "${ROOTDIR}/secrets/ssh-keys/ansible" --vault-password-file "${ROOTDIR}/secrets/ansible-vault/key"
    unset ANSIBLE_CONFIG
  else
    printf "No Ansible Playbooks found for this App.\n"
  fi
}

function apply() {
  local app=$1
  local app_name=$(basename "$app")

  pushd "${app}" > /dev/null
  ln -s -f "${ROOTDIR}/environment/${ENV}/${app_name}.tfvars" env.auto.tfvars
  # Below will select or create workspace based on environment name
  terraform workspace select ${ENV} || terraform workspace new ${ENV}
  
  # Disable failure, since we need the exit code
  set +e

  terraform plan -detailed-exitcode -out "${app_name}_${ENV}.plan"
  local tfout=$?
  set -e
  case $tfout in 
    1)
    printf "Terraform plan failed!\n"
    exit 1
    ;;

    0)
    printf "No Terraform changes\n"
    apply_ansible "$app"
    ;;

    2)
    read -p "Are you sure you want to apply above plan? [Y/N]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      terraform apply "${app_name}_${ENV}.plan"
    else
      printf "Exit\n"
      exit 0
    fi
    apply_ansible "$app"
    ;;

    *)
    printf "Unknown exit code %n\n" "$tfout"
    ;;
  esac
  popd > /dev/null
}

printf "Going to use '%s' environment\n" $ENV

if [[ -z $APP ]];then
  printf "Will apply all Apps\n"
  for app in "${ROOTDIR}"/terraform/apps/*/;do
    apply "$app"
    echo "Sleep for 20s"
    sleep 20
    printf "Done!\n"
  done 
else
  printf "Will apply a single App - '%s'\n" $APP
  apply "${ROOTDIR}/terraform/apps/${APP}"
  printf "Done!\n"
fi