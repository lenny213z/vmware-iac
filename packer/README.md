# Welcome to my Packer CentOS 8 Repo

# What do I need?

Check the handy checklist below before you race away! You will accomplish your Packer builder sooner - hopefully with less cursing - thus providing more time to invest in building, learning and tweaking the way you want:

    Your choice of CentOS 8.x.x (full DVD ISO x86_64), downloaded and accessible within your vCenter infrastructure. I avoided CentOS minimal boot ISO since not only it required greater tinkering but also network connectivity to download missing packages and so on.

    Have Packer (version 1.7.0 minimum) ready to run and accessible from your path. Regarding the path, watch this YouTube for Windows. Mac or Linux, use Packer's guide. 

    The port group you specify for the VM template build will require Internet access to install apps, perform updates and so on.

    Clone or download a copy of my Packer CentOS 8 repo from Github. 

# File Overview  

Let's cover critical files that are responsible for enabling Packer to automate your VM builds. With a rough idea of what is what, you will hopefully find it easier later on. We will go through another slight detour after this section to build further excitement!

var_centos8.auto.pkrvars.hcl

Contains all input variables to which you assign values. Any explicit values in this file will override the declared default values (these are found in the following file). The auto extension enables Packer to use this file automatically. It does not require you to reference or pass it in the command line explicitly.

vsphere_centos8.pkr.hcl

This file contains the building blocks from declared variables, builder configuration and provisioner stages. Packer uses this to automate the VM template creation process. It will start from scratch to provision the VM and finish by converting the VM to a template.

ks.cfg

All Packer can do without a kickstart file is provision the virtual machine and destroy it in vCenter (the build will time out as it has no connectivity to the VM itself). The kickstart automates the installation of operating, in this case, CentOS. 

# Kickstart

For the uninitiated, kickstart files are to Linux what autounattend files are to Windows. The kickstart file is a text-based configuration file that enables Linux OS installation in an automated fashion. Their extension is in the format of .cfg. 

It goes through with the entire installation process in an automated manner. It sets local and time zones, keyboard layout, network adapter configuration and several bits and bobs. 

The kickstart file you find was built through a mixture of cannibalisation from across the Internet as well as using the kickstart generated from a previous CentOS 8.x.x install (whether an automated one or not). The generated kickstart will contain some but not all of the options you choose during an install. If you would like to pull a configuration file from an existing install, you can find it here:

/root/anaconda-ks.cfg

Now that we have a kickstart file for an automated Linux install, we now need to provide the means of getting the kickstart file into the virtual machine. We don't want to do this manually, so we look for Packer to do it.

Check out RHEL's kickstart syntax reference document. It lists all commands and or options and their required syntax. It helped me immensely in finding my footing.

# Packer Overview

The folder named Packer contains packer related configuration files in HCL format. These two files are what provide the parameters and capability to provision a virtual machine.  The files are var_cento8.auto.pkrvars.hcl and vsphere_centos8.pkr.hcl. Let's cover each one.

AUTO PKVAR HCL

I use the auto.pkvars file as Packer will automatically assign and override default variable values without the need of me to manually pass it through the command line. The values provided are what Packer will use to get down and dirty, such as:

    Credentials for vSphere and CentOS.

    VMware vSphere datacentres, ESXi hosts and datastores.

    Virtual machine specifications like vCPU, memory and disk.

Change them to your needs and requirements. Ensure you pay attention to the os_iso_path variable.  It would be best if you pointed this to where your CentOS ISO is stored.    


If you utilise environment variables or secrets like in GitLab or Github, leave any sensitive variables blank and specify them as environment variables in the file found in the next section.  

PKR HCL

Let's break the PKR file into three sections:

    Declared variables 

    Provisioner Build block

    Source block

# Scripts 

As previously mentioned, we use Packer to upload the scripts to the VM and have it execute each one systematically. The Packer Shell Provisioner is what is responsible for doing this. If you wish to add more scripts, modify or delete them, ensure you edit the array of scripts (this is how you instruct Packer to upload and execute them). 

There is nothing more her to ponder on; it is more of down to you. If you have tons of scripts you'll want to run, consider using Packer to upload the folder that contains the scripts. 


# Packer Build in Linux

Run the command like so:

packer build ./packer/

Packer will find the relative HCL files within the packer directory and start building your virtual machine. 

# Resources and References

Packer Docs
RHEL 8 Kickstart Reference 
