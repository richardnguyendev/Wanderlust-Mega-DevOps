# Wanderlust DevOps Project on Google Cloud Platform (GCP) with GKE 🌍✈️

A comprehensive DevOps CI/CD pipeline project fully deployed on Google Cloud Platform (GCP) using Google Kubernetes Engine (GKE). This project showcases the integration of Jenkins, ArgoCD, Prometheus, Grafana, MongoDB, and Redis

![Preview Image](https://github.com/krishnaacharyaa/wanderlust/assets/116620586/17ba9da6-225f-481d-87c0-5d5a010a9538)
#

# Wanderlust Mega Project End to End Implementation

### In this demo, we will see how to deploy an end to end three tier MERN stack application on GKE cluster.
#
### <mark>Project Deployment Flow:</mark>
<img src="https://github.com/DevMadhup/Wanderlust-Mega-Project/blob/main/Assets/DevSecOps%2BGitOps.gif" />

#

## Tech stack used in this project:
- GitHub (Code)
- Docker (Containerization)
- Jenkins (CI)
- OWASP (Dependency check)
- SonarQube (Quality)
- Trivy (Filesystem Scan)
- ArgoCD (CD)
- Redis (Caching)
- GPC GKE (Kubernetes)
- Helm (Monitoring using grafana and prometheus)

### How pipeline will look after deployment:
- <b>CI pipeline to build and push</b>
<img width="1898" height="898" alt="image" src="https://github.com/user-attachments/assets/f019d7df-d73e-4284-b199-fdebf0522ec6" />

- <b>CD pipeline to update application version</b>
<img width="1904" height="742" alt="image" src="https://github.com/user-attachments/assets/ce010ab3-637e-4b5d-936a-00f7bf6551f1" />

- <b>ArgoCD application for deployment on GKS</b>
<img width="1902" height="951" alt="image" src="https://github.com/user-attachments/assets/3c3ade01-8080-4c28-90a3-ff703acafdb1" />

  - And your jenkins worker node is added
  <img width="1904" height="650" alt="image" src="https://github.com/user-attachments/assets/2e9b9ce8-7598-411f-bd40-024ef29deb8a" />


# 
- <b id="docker">Install docker (Jenkins Worker)</b>

```bash
apt install docker.io -y
usermod -aG docker Thanh && newgrp docker
```
#
- <b id="Sonar">Install and configure SonarQube (Master machine)</b>
```bash
docker run -itd --name SonarQube-Server -p 9000:9000 sonarqube:lts-community
```
#
- <b id="Trivy">Install Trivy (Jenkins Worker)</b>
```bash
sudo apt-get update && sudo apt-get install wget apt-transport-https gnupg lsb-release -y

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -

echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | \
  sudo tee -a /etc/apt/sources.list.d/trivy.list

sudo apt-get update
sudo apt-get install trivy -y

```
#
- <b id="Argo">Install and Configure ArgoCD (Master Machine)</b>
  - <b>Create argocd namespace</b>
  ```bash
  kubectl create namespace argocd
  ```
  - <b>Apply argocd manifest</b>
  ```bash
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  ```
  - <b>Make sure all pods are running in argocd namespace</b>
  ```bash
  watch kubectl get pods -n argocd
  ```
  - <b>Install argocd CLI</b>
  ```bash
  curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
  ```
  - <b>Provide executable permission</b>
  ```bash
  chmod +x /usr/local/bin/argocd
  ```
  - <b>Check argocd services</b>
  ```bash
  kubectl get svc -n argocd
  ```
  - <b>Change argocd server's service from ClusterIP to NodePort</b>
  ```bash
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
  ```
  - <b>Confirm service is patched or not</b>
  ```bash
  kubectl get svc -n argocd
  ```
  - <b> Check the port where ArgoCD server is running and expose it on security groups of a worker node</b>
  <img width="1267" height="205" alt="image" src="https://github.com/user-attachments/assets/2ddf455f-e292-4f48-a4de-7e8c6688e3f0" />

  - <b>Access it on browser, click on advance and proceed with</b>
  ```bash
  <public-ip-worker>:<port>
  ```
  <img width="1918" height="856" alt="image" src="https://github.com/user-attachments/assets/9992fe1e-9c59-4746-8f27-75f6a6043844" />
  
  - <b>Fetch the initial password of argocd server</b>
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
  ```
  - <b>Username: admin</b>
  - <b> Now, go to <mark>User Info</mark> and update your argocd password
#
## Steps to add email notification
- <b id="Mail">Go to your Jenkins Master GCP VM and allow port 465 (SMTPS) through the firewall using Google Cloud Console or gcloud.</b>
#
- <b>Now, we need to generate an application password from our gmail account to authenticate with jenkins</b>
  - <b>Open gmail and go to <mark>Manage your Google Account --> Security</mark></b>
> [!Important]
> Make sure 2 step verification must be on

  <img width="1883" height="893" alt="image" src="https://github.com/user-attachments/assets/0e774de9-3cc0-4495-9ca9-0b38c6c44b42" />

  - <b>Search for <mark>App password</mark> and create a app password for jenkins</b>
  <img width="1895" height="787" alt="image" src="https://github.com/user-attachments/assets/2fb6e357-54da-4d5c-8708-151a896a0534" />

  <img width="1884" height="898" alt="image" src="https://github.com/user-attachments/assets/f504170c-1192-4249-8cd0-7641c4437d68" />

  
#
- <b> Once, app password is create and go back to jenkins <mark>Manage Jenkins --> Credentials</mark> to add username and password for email notification</b>
<img width="1849" height="876" alt="image" src="https://github.com/user-attachments/assets/b57c94fa-ac9d-4bee-a0c1-53f273da4523" />


# 
- <b> Go back to <mark>Manage Jenkins --> System</mark> and search for <mark>Extended E-mail Notification</mark></b>
<img width="1597" height="828" alt="image" src="https://github.com/user-attachments/assets/4eb618fa-bb58-47d5-928f-9a7f8a51def6" />

#
- <b>Scroll down and search for <mark>E-mail Notification</mark> and setup email notification</b>
> [!Important]
> Enter your gmail password which we copied recently in password field <mark>E-mail Notification --> Advance</mark>

<img width="1654" height="751" alt="image" src="https://github.com/user-attachments/assets/ebd7b499-2012-42d2-860f-fde4ba6341e0" />


#
## Steps to implement the project:
- <b>Go to Jenkins Master and click on <mark> Manage Jenkins --> Plugins --> Available plugins</mark> install the below plugins:</b>
  - OWASP
  - SonarQube Scanner
  - Docker
  - Pipeline: Stage View
#
- <b id="Owasp">Configure OWASP, move to <mark>Manage Jenkins --> Plugins --> Available plugins</mark> (Jenkins Worker)</b>
![image](https://github.com/user-attachments/assets/da6a26d3-f742-4ea8-86b7-107b1650a7c2)

- <b id="Sonar">After OWASP plugin is installed, Now move to <mark>Manage jenkins --> Tools</mark> (Jenkins Worker)</b>
<img width="1875" height="963" alt="image" src="https://github.com/user-attachments/assets/9c41987b-716c-4cef-86c5-2aa34b4ece7b" />

#
- <b>Login to SonarQube server and create the credentials for jenkins to integrate with SonarQube</b>
  - Navigate to <mark>Administration --> Security --> Users --> Token</mark>
  ![image](https://github.com/user-attachments/assets/86ad8284-5da6-4048-91fe-ac20c8e4514a)
  ![image](https://github.com/user-attachments/assets/6bc671a5-c122-45c0-b1f0-f29999bbf751)
  ![image](https://github.com/user-attachments/assets/e748643a-e037-4d4c-a9be-944995979c60)

#
- <b>Now, go to <mark> Manage Jenkins --> credentials</mark> and add Sonarqube credentials:</b>
![image](https://github.com/user-attachments/assets/0688e105-2170-4c3f-87a3-128c1a05a0b8)
#
- <b>Go to <mark> Manage Jenkins --> Tools</mark> and search for SonarQube Scanner installations:</b>
![image](https://github.com/user-attachments/assets/2fdc1e56-f78c-43d2-914a-104ec2c8ea86)
#
- <b> Go to <mark> Manage Jenkins --> credentials</mark> and add Github credentials to push updated code from the pipeline:</b>
<img width="1298" height="794" alt="image" src="https://github.com/user-attachments/assets/93a09758-cbcf-45a1-ad81-2fbacdf0c7e5" />

> [!Note]
> While adding github credentials add Personal Access Token in the password field.
#
- <b>Go to <mark> Manage Jenkins --> System</mark> and search for SonarQube installations:</b>
<img width="1565" height="751" alt="image" src="https://github.com/user-attachments/assets/443ec3d4-747a-4ece-bf99-c019c682f191" />

#
- <b>Login to SonarQube server, go to <mark>Administration --> Webhook</mark> and click on create </b>
![image](https://github.com/user-attachments/assets/16527e72-6691-4fdf-a8d2-83dd27a085cb)
![image](https://github.com/user-attachments/assets/a8b45948-766a-49a4-b779-91ac3ce0443c)
#
- <b>Navigate to <mark> Manage Jenkins --> credentials</mark> and add credentials for docker login to push docker image:</b>
<img width="1288" height="745" alt="image" src="https://github.com/user-attachments/assets/031f81c4-25c5-4dfb-a115-39b222970b5a" />

#
- <b>Create a <mark>Wanderlust-CI</mark> pipeline</b>
![image](https://github.com/user-attachments/assets/55c7b611-3c20-445f-a49c-7d779894e232)

#
- <b>Create one more pipeline <mark>Wanderlust-CD</mark></b>
![image](https://github.com/user-attachments/assets/23f84a93-901b-45e3-b4e8-a12cbed13986)
![image](https://github.com/user-attachments/assets/ac79f7e6-c02c-4431-bb3b-5c7489a93a63)
![image](https://github.com/user-attachments/assets/46a5937f-e06e-4265-ac0f-42543576a5cd)
#
- <b>Provide permission to docker socket so that docker build and push command do not fail (Jenkins Worker)</b>
```bash
chmod 777 /var/run/docker.sock
```
![image](https://github.com/user-attachments/assets/e231c62a-7adb-4335-b67e-480758713dbf)
#
- <b> Go to Master Machine and add our own eks cluster to argocd for application deployment using cli</b>
  - <b>Login to argoCD from CLI</b>
  ```bash
   argocd login 35.223.171.95:31335 --username admin
  ```
> [!Tip]
> 35.223.171.95:31335 --> This should be your argocd url

  <img width="1124" height="172" alt="image" src="https://github.com/user-attachments/assets/d7f37bf6-32bf-4c5a-b045-5a2d836bbb6d" />

  - <b>Get your cluster name</b>
  ```bash
  kubectl config get-contexts
  ```
  - <b>Add your cluster to argocd</b>
  ```bash
  argocd cluster add Wanderlust@wanderlust-gke-cluster --name wanderlust-gke-cluster
  ```
  > [!Tip]
  > Wanderlust@wanderlust-gke-cluster --> This should be your GKE Cluster Name when use kubectl config get-contexts .
  
  - <b>Check how many clusters are available in argocd </b>
  ```bash
  argocd cluster list
  ```
  <img width="965" height="77" alt="image" src="https://github.com/user-attachments/assets/e36954b0-1372-48b4-a33b-aea9e625f5d9" />

  
  - <b> Once your cluster is added to argocd, go to argocd console <mark>Settings --> Clusters</mark> and verify it</b>
  <img width="1885" height="502" alt="image" src="https://github.com/user-attachments/assets/afde2527-dc29-4de2-a93f-eb22ca1551c8" />

#
- <b>Go to <mark>Settings --> Repositories</mark> and click on <mark>Connect repo</mark> </b>
![image](https://github.com/user-attachments/assets/cc8728e5-546b-4c46-bd4c-538f4cd6a63d)
<img width="1492" height="795" alt="image" src="https://github.com/user-attachments/assets/975eadd7-179d-47c3-be7b-f5e65c6496b8" />

<img width="1353" height="143" alt="image" src="https://github.com/user-attachments/assets/bd71281c-b4c1-4a7e-9229-11e8051cbc01" />

> [!Note]
> Connection should be successful

- <b>Now, go to <mark>Applications</mark> and click on <mark>New App</mark></b>

![image](https://github.com/user-attachments/assets/ec2d7a51-d78f-4947-a90b-258944ad59a2)

> [!Important]
> Make sure to click on the <mark>Auto-Create Namespace</mark> option while creating argocd application

<img width="1449" height="519" alt="image" src="https://github.com/user-attachments/assets/d7e803f8-0aee-4e01-952b-916cc3c5844a" />

<img width="1460" height="380" alt="image" src="https://github.com/user-attachments/assets/2fa964c9-1a3a-4060-af5d-b0f1f30e262c" />


- <b>Congratulations, your application is deployed on GPC GKE Cluster</b>
<img width="1905" height="757" alt="image" src="https://github.com/user-attachments/assets/f604f105-45a2-4062-8215-3f015923992d" />

<img width="1900" height="946" alt="image" src="https://github.com/user-attachments/assets/6350d807-b832-45f3-a655-6da105ad4680" />

- <b>Open port 31000 and 31100 on worker node and Access it on browser</b>
```bash
<worker-public-ip>:31000
```
<img width="1890" height="638" alt="image" src="https://github.com/user-attachments/assets/4f5ba298-f797-4003-bb04-727aac5995ee" />

<img width="1898" height="900" alt="image" src="https://github.com/user-attachments/assets/a93be4aa-7129-4915-8649-9768d4e86268" />

<img width="1915" height="917" alt="image" src="https://github.com/user-attachments/assets/39e03237-8799-473b-b341-8cc2ab4517d3" />

- <b>Email Notification</b>
<img width="1873" height="728" alt="image" src="https://github.com/user-attachments/assets/fab57ad1-8725-4a0d-908b-a82640bb726a" />


#
## How to monitor GKE cluster, kubernetes components and workloads using prometheus and grafana via HELM (On Master machine)
- <p id="Monitor">Install Helm Chart</p>
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```
```bash
chmod 700 get_helm.sh
```
```bash
./get_helm.sh
```

#
-  Add Helm Stable Charts for Your Local Client
```bash
helm repo add stable https://charts.helm.sh/stable
```

#
- Add Prometheus Helm Repository
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

#
- Create Prometheus Namespace
```bash
kubectl create namespace prometheus
```
```bash
kubectl get ns
```

#
- Install Prometheus using Helm
```bash
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
```

#
- Verify prometheus installation
```bash
kubectl get pods -n prometheus
```

#
- Check the services file (svc) of the Prometheus
```bash
kubectl get svc -n prometheus
```

#
- Expose Prometheus and Grafana to the external world through Node Port
> [!Important]
> change it from Cluster IP to NodePort after changing make sure you save the file and open the assigned nodeport to the service.

```bash
kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus
```
![image](https://github.com/user-attachments/assets/90f5dc11-23de-457d-bbcb-944da350152e)
![image](https://github.com/user-attachments/assets/ed94f40f-c1f9-4f50-a340-a68594856cc7)

#
- Verify service
```bash
kubectl get svc -n prometheus
```

#
- Now,let’s change the SVC file of the Grafana and expose it to the outer world
```bash
kubectl edit svc stable-grafana -n prometheus
```
![image](https://github.com/user-attachments/assets/4a2afc1f-deba-48da-831e-49a63e1a8fb6)

#
- Check grafana service
```bash
kubectl get svc -n prometheus
```

#
- Get a password for grafana
```bash
kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
> [!Note]
> Username: admin

#
- Now, view the Dashboard in Grafana
<img width="1878" height="966" alt="image" src="https://github.com/user-attachments/assets/55dbd482-3f8d-402c-bdfd-6779013e2a50" />

<img width="1875" height="954" alt="image" src="https://github.com/user-attachments/assets/e77962b3-25fc-4260-b401-8613f11a5217" />


#
## Clean Up
- <b id="Clean">Delete GKS cluster</b>
```bash
gcloud container clusters delete wanderlust-cluster --zone=asia-southeast1-a
```

#
