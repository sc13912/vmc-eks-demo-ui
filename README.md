# vmc-eks-demo-ui
A hybrid guestbook demo app that is designed to showcase the VMware Cloud on AWS (VMC) native service integration capacbilities with Amazon Elastic Kubernetes Service (Amazon EKS) and AWS DevOps tools, through the connected customer’s Virtual Private Cloud (VPC) using the high-speed, low-latency Elastic Network Interface (ENI). 

This demo app includes two containerised microservices for both the [guestbook-ui](https://github.com/sc13912/vmc-eks-demo-ui) and [guestbook-api](https://github.com/sc13912/vmc-eks-demo-api) components running on a Amazon EKS cluster, and a PostgresSQL VM deployed on a VMC envrionment. 

---
## Prerequisites
* Access to an AWS envrionment 
* Access to a VMC SDDC cluster which is linked to the above AWS account
* A VPC which has L3 reachbility (via ENI or TGW) to the SDDC and contains two public subnets
* An EC2 Linux Bastion instance deployed in the same VPC
* Install basic tooling on the Bastion VM
```
#Install latest eksctl
https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

#Install Kubectl (latest version 1.19)
https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html 
```



## Step-1: De





