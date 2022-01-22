#!/usr/bin/env bash

set -o pipefail
set -e

ENV=""
IMAGE=""
IP=""
ROOTDIR="$( cd -- "$( dirname -- "$(dirname -- "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Create a Packer Image"
   echo
   echo "Usage: $0 [-i Image] [-a IP ADDRESS] [-e ENVIRONMENT]" 1>&2
   echo "options:"
   echo "-i      select the image to create. default 'all'."
   echo "-a      statically select the IP for the http server. default 'none'."
   echo "-e      select environment. defualt 'dev'."
   echo "-h      this :)."
   echo
}
#################################################################################
while getopts "ha:i:e:" option; do
   case ${option} in
      h) # display Help
         Help
         exit
         ;;
      a) # http server address
         IP=${OPTARG}
         export PACKER_HTTP_BUILDER_IPV4=$IP
         ;;
      i)  # select template
         IMAGE=${OPTARG}
         ;;
      e) # select environment
         ENV=${OPTARG}
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

if [ -z "$IP" ]; then
 IP="$( ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' -m1)"
fi

function pckr() {
  local img=$1
  local img_name=$(basename "$img")

  pushd "${img}" > /dev/null
  ln -s -f "${ROOTDIR}/environment/${ENV}/${img_name}.auto.pkrvars.hcl" ./packer/env.auto.pkrvars.hcl

  packer build -force ./packer/
  popd > /dev/null
}

printf "Creating Packer image in '%s' environment\n" $ENV
printf "Going to use '%s' for HTTP Server IP\n" $IP

if [[ -z $IMAGE ]];then
  printf "Will create all image\n"
  for IMAGE in "${ROOTDIR}"/packer/*/;do
    pckr "$IMAGE"
    printf "Clear Temp Files\n"
    rm -rf "${ROOTDIR}/packer/${IMAGE}/packer/env.auto.pkrvars.hcl"
    printf "Done!\n"
  done 
else
  printf "Will create a single image based on ${IMAGE}\n"
  pckr "${ROOTDIR}/packer/${IMAGE}"
  printf "Clear Temp Files\n"
  rm -rf "${ROOTDIR}/packer/${IMAGE}/packer/env.auto.pkrvars.hcl"
  printf "Done!\n"
fi