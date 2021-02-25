 This script takes 9 parameters
 
 1= SPN URL to use for az login
 
 2= Secret of SPN above
 
 3= Tenant to login to with az login
 
 4= Linux Username this script is to utilize
 
 5= Azure DevOps Site URL
 
 6= Azure DevOps Personal Access Token (PAT)
 
 7= Azure DevOps Agent Pool to Join
 
 8= Azure Vault Secret Name that contains the Google Cloud Service Account JSON
 
 9 = Name of azure vault where 8 exists
 


 This Script will install all required software for a working 
 
 Ansible Environment to Execute Ansible Scripts in Azure
 
 The script will authenticate with azure cli using service principle name
 
 After successful installation the script will also install 
 
 Azure DevOps Pipeline Agent and authenticate 
 
 with an Azure DevOps site using a Personal 
 
 Access Token, PAT to a preconfigured Deployment Group
 
 This script is designed to work together with a 
 
 Terraform Deployment in Azure where this script is 
 
 executed as an Microsoft.Azure.Extensions CustomScript 2.1
 

 To Aquire a Azure DevOps PAT see https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devopscheck-prerequisites
