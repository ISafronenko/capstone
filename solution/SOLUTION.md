# Ievgen Safronenko Cloud DevOps Engineer Nanodegree Program Capstone Project

## Scope of the Project
### Architecture of the project
Capstone project architecture is presented on following diagram:
![Architecture](/solution/images/capstone_eks_architecture.png)

### Technical stack
For Capstone project I've used the following technical stack:

* Project source code repository - GitHub.
* Project CI/CD - Jenkins.
* Containers - Docker.
* Container registry - DockerHub.
* Application: Java 8, SpringBoot, Maven.
* IAAS - cloudformation.
* Container orchestrator - Kubernetes.
* Cloud provider: AWS (EC2, CloudFormation, EKS).

### How it works
Project code stored in VCS - Git (GitHub). After a commit with specific commit message Jenkins (CI/CD) triggers a build
which consist of compiling project, running different kind of tests (unit/integration etc), 
building and pushing docker image to container registry.

Infrastructure created as IAAS with cloudformation. This results in Kuberntes cluster being deployed to AWS.
After cluster up and running devops engineer can deploy docker image from registry to the cluster using 
blue/green strategy (described in the last section).

## Jenkins pipeline builds for blue/green deployment
Jenkins master box was created as separate EC2 t2.xlarge instance with all necessary tools installed:

* Maven plugin for building the project
* JDK plugin for building java application
* Docker plugin for building images and push them to docker hub.
* Blue Ocean plugin for improving Jenkins UX. 

Jenkins pipeline specified in Jenkins file and consists of following stages:
* Build - building java SpringBoot application
* Unit test - running JUnit tests 
* Integration tests - running integration tests (for example MockMvc)
* Architectural tests - running Archunit tests to check structural correctness of the java code
* Two stages for build __blue/green__ docker images (depends on commit messages). Depends on stage we are tagging image
with different tags - blue or green.
* Deploy image - pushing blue or green image to docker hub.
* Remove unused image - stage for cleaning Jenkins master box.

### Screenshots of Jenkins pipeline setup and testing

__Jenkins EC2 Instance__
![Jenkins EC2 Instance](/solution/images/jenkins_ec2.png)

__Jenkins Pipeline__
![Jenkins Pipeline](/solution/images/jenkins_pipeline.png)

__Jenkins building Blue image__
![Jenkins Blue Image](/solution/images/jenkins_building_blue_image_pipeline.png)

__Jenkins building Blue image detailed__
![Jenkins Blue Image detailed](/solution/images/jenkins_building_blue_image.png)

__Jenkins building Green image__
![Jenkins building Green image](/solution/images/jenkins_building_green_image_pipeline.png)

__Jenkins Unit tests detailed__
![Jenkins Unit tests detailed](/solution/images/jenkins_unit_tests.png)

__Jenkins box tagged images__
![Jenkins Box tagged images](/solution/images/jenkins_box_tagged_images.png)

## Docker registry
As a result of Jenkins build we have two different docker images in docker registry:
* isafronenko/capstone:blue
* isafronenko/capstone:green

__Docker registry__
![Docker hub registry main](/solution/images/docker_gub_registry_main.png)

__Docker registry detailed__
![Docker registry detailed](/solution/images/docker_hub_registry.png)

## AWS Kubernetes as a Service
Infrastructure for Capstone project was created as cloudformation script which describes all necessary components 
to deploy kubernetes cluster on __Amazon EKS__.

An __Amazon EKS cluster__ consists of two primary components:
* The Amazon EKS control plane
* Amazon EKS worker nodes that are registered with the control plan

__Cluster configuration__
* Cluster: min size - 2, desired size - 3, max size - 4 EC2 instances of type t2.medium with 20 Gb storage attached.
* VPC with two public subnets for two availability zones.
* Internet Gateway with attachment, routing tables and security groups for routing traffic to/from the internet.
* Roles for running service and nodes.
* AutoScalingGroup and LaunchConfiguration for provisioning EC2 instances.

### Screenshots of AWS EKS cluster creation
__Create EKS Cluster from ZSH__
![Create EKS Cluster from ZSH](/solution/images/create_eks_cluster.png) 

__EKS Cluster creation in progress__
![EKS Cluster creation in progress](/solution/images/eks_stack_creation_in_porgress.png)

__EKS Cluster created__
![EKS Cluster created](/solution/images/eks_stack_created.png)

__EKS Cluster nodes__
![EKS Cluster nodes](/solution/images/eks_cluster_nodes.png)

__EKS Cluster is active__
![EKS Cluster is active](/solution/images/eks_cluster_active.png) 

__EKS Cluster events__
![EKS Cluster events](/solution/images/eks_cluster_events.png) 

## Blue/Green deployment with Kubernetes
Kubernetes doesn't have support for blue/green deployments built in. 
Currently the best way to do it is create a new deployment and then update the service for the application to point to the new deployment.

### Replicaset
A Kubernetes __deployment__ specifies a group of instances of an application.
Behind the scenes it creates a __replicaset__ which is responsible for keeping the specified number of instances up and running.

__Replicaset__
![Replicaset](/solution/images/replicas.png)

### Deployments
We can create "blue" deployment by running `kubectl apply -f blue.yml` from deployment folder.
![Blue deployment](/solution/images/blue.png)

__Blue POD Description__
![Blue POD Description](/solution/images/blue_deployment_desc.png)

The same way we can create a "green" deployment: `kubectl apply -f green.yml`
![Green deployment](/solution/images/green.png)

__Green POD Description__
![Green POD Description](/solution/images/green_deployment_desc.png)

__PODs__
![PODs](/solution/images/pods.png)

### Services

Once we have a deployment we can provide a way to access the instances of the deployment by creating a Service.
Services are decoupled from deployments so that means that you don't explicitly point a service at a deployment. 
Instead we specify a label selector which is used to list the pods that make up the service.
When using deployments, this is typically set up so that it matches the pods for a deployment.

__PODs and Services__
![PODs and Services](/solution/images/pods_and_svc.png)

To create a __Service__ we need to run `kubectl apply -f service.yml` with selector version which points to green deployment.

__Application green deployment__
![Application green deployment](/solution/images/green-currency.png)

To implement __blue/green__ deployment we need to update __selector__ version to __blue__.

__Application blue deployment__
![Application blue deployment](/solution/images/blue-currency.png)