# vmc-eks-demo-ui
A hybrid guestbook demo app that is designed to showcase the VMware Cloud on AWS (VMC) native service integration capacbilities with Amazon Elastic Kubernetes Service (Amazon EKS) and AWS DevOps tools, through the connected customer’s Virtual Private Cloud (VPC) using the high-speed, low-latency Elastic Network Interface (ENI). 

This demo app includes two containerised microservices for both the [guestbook-ui](https://github.com/sc13912/vmc-eks-demo-ui) and [guestbook-api](https://github.com/sc13912/vmc-eks-demo-api) components running on a Amazon EKS cluster, and a PostgresSQL VM deployed on a VMC envrionment. 

---
## Prerequisites
* Access to an AWS envrionment 
* Access to a VMC SDDC cluster which is linked to the above AWS account
* A VPC which has L3 reachbility (via ENI or TGW) to the SDDC and contains two public subnets (make sure to enable ***Auto-assign public IPv4 address*** for the public subnets)
* An EC2 Linux Bastion instance deployed in the same VPC
* Install basic tooling on the Bastion VM
```
#Install latest eksctl
https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

#Install Kubectl (latest version 1.19)
https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html 

#Enable Kubectl bash auto-completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
```
---


## Step-1: Deploy and prepare an Amazon EKS managed cluster
### 1.1 Create an EKS cluster using eksctl
```
eksctl create cluster --name *cluster-name* --region *your-aws-region* --nodegroup-name *node-group-name* --node-type t3.large --nodes 2 --vpc-public-subnets *public-subnet-a-id,public-subnet-b-id* --ssh-access --ssh-public-key *your-ssh-pub-key* --managed

#verify cluster has been deployed successfully
eksctl get nodegroup --cluster eks-vmc01
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
```

### 1.2 ***Optional: Install Kubernetes Metrics Server and Ingress Controller***
```
#Install K8s Metrics Server to get resource usage data and statistics
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

#Verify Metrics (CPU/RAM) on nodes and Pods
kubectl top nodes
kubectl top pods --all-namespaces
```
```
#Follow the guide to install a NGINX-based Kubernetes ingress controller: https://kubernetes.github.io/ingress-nginx/deploy/#aws
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.45.0/deploy/static/provider/aws/deploy.yaml

#Verfiy the ingress controller has been deployed and linked to a Network Load Balancer 
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

```
### 1.3 ***Optional: Install SSM Agent on the EKS managed nodes***
Follow the [guide at here](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/install-ssm-agent-on-amazon-eks-worker-nodes-by-using-kubernetes-daemonset.html) 
```
kubectl apply -f ssm_daemonset.yaml && sleep 60 && kubectl delete -f ssm_daemonset.yaml
```
Locate the IAM role created by the eksctl and attached to the EKS managed nodes, and update the IAM role with the below SSM policies 
![ssm-iam](https://user-images.githubusercontent.com/52551458/115188081-bb1d7b00-a127-11eb-8ab7-266b0619ff16.png)

---


## Step-2: Install PostgresSQL (v12) database on a Linux VM (CentOS7/8) runnig on VMC
### 2.1 Install PostgresSQL-12
```
#Prepare a CentOS7 VM
#Copy and execute the supplied bash script to install PostgresSQL engine
chmod +777 install-pgsql.sh
./install-pgsql.sh 

#To install on CentOS8, follow the guide at here: https://computingforgeeks.com/how-to-install-postgresql-12-on-centos-7/ 
```
---


## Step-3: Create a DB instance and table for the demo app
### 3.1 Set the Postgres default password
```
[root@eks-demo-db01 ~]# sudo su - postgres
-bash-4.2$ psql -c "alter user postgres with password '*your-postgres-default-password*'"      
ALTER ROLE
-bash-4.2$ exit
logout
[root@eks-demo-db01 ~]# 
```
### 3.2 Create a DB instance for the demo app using the supplied initDB.sql script (might need to change the db-name/username/password as per your setup)
```
[root@eks-demo-db01 ~]# psql -h 192.168.100.22 -U postgres -f initDB.sql 
Password for user postgres: 
CREATE DATABASE
CREATE ROLE
GRANT
[root@eks-demo-db01 ~]# 
```
### 3.3 Create a DB table for the demo app using the supplied initTable.sql script
```
[root@eks-demo-db01 ~]# psql -h 192.168.100.22 -U vmcdba -d vmcdb -f initTable.sql
Password for user vmcdba: 
CREATE TABLE
[root@eks-demo-db01 ~]# 
[root@eks-demo-db01 ~]# psql -h 192.168.100.22 -U vmcdba -d vmcdb 
Password for user vmcdba: 
psql (12.6)
Type "help" for help.

vmcdb=> \dt
        List of relations
 Schema | Name  | Type  | Owner  
--------+-------+-------+--------
 public | guest | table | vmcdba
(1 row)

vmcdb=> 
```
---


## Step-4: Deploy the microservices (UI & API components) onto the EKS cluster
### 4.1 Deploy the demo app with Kubernetes LoadBalancer object (via Amazon ELB classic load balancer)
```
#First, create a k8s namespace for the demo app
[ec2-user@ip-10-250-0-10 ~]$ kubectl create namespace vmc-demo
namespace/vmc-demo created

#Optional - update the namespaces within both (ui & api) deployment yaml files if you use a different namespace rather than "vmc-demo"

#Update the envrionment varalibles, based on your own Postgres DB setup, within the container spec under the guestbook-api deployment yaml file
[ec2-user@ip-10-250-0-10 k8s-demo]$ vim gb-api-deployment.yaml
```
![api-env](https://user-images.githubusercontent.com/52551458/115193920-1a7f8900-a130-11eb-8b5d-505386b26fac.png)
```
#Deploy the demo app, both ui and api microservices
[ec2-user@ip-10-250-0-10 guestbook-lb]$ kubectl apply  -f .
deployment.apps/guestbook-api created
service/guestbook-api created
deployment.apps/guestbook-ui created
service/guestbook-ui created

#Verify all 4x pods are up and running
[ec2-user@ip-10-250-0-10 guestbook-lb]$ kubectl get pods -n vmc-demo
NAME                             READY   STATUS    RESTARTS   AGE
guestbook-api-64c489667c-4kdjs   1/1     Running   0          2m20s
guestbook-api-64c489667c-qpbs4   1/1     Running   0          2m20s
guestbook-ui-7447f976d4-5cbck    1/1     Running   0          2m20s
guestbook-ui-7447f976d4-hwtkm    1/1     Running   0          2m20s

#Verify both microservices status and obtain the ELB URL 
[ec2-user@ip-10-250-0-10 guestbook-lb]$ kubectl  get svc -n vmc-demo
NAME            TYPE           CLUSTER-IP       EXTERNAL-IP                                                                   PORT(S)        AGE
guestbook-api   ClusterIP      172.20.176.203   <none>                                                                        3000/TCP       2m57s
guestbook-ui    LoadBalancer   172.20.138.240   acf26220299fb4e02a5825f619672fb5-383158863.ap-southeast-2.elb.amazonaws.com   80:32210/TCP   2m57s
```

Now point your browser to the ELB URL and you should have access to the fully functional guestbook demo app, and you should be able to see and leave guest messages.
![demo-app-lb](https://user-images.githubusercontent.com/52551458/115195577-44d24600-a132-11eb-915e-a3ed329a125f.png)

### 4.2 ***Optional: Deploy the demo app with Kubernetes Ingress object (with integration to Amazon NLB)***
