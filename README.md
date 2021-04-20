# How to Automate Your Kubernetes Deployment

In this session we will use Terraform and Ansible to setup a Kubernetes cluster in the cloud.  This is an intesnive hands on session for people who want to learn these technologies.

## Before starting
You will need access to your own AWS account.  AWS has some free offerings that would work for this.  You will also need to have a computer capible of running both Terraform and Ansible.  Our examples here will be done in linux but should be roughly the same steps in other opperating systems.  

## Table of content and resources

| Title  | Description
|---|---|
| **1 - Installation and configuration** | [Instructions](#1-Installation-and-configuration)  |
| **2 - Running the scripts** | [Instructions](#2-Running-the-scripts)  |
| **3 - Resources** | [Instructions](#3-Resources)  |

## 1. Installation and configuration

Description of the first section what we are going to try and do.

**✅ Step 1a: Terraform Setup.** 

In Linux we can simply add the hashicorp repositories so we can use our package manager to do the installation for us.  Offical docs can be found [here](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

```bash 
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

Now that we have added the correct repo we can run the installation.

```bash
sudo apt-get update && sudo apt-get install terraform
```

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

To verify the installation we can run the following command

```bash 
terraform -help
```
<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

**✅ Step 1b: Ansible setup.** 

If you are running on a Ubuntu box you can run the following commands to install Ansible. The offical docs can be found [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#prerequisites-installing-pip).

```bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

**✅ Step 1c: AWS setup.** 

For this next step we will need to install unzip

```bash
sudo apt install unzip
```

Lastly we will install and configure the AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Once we have the CLI we will need to setup a number of values to allow us to access our AWS account from the tools.  We will use the configure command to start this process

To get the creds used in the configure command Follow [this link](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)

```bash
aws configure
```

Following the prompts on this command will produce a file at ~/.aws/ named credentials.  An example file has been included in the repo if you want to take a look.

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

Lasly we will need to go into the AWS market place and accept the license agreement for the image we will be using.  To do that we will need to navigate [here](https://aws.amazon.com/marketplace/pp?sku=47k9ia2igxpcce2bzo8u3kj03).


**✅ Step 1d: ssh key setup.** 

In order to have access to the boxes once they are deployed we will need to generate an ssh key pair to use. 

```bash
ssh-keygen -t rsa -f ./id_rsa
```

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

## 2. Running the scripts

**✅ Step 2a: Look in the output.tf** 

Open up output.tf and notice the Asnsible jobs triggering with the values from that result for the Terraform job.  This is the "hook" we will use to configure everything on our deployment. 

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

**✅ Step 2b: First deployment** 

On our first run of Terraform we will need to initilize everything. 

```bash 
terraform init
```

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

To run the script we will use the terraform apply.

```bash 
terraform apply
```

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

## 3. Resources
For further reading and labs go to: 

[Github](https://github.com/MayaLearning) 

[Discord](https://discord.gg/kkDTVQwJSN) 

[YouTube](https://www.youtube.com/channel/UCesdrOv6jbT8WyShLgAjoIw) 
