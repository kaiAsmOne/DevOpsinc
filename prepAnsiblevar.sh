#!/bin/sh
echo $@
echo "---------------------------------------------"
echo "Ansible Deploy Machine for Azure Piplelines"
echo "By Kai Thorsrud, Sicra A/S https://sicra.no/ "
echo "---------------------------------------------"
echo "Start Config Job"
echo "Installing git client"
sudo dnf install git -y
echo "Installing Python 3"
sudo dnf install python3 -y
echo "Installing Python 3 PIP"
sudo dnf install python3-pip -y
echo "Installing Python 3 Virtual Env"
sudo python3 -m pip install virtualenv
echo "Installing python3-devel"
sudo dnf install gcc python3-devel -y
echo "Installing Ansible"
sudo python3 -m pip install ansible
echo "Installing Azure CLI"
sudo python3 -m pip install azure-cli
echo "Installing Ansible Azure Modules"
sudo curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
sudo python3 -m pip install -r requirements-azure.txt
echo "Installing Ansible Azure Modules"
sudo ansible-galaxy collection install azure.azcollection
echo "Login with Azure CLI"
sudo -S -u sicraroot -i /bin/bash -l az login --service-principal -u $1 -p $2 --tenant $3
echo "Config done"
exit 0