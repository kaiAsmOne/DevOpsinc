#!/bin/sh
echo $@
echo "---------------------------------------------"
echo "Ansible Deploy Machine for Azure Piplelines"
echo "By Kai Thorsrud, Sicra A/S https://sicra.no/ "
echo "---------------------------------------------"
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
sudo python3 -m pip install azure-cli
echo "Installing Ansible Azure Modules" >> /home/$4/installstatus.txt
sudo curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
sudo python3 -m pip install -r requirements-azure.txt
echo "Installing Ansible Azure Modules" >> /home/$4/installstatus.txt
sudo ansible-galaxy collection install azure.azcollection
echo "Login with Azure CLI" >> /home/$4/installstatus.txt
sudo /bin/su -c "/usr/local/bin/az login --service-principal -u $1 -p $2 --tenant $3" - $4
echo "DevOps Tools Installation Completed" >> /home/$4/installstatus.txt
echo "Start Azure DevOps Agent Installation" >> /home/$4/installstatus.txt
#cd /home/$4
#mkdir agent
#cd agent
#AGENTRELEASE="$(curl -s https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest | grep -oP '"tag_name": "v\K(.*)(?=")')"
#AGENTURL="https://vstsagentpackage.azureedge.net/agent/${AGENTRELEASE}/vsts-agent-linux-x64-${AGENTRELEASE}.tar.gz"
#echo "Release "${AGENTRELEASE}" appears to be latest" >> /home/$4/installstatus.txt
#echo "Downloading..." >> /home/$4/installstatus.txt
#wget -O agent.tar.gz ${AGENTURL} 
#tar zxvf agent.tar.gz
#chmod -R 777 .
#echo "extracted" >> /home/$4/installstatus.txt
#sudo /bin/su -c "/home/$4/agent/bin/installdependencies.sh"
#echo "dependencies installed" >> /home/$4/installstatus.txt
#echo "/home/$4/agent/config.sh --unattended --url '$5' --auth pat --token '$6' --pool '$7' --agent $HOSTNAME --acceptTeeEula --work ./_work --runAsService --acceptTeeEula --replace" >> /home/$4/installstatus.txt
#sudo /bin/su -c "/home/$4/agent/config.sh --unattended --url '$5' --auth pat --token '$6' --pool '$7' --agent $HOSTNAME --acceptTeeEula --work ./_work --runAsService --acceptTeeEula --replace" - $4
#echo "configuration done" >> /home/$4/installstatus.txt
#sudo /bin/su -c "/home/$4/agent/svc.sh install" - $4
#echo "service installed" >> /home/$4/installstatus.txt
#sudo /bin/su -c "/home/$4/agent/svc.sh start" - $4
#echo "service started" >> /home/$4/installstatus.txt
echo "config done" >> /home/$4/installstatus.txt
exit 0