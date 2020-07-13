#!/bin/bash

#author: rjerrom@vmware.com
#This script will setup the CNS provider roles for Kubernetes on VMware vSphere.
# This should read the VC Credentials from external env variable / k8s secret configured as envvar.

#We need a Virtual Center to connect to.  This VC URL may or may not include the login details.
check-envvar()
{
  if [ -z ${GOVC_URL+x} ]
  then
    echo "GOVC_URL envar is unset" >&2
    exit 1
  fi
}

#check the connection to virtual center by grabbing a login token.
check-connect()
{
  if !(GOVC_LOGIN_TOKEN=$(govc session.login -issue))
  then
    exit 1
  fi
}


create-update()
{
if ! (govc role.ls | grep $rolename >/dev/null ) then
  govc role.create $rolename $permissions
  echo -e "$rolename created"
fi
  echo -e "$rolename permissions updated"
  govc role.update $rolename $permissions
  echo -e "$(govc role.ls $rolename)"
  echo -e "\n"
}

echo -e "Setting up vSphere Cloud Native Storage Roles inside Virtual Center\n"
echo -e "If you encounter a problem please open a github issue.\n\n"
check-envvar
check-connect
rolename="CNS-HOST-CONFIG-STORAGE"
permissions="System.Anonymous System.Read System.View VirtualMachine.Config.AddExistingDisk VirtualMachine.Config.AddRemoveDevice"
create-update

rolename="CNS-DATASTORE"
permissions="Cns.Searchable Datastore.FileManagement System.Anonymous System.Read System.View"
create-update

rolename="CNS-VM"
permissions="System.Anonymous System.Read System.View VirtualMachine.Config.AddExistingDisk VirtualMachine.Config.AddRemoveDevice"
create-update

rolename="CNS-SEARCH-AND-SPBM"
permissions="Cns.Searchable StorageProfile.View System.Anonymous System.Read System.View"
create-update
