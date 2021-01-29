#!/bin/sh
echo $@
echo "start"
cd /home/sicraroot
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
./config.sh --unattended --url "https://dev.azure.com/sicra/" --auth pat --token $1 --pool "DevOpsMGMAnsible" --agent $HOSTNAME --acceptTeeEula --work ./_work --runAsService --acceptTeeEula --replace
echo "configuration done"
sudo ./svc.sh install
echo "service installed"
sudo ./svc.sh start
echo "service started"
echo "config done"
exit 0