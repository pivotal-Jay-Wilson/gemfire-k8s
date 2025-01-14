# GemFire Kubernetes example

## First Steps
1. Install [Terraform](https://registry.terraform.io/)
2. Run ```./.clean``` shell script to delete any terraform artifacts 
3. Download helm charts for the version of gemfire you want to deploy and put it in the gemfire/helmcharts/ directory
    - ./gemfire/helmcharts/gemfire-crd-x.x.x.tgz
    - ./gemfire/helmcharts/gemfire-operator-2.4.0.tgz
4. Setup a Kubernetes environment below(Minikube, GCP) 
   - Azure and Tanzu labs have not been tested 
   - For GCP I have used the playground in [A Cloud Guru](https://learn.acloud.guru/cloud-playground/cloud-sandboxes).
 
## Get an Access Token for Broadcom Registry
1. Login to https://support.broadcom.com/ and select My Downloads
2. Search by Product Name = VMware Tanzu GemFire
3. Click on VMware Tanzu GemFire
4. Click on VMware Tanzu GemFire
5. Scroll down, Show All Releases, scroll down to Click Green Token for Repository Access and click on the green symbol to the far right.
6. Note your email address.  
7. Copy your access_token (not including any surrounding quotation marks)
### Optional (Test the token)
1. docker login registry.packages.broadcom.com
2. Enter the email address shown as the username and access token as the password.
3.  docker run -it -e ACCEPT_TERMS=y registry.packages.broadcom.com/pivotal-gemfire/vmware-gemfire:10.0.5 gfsh

## Minikube
1. Install [Minikube](https://minikube.sigs.k8s.io/docs/)
2. Change to the minkube directory
3. Run: ```terraform init``` 
4. Run: ```terraform plan -out state.txt``` 
5. Run: ```terraform apply "state.txt" ``` 
6. Set the profile to gemfire ```minikube profile gemfire```

## GCP
1. Create a GCP lab in ACloudGuru
2. Update gcloud/terraform.tfvars with the location and project id: 
   ```
   location = "us-central1"
   project_id = "playground-s-11-680e9bb4" 
    ```
3. Run these commands to log in 
```
gclound init
gcloud auth application-default login   

```
4. Enable the kubernetes api;
```
gcloud services enable container.googleapis.com
```
5.  run: ```terraform init``` 
6.  run: ```terraform plan -out state.txt``` 
7.  run: ```terraform apply "state.txt" ``` 
8.  Set up the local kubeconfig
```
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name)  --region us-central1 --project $(terraform output -raw project_id)
```


## AZURE -- not tested with acloud guru
1. Create a azure lab 
2. Update variables
3. Run terraform under azure
4. Run this command to add cluster creds to your   
```
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)    
```



## KIND
TBD

## TANZU Lab - not tested
1. run pieline for tkg
2. Login to the jump box
3. get the working clusters connection info and merge this with your local config file
```
 tanzu kubernetes cl kubeconfig get workload-slot35rp19 --admin   --export-file admin.txt
```

## All Platforms
1. Update gemfire/terraform.tfvars:
```
reg = <docker registry for Gemfire images>
reguser = <user name for docker registry>
regpassword = <password for docker registry>
config_path = <kubernetes config name>
gemfire_op_version = <version of the gemfire operator that you downloaded>
```
5.  Change to the ./gemfire directory
6.  Run: ```terraform init``` 
7.  Run: ```terraform plan -out state.txt``` 
8.  Run: ```terraform apply "state.txt" ``` 
9.  Forward the gemfire management console to your local computer
```
kubectl port-forward -n gemfire-operator services/gemfire-management-console 8080:8080 
```
or for Minikube:
```
minikube service -n gemfire-operator  gemfire-management-console  --urlmini
```
10. Open http://localhost:8080/
11. Enable developer mode
12. Import connections file exportConnection_2024815.json
13. Select both clusters and impprt 

##TODO
1. Kpack to install demo apps
2. AWS setup
3. LDAP security

