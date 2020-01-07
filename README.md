# Ievgen Safronenko Cloud DevOps Engineer Nanodegree Program Capstone Project
This repository contains code for udacity cloud devops nanodegree capstone project.

## Architecture of the project
Capstone project architecture is presented on following diagram:
![Architecture](/solution/images/capstone_eks_architecture.png)

All the details regarding architecture, technical stack, pipelines configuration are presented in [Solution part](solution/SOLUTION.md)

Here presented application description and instructions for getting started.

## Currency Converter application
This repository contains currency converter application.
This protected currency converter application using a public currency converter API https://openexchangerates.org/signup/free,
 and provide a login/registration screen and a main screen to query historical or current exchange rates.

After the successful login the application can show the last 10 queries and their results on the main screen as reminder.
Here is the list of allowed currencies: EUR, USD, GBP, NZD, AUD, JPY, HUF.

## Prerequisites

In order to get started with the project you need to have:

* __Accounts__
  * AWS Account. You can create one [here](https://aws.amazon.com/account/)

* __Software__
  * Git to checkout project from GitHub. Installation guide is [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  * AWS CLI. Installation guide is [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
  * minikube to run docker image on local kubernetes cluster (optional) Installation guide is [here](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  * kubectl to manage local / EKS cluster from console. Installation guide is [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Get started

* Checkout project `git clone https://github.com/ISafronenko/capstone.git`
* From cloudformation/eks-infrastructure run `./create_eks_cluster.sh`
* If everything works correctly you will get stack id like:
```
{
    "StackId": "arn:aws:cloudformation:us-west-2:744578843414:stack/capstone-stack/e5281ed0-2ffb-11ea-8181-02e60452d3a4"
}
```
* After cluster gets deployed (usually takes 10-15 minutes) you need to authorize kubectl to work with EKS Cluster deployed to AWS.
  * run `aws eks --region us-west-2 update-kubeconfig --name capstone_eks_cluster`
  * Go to IAM/Roles and copy arn role id (Capstone-Role) for ConfigMap script in aws-auth-cm.yaml. For example `arn:aws:iam::744578843414:role/Capstone-Role`
  * run `./auth_eks.sh` 
* Test kubectl with EKS cluster by running: `kubectl cluster-info`. If everything is correct you should get output like this:

```Kubernetes master is running at https://64686BAE07E45A8453FFFF698E390BC8.yl4.us-west-2.eks.amazonaws.com
   CoreDNS is running at https://64686BAE07E45A8453FFFF698E390BC8.yl4.us-west-2.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
   To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## Deployment

## Update stack
In order to update stack run: `./update_eks_cluster.sh`
## Delete stack
In order to delete stack run: `./update_eks_cluster.sh`

## Monitoring and health checking
Here are some of the most common endpoints Spring Boot provides out of the box:

/health – Shows application health information (a simple ‘status’ when accessed over an unauthenticated connection or full message details when authenticated); it’s not sensitive by default
/info – Displays arbitrary application info; not sensitive by default

## Using Swagger

All exposed endpoints are documented via Swagger.
Please check: 
* http://localhost:8080/swagger-ui.html on local host
* https://curren.herokuapp.com/swagger-ui.html on internet

## Links
* [Amazon Web Services - Labs](https://github.com/awslabs) - useful materials for creating EKS infrastructure on AWS.
* [Amazon EKS Troubleshooting](https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html) - Good Amazon EKS Troubleshooting guide provided 
* [BlueGreen Deployments](https://martinfowler.com/bliki/BlueGreenDeployment.html) - Blue/Green deployment by Martin Fowler
* [Blue/Green Deployments on Kubernetes](https://www.ianlewis.org/en/bluegreen-deployments-kubernetes) - kubernetes tutorial by Ian Lewis

## Author
* **Ievgen Safronenko** - [Linkedin](https://www.linkedin.com/in/ievgen-safronenko-0ba21144/)
