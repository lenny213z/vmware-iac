# vmware-iac

## Overview

The following demo provides a use case for engineers and developers to use IaC in order to build an demo environment in Vmware Infrastructure.

The underlying infrastructure includes:
- VMware Vsphere 
- VMware NSXT
- Akelyess Vault
- Jenkins 

The demo can be run both on Jenkins server with the provided sample JenkinsFile or on a endpoint with the necessary tools installed. 

Ideally, the following process can be used to proper use / test the demo. 

1. Prepare your environment (not included in the documentation)
2. Clone the github repo and create a new branch
3. Make your changes to the code 
4. Commit and Push the Changes to the repo and Open a Pull Request 
5. Github Actions will check for proper formatting for Terraform and Ansible
6. The Jenkins Pipeline will fetch the latest JenkinsFile from the repo and run the pipeline locally (manually)
7. It's required to select the Env, App and the Action (Build, or Destroy) to run the Jenkins Pipeline 
8. The Pipeline will wait for an Approval. A Notification will be send to MS Teams channel. 
9. The local node will build the environment to apply terraform and ansible 

## Used Technologies

### Packer
Packer is a open source tool that enables the management of identical machine images for multiple platforms from a source template. The goal would be to have a single, common image that developers can use to test their code or to use in production environment. 

In the current demo, Packer is used to build a source image for the VMs from a local stored ISO file. The ISO is Centos8-Stream. 
The build image includes the minimal packages for most environments including, development tools and virtual agents. The packer script also includes minimal security hardening like enabling the firewall, adding a sudo user and disabling root access and password access. 

use ***bin/packer.sh -h*** for more information

The script uses Akeyless vault to receive the right authentication for the Vmware Vsphere Server. 

**NOTE:** The script will force the creation of the template even if one already exists. 

## Terraform 
Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc.

The current example builds a network infrastructure in Vmware NSXT as well as the Virtual Machines in Vmware Vsphere needed for further use.

Terrafrom uses Akeyless Vault to get the necessary secrets for Vsphere and NSXT and AWS 

The following Diagram Provides a High Level Design, when all Apps are applied. 

![Network Diagram](https://github.com/lenny213z/vmware-iac/blob/main/diagram.png "Network Diagram")

There are 3 Apps that help build the Demo 

### Base 
The base App creates the necessary network environment including a router and network segments. The current demo does not allow the other Apps to be created if the base App is not available. 

### Web-App 
The Web-App creates a selected number of VMs for Web based applications as well as a Load Balancer that is configured for basic round robin setup for the VMs in the Web Group. The App also includes a basic firewall rule that allows traffic in and out of the network segment, but restrict access between the VMs in the segment (microsegmentation). The App uses an underlying module that can be used to build/destroy VMs , as well as add rules for the firewall. 

### DB-App 
Similar to Web-App

The Terraform Structure includes the use of modules that build multiple resources in stacks.

The state and lock files are stored in an AWS S3 bucket and DynamoDB so that they can be used and monitored by multiple services and teams. 

**NOTE:** In order to build the Infrastructure, please ensure that you have added the AWS S3 backend requirements first.

use ***bin/apply.sh -h*** for information on how to apply terraform. 

## Ansible
Ansible is a radically simple IT automation engine that automates cloud provisioning, configuration management, application deployment, intra-service orchestration, and many other IT needs.

The example demo uses a dynamic inventory build based on the information in Vmware Vsphere to get the right hosts and apply the correct playbooks based on their roles. 

The ansible playbooks are applied automatically with **bin/apply.sh** if the right app is selected. 

## Jenkins
Jenkins is an open-source automation server that can support any team for build a CI/CD process for their project. 

The Jenkins server uses the provided declarative pipeline to fetch and build the provided terraform and ansible code. The pipeline uses the JenkinsFile in the repo. The Pipeline is run manually onPrem and requires the selection of the environment, application and action to be applied. The pipeline can be used for both Building and Destroying the infrastructure. Jenkins is integrated with MS Teams for Notifications. 

# Security and Tests 

- The demo uses centralized vault manager that stores all static secrets, ssh-keys and secret files where needed. 
- Github Actions are used for managing the format for terraform and ansible
- Chef InSpec is used to to a simple validation checks for the created VMs


# Further Development (example)
- Add Monitoring with Splunk, by either adding Splunk Agent to the Packer template or adding it as a task in ansible playbook
- Develop Documentation on how to use the Terraform Modules
- Work with Akeyless to fix Jenkins Integration. 
