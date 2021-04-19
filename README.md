# vmc-eks-demo-ui
A hybrid guestbook demo app that is designed to showcase the VMware Cloud on AWS (VMC) native service integration capacbilities with Amazon Elastic Kubernetes Service (Amazon EKS) and AWS DevOps tools, through the connected customer’s Virtual Private Cloud (VPC) using the high-speed, low-latency Elastic Network Interface (ENI). 

This demo app includes two containerised microservices for both the [guestbook-ui](https://github.com/sc13912/vmc-eks-demo-ui) and [guestbook-api](https://github.com/sc13912/vmc-eks-demo-api) components running on a Amazon EKS cluster, and a PostgresSQL VM deployed on a VMC envrionment. 

---
## Prerequisites
* Access to an AWS envrionment 
* Access to a VMC SDDC cluster which is linked to the above AWS account
* A VPC which has L3 reachbility (via ENI or TGW) to the SDDC and contains two public subnets (make sure to enable *auto-assign public IP* for the public subnets)
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
### Create an EKS cluster using eksctl
```
eksctl create cluster --name *cluster-name* --region *your-aws-region* --nodegroup-name *node-group-name* --node-type t3.large --nodes 2 --vpc-public-subnets *public-subnet-a-id,public-subnet-b-id* --ssh-access --ssh-public-key *your-ssh-pub-key* --managed

#verify cluster has been deployed successfully
eksctl get nodegroup --cluster eks-vmc01
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
```

### Optional: Install Kubernetes Metrics Server and Ingress Controller
```
#Install K8s Metrics Server to get resource usage data and statistics
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

#Verify Metrics (CPU/RAM) on nodes and Pods
kubectl top nodes
kubectl top pods --all-namespaces
```
```
#Follow the guide here to install a NGINX-based Kubernetes ingress controller: https://kubernetes.github.io/ingress-nginx/deploy/#aws
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.45.0/deploy/static/provider/aws/deploy.yaml

#Verfiy the ingress controller has been deployed and linked to a Network Load Balancer 
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

```
### Optional: Install SSM Agent on the EKS managed nodes
Follow the [guide at here](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/install-ssm-agent-on-amazon-eks-worker-nodes-by-using-kubernetes-daemonset.html) 
```
kubectl apply -f ssm_daemonset.yaml && sleep 60 && kubectl delete -f ssm_daemonset.yaml
```



