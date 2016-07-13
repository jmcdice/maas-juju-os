#!/bin/bash
#
# Create two UVM's, one for maas, one for juju

function check_ssh_key() {

   echo -n "Checking for ssh key: "
   if [ !-e ~/.ssh/id_rsa ]; then
      echo "Installing"
      ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa &> /dev/null
      cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   else
      echo "Ok"
   fi
}

function install_uvtool() {

   echo -n "Checking for uvtool: "
   uvt-kvm -h &> /dev/null 
   if [ $? != '0' ]; then
      echo "Installing"
      sudo apt -y install uvtool
      uvt-simplestreams-libvirt sync release=xenial arch=amd64
   else
      echo "Ok"
   fi
}

function create_instance() {

   instance=$1
   echo -n "Checking for $instance: "
   uvt-kvm list | grep -q $instance
   if [ $? != '0' ]; then
      echo "Installing"
      uvt-kvm create $instance --cpu 2 --disk 100 --memory 4096 --bridge br0 --user-data config/${instance}-userdata.cfg
   else 
      echo "Running"
   fi

}

install_uvtool
create_instance juju-server
#create_instance maas-server
