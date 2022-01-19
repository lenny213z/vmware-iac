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
   echo "Destroy Apps With Terraform"
   echo
   echo "Usage: $0 [-e Environment] [-a App]" 1>&2
   echo "options:"
   echo "-e     select the defined environment. default to 'dev'."
   echo "-a     select the App that's going to be destroyed. default 'all'."
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

function destroy() {
  local app=$1
  local app_name=$(basename "$app")

  pushd "${app}" > /dev/null
  ln -s -f "${ROOTDIR}/environment/${ENV}/${app_name}.tfvars" env.auto.tfvars
  # Below will select or create workspace based on environment name
  terraform workspace select ${ENV} || terraform workspace new ${ENV}

  set +e
  if [ ENV="dev" ]; then
   printf "Auto Approved for '%s' environment.\n" $ENV
   terraform destroy --auto-approve
   rm -rf env.auto.tfvars
   rm -rf ${app_name}_${ENV}.plan
   else
   terraform destroy
   rm -rf env.auto.tfvars
   rm -rf ${app_name}_${ENV}.plan
  fi
  popd > /dev/null
}

printf "Going to use '%s' environment\n" $ENV

if [[ -z $APP ]];then
  printf "Destroying all Apps\n"
  for app in "${ROOTDIR}"/terraform/apps/*/;do
    destroy "$app"
    printf "Done!\n"
  done 
else
  printf "Destroing '%s' App.\n" ${APP}
  destroy "${ROOTDIR}/terraform/apps/${APP}"
  printf "Done!\n"
fi