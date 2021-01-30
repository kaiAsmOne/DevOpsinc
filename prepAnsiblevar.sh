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
sudo /bin/su -c "/usr/local/bin/az login --service-principal -u $1 -p $2 --tenant $3" - $4
echo "DevOps Tools Installation Completed"
echo "Start Azure DevOps Agent Installation"
cd /home/$4
mkdir agent
cd agent
AGENTRELEASE="$(curl -s https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest | grep -oP '"tag_name": "v\K(.*)(?=")')"
AGENTURL="https://vstsagentpackage.azureedge.net/agent/${AGENTRELEASE}/vsts-agent-linux-x64-${AGENTRELEASE}.tar.gz"
echo "Release "${AGENTRELEASE}" appears to be latest" 
echo "Downloading..."
wget -O agent.tar.gz ${AGENTURL} 
tar zxvf agent.tar.gz
chmod -R 777 .
echo "extracted"
sudo ./bin/installdependencies.sh
echo "dependencies installed"
./config.sh --unattended --url "$5" --auth pat --token "$6" --pool "$7" --agent $HOSTNAME --acceptTeeEula --work ./_work --runAsService --acceptTeeEula --replace
echo "configuration done"
sudo ./svc.sh install
echo "service installed"
sudo ./svc.sh start
echo "service started"
echo "config done"

exit 0