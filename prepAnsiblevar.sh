#!/bin/sh
echo $@
echo "---------------------------------------------"
echo "Ansible Deploy Machine for Azure Piplelines"
echo "By Kai Thorsrud, Sicra A/S https://sicra.no/ "
echo "---------------------------------------------"

# This script takes 7 parameters
# 1= SPN URL to use for az login
# 2= Secret of SPN above
# 3= Tenant to login to with az login
# 4= Linux Username this script is to utilize
# 5= Azure DevOps Site URL
# 6= Azure DevOps Personal Access Token (PAT)
# 7= Azure DevOps Agent Pool to Join
# 8= Azure Vault Secret Name that contains the Google Cloud Service Account JSON
# 9 = Name of azure vault where 8 exists

#
# This Script will install all required software for a working 
# Ansible Environment to Execute Ansible Scripts in Azure
# The script will authenticate with azure cli using service principle name
# After successful installation the script will also install 
# Azure DevOps Pipeline Agent and authenticate 
# with an Azure DevOps site using a Personal 
# Access Token, PAT to a preconfigured Deployment Group
# This script is designed to work together with a 
# Terraform Deployment in Azure where this script is 
# executed as an Microsoft.Azure.Extensions CustomScript 2.1
#
# To Aquire a Azure DevOps PAT see https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops#check-prerequisites

echo "Start Config Job" > /home/$4/installstatus.txt
echo "Installing git client" >> /home/$4/installstatus.txt
sudo dnf install git -y
echo "Installing Python 3" >> /home/$4/installstatus.txt
sudo dnf install python3 -y
echo "Installing Python 3 PIP" >> /home/$4/installstatus.txt
sudo dnf install python3-pip -y
echo "Installing Python 3 Virtual Env" >> /home/$4/installstatus.txt
sudo python3 -m pip install virtualenv
echo "Installing python3-devel" >> /home/$4/installstatus.txt
sudo dnf install gcc python3-devel -y
echo "Installing Ansible" >> /home/$4/installstatus.txt
sudo python3 -m pip install ansible
echo "Installing Azure CLI" >> /home/$4/installstatus.txt
sudo python3 -m pip install azure-cli==2.11.1
echo "Installing Ansible Azure Modules" >> /home/$4/installstatus.txt
sudo curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
sudo python3 -m pip install -r requirements-azure.txt
echo "Installing Ansible Azure Modules" >> /home/$4/installstatus.txt
sudo ansible-galaxy collection install azure.azcollection
echo "Login with Azure CLI" >> /home/$4/installstatus.txt
sudo /bin/su -c "/usr/local/bin/az login --service-principal -u $1 -p $2 --tenant $3" - $4
echo "Installing Google Cloud Requirements" >> /home/$4/installstatus.txt
sudo python3 -m pip install google-auth
echo "DevOps Tools Installation Completed" >> /home/$4/installstatus.txt
echo "Start Azure DevOps Agent Installation" >> /home/$4/installstatus.txt
cd /home/$4
mkdir agent
cd agent
AGENTRELEASE="$(curl -s https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest | grep -oP '"tag_name": "v\K(.*)(?=")')"
AGENTURL="https://vstsagentpackage.azureedge.net/agent/${AGENTRELEASE}/vsts-agent-linux-x64-${AGENTRELEASE}.tar.gz"
echo "Release "${AGENTRELEASE}" appears to be latest" >> /home/$4/installstatus.txt
echo "Downloading..." >> /home/$4/installstatus.txt
wget -O agent.tar.gz ${AGENTURL} 
tar zxvf agent.tar.gz
chmod -R 777 .
echo "extracted" >> /home/$4/installstatus.txt
sudo /bin/su -c "/home/$4/agent/bin/installdependencies.sh"
echo "dependencies installed" >> /home/$4/installstatus.txt
echo "/home/$4/agent/config.sh --unattended --url '$5' --auth pat --token '$6' --pool '$7' --agent $HOSTNAME --acceptTeeEula --work ./_work --runAsService --acceptTeeEula --replace" >> /home/$4/installstatus.txt
/bin/su -c "/home/$4/agent/config.sh --unattended --url '$5' --auth pat --token '$6' --pool '$7' --agent $HOSTNAME --acceptTeeEula --work ./_work --runAsService --acceptTeeEula --replace" - $4
echo "Install DevOpsAgent Service" >> /home/$4/installstatus.txt
sudo ./svc.sh install $4
echo "Start DevOpsAgent" >> /home/$4/installstatus.txt
sudo ./svc.sh start
echo "service started" >> /home/$4/installstatus.txt
echo "Install Azure CLI That works with both Ansible and az cli commands. Double install due to bug" >> /home/$4/installstatus.txt
sudo python3 -m pip install azure-cli==2.11.1
echo "Create gcp folder" >> /home/$4/installstatus.txt
cd /home/$4
mkdir gcp
chown -R $4:$4 gcp/
cd gcp
echo "Create gcp JSON" >> /home/$4/installstatus.txt
/bin/su - $4 -c "az keyvault secret download --name 'devops-gcp-creds' --vault-name 'sicra-kv-dep-assets' -f /home/$4/gcp/gcpcredz.json"
echo "Set GCP Variables" >> /home/$4/installstatus.txt
echo "export GCP_SERVICE_ACCOUNT_FILE=/home/'$4'/gcp/gcpcredz.json" >> /home/$4/.bashrc
echo "export GCP_AUTH_KIND=serviceaccount" >> /home/$4/.bashrc

echo "config done" >> /home/$4/installstatus.txt
exit 0