#!/bin/sh
echo $@
echo "start"
cd /home/sicraroot

echo "Installing gitclient"
sudo dnf install git -y
echo "Installing Python 3"
sudo dnf install python3 -y
echo "Installing Python 3 PIP"
sudo dnf install python3-pip -y
echo "Installing Python 3 Virtual Env"
sudo -H python3 -m pip install virtualenv
echo "Installing Python 3 Packaging"
python3 -m pip install packaging
echo "Installing Python 3 MS RestAzure"
python3 -m pip install msrestazure
echo "Installing from Git"
curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
sudo python3 -m pip install -r requirements-azure.txt
sudo python3 -m pip install ansible[azure]
rm requirements-azure.txt
ansible-galaxy collection install azure.azcollection
echo "config done"
exit 0