#!/bin/sh
echo $@
echo "---------------------------------------------"
echo "Ansible Deploy Machine for Azure Piplelines"
echo "By Kai Thorsrud, Sicra A/S https://sicra.no/ "
echo "---------------------------------------------"
sudo dnf install git -y
sudo dnf install python3 -y
sudo dnf install python3-pip -y
sudo python3 -m pip install virtualenv
sudo dnf install gcc python3-devel -y
sudo python3 -m pip install ansible
sudo python3 -m pip install azure-cli==2.11.1
sudo curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
sudo python3 -m pip install -r requirements-azure.txt
sudo ansible-galaxy collection install azure.azcollection
sudo /bin/su -c "/usr/local/bin/az login --service-principal -u $1 -p $2 --tenant $3" - $4
sudo python3 -m pip install google-auth
cd /home/$4
mkdir agent
cd agent
AGENTRELEASE="$(curl -s https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest | grep -oP '"tag_name": "v\K(.*)(?=")')"
AGENTURL="https://vstsagentpackage.azureedge.net/agent/${AGENTRELEASE}/vsts-agent-linux-x64-${AGENTRELEASE}.tar.gz"
wget -O agent.tar.gz ${AGENTURL} 
tar zxvf agent.tar.gz
chmod -R 777 .
sudo /bin/su -c "/home/$4/agent/bin/installdependencies.sh"
/bin/su -c "/home/$4/agent/config.sh --unattended --url '$5' --auth pat --token '$6' --pool '$7' --agent $HOSTNAME --acceptTeeEula --work ./_work --runAsService --acceptTeeEula --replace" - $4
sudo ./svc.sh install $4
sudo ./svc.sh start
echo "Install Azure CLI That works with both Ansible and az cli commands. Double install due to bug"
sudo python3 -m pip install azure-cli==2.11.1
cd /home/$4
mkdir gcp
chown -R $4:$4 gcp/
cd gcp
/bin/su - $4 -c "az keyvault secret download --name '$8' --vault-name '$9' -f /home/$4/gcp/gcpcredz.json"
echo "export GCP_SERVICE_ACCOUNT_FILE=/home/'$4'/gcp/gcpcredz.json" >> /home/$4/.bashrc
echo "export GCP_AUTH_KIND=serviceaccount" >> /home/$4/.bashrc
echo "export ANSIBLE_HOST_KEY_CHECKING=False" >> /home/$4/.bashrc
sudo dnf makecache
sudo dnf install epel-release -y
sudo dnf makecache
sudo dnf install sshpass -y
mkdir /etc/ansible/
cd /etc/ansible/
sudo curl -O https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg
sed -i "s/#host_key_checking = True/host_key_checking = False/" /etc/ansible/ansible.cfg
cd /home/$4
/bin/su - $4 -c "git clone https://github.com/citrix/citrix-adc-ansible-modules.git"
cd citrix-adc-ansible-modules
sudo python3 -m pip install paramiko
sudo python3 -m pip install /home/$4/citrix-adc-ansible-modules/deps/nitro-python-1.0_kamet.tar.gz
sudo ansible-galaxy collection install git+https://github.com/citrix/citrix-adc-ansible-modules.git#/ansible-collections/adc
sudo ansible-galaxy collection install git+https://github.com/citrix/citrix-adc-ansible-modules.git#/ansible-collections/adm


exit 0