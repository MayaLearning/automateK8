# How to Automate Your Kubernetes Deployment

##  DISCRIPTION HERE
In this session we will use Terraform and Ansible to setup a Kubernetes cluster in the cloud.  This is an intesnive hands on session for people who want to learn these technologies.

## Before starting
You will need access to your own AWS account.  AWS has some free offerings that would work for this.  You will also need to have a computer capible of running both Terraform and Ansible.  Our examples here will be done in linux but should be roughly the same steps in other opperating systems.  

## Table of content and resources

* [Workshop On YouTube](YOUTUBE LINK HERE)
* [Presentation](PDF OF SLIDES HERE)
* [Discord chat](DISCORD LINK HERE)

| Title  | Description
|---|---|
| **1 - Installation and configuration** | [Instructions](#Installation-and-configuration)  |
| **2 - Part 2** | [Instructions](#Part-2)  |
| **3 - Resources** | [Instructions](#Resources)  |

## 1. Installation and configuration

Description of the first section what we are going to try and do.

**✅ Step 1a: Download Terraform.** 
Navigate to https://www.terraform.io/downloads.html and download the distrabution that matches the computer you are working with. 

**✅ Step 1b: Install Terraform.** 
In Linux we can simply add the hashicorp repositories so we can use our package manager to do the installation for us.  
Offical docs can be found [here](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

```bash 
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

Now that we have added the correct repo we can run the installation.

```bash
sudo apt-get update && sudo apt-get install terraform
```



**✅ Step 1a: Ansible setup.** 

**✅ Step 1a: AWS setup.** 



```bash
Command to run
```

*📃output*
```bash
Output from the above command     
```
Screenshot of the above working
<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

## 2. Part 2

**✅ Step 2a: The first step in the section.**
**✅ Step 2b: Second step in the section**

## 3. Resources
For further reading and labs go to 
[link name](URL) 
