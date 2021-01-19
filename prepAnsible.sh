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
python3 -m pip install virtualenv
echo "Installing Python 3 Packaging"
python3 -m pip install packaging
echo "Installing Python 3 MS RestAzure"
python3 -m pip install msrestazure
echo "Installing python3-devel"
sudo dnf install gcc python3-devel -y
echo "Installing Ansible Azure Modules"
curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
python3 -m pip install -r requirements-azure.txt
echo "Installing Ansible"
python3 -m pip install ansible[azure]
echo "Installing Azure CLI"
python3 -m pip install azure-cli
echo "Installing Ansible Azure Modules"
ansible-galaxy collection install azure.azcollection
echo "Config done"
exit 0