# How to Automate Your Kubernetes Deployment

In this session we will use Terraform and Ansible to setup a Kubernetes cluster in the cloud.  This is an intesnive hands on session for people who want to learn these technologies.

## Before starting
You will need access to your own AWS account.  AWS has some free offerings that would work for this.  You will also need to have a computer capible of running both Terraform and Ansible.  Our examples here will be done in linux but should be roughly the same steps in other opperating systems.  

## Table of content and resources

| Title  | Description
|---|---|
| **1 - Getting Connected** | [Instructions](#1-Getting-Connected)  |
| **2 - Installation and configuration** | [Instructions](#1-Installation-and-configuration)  |
| **3 - Running the scripts** | [Instructions](#2-Running-the-scripts)  |
| **4 - Resources** | [Instructions](#3-Resources)  |


## 1. Getting Connected
**✅ Step 1a: The first step in the section.**

In your browser window, navigate to the url <YOURADDRESS>:3000 where your address is the one provided by Prasson.
  
When you arrive at the webpage you should be greeted by something similar to this.
<img src="https://user-images.githubusercontent.com/1936716/107884421-a23fe180-6eba-11eb-96d2-4c703ccb1dcf.png" width=“700” />

Click in the `Terminal` menu from the top of the page and select new terminal as shown below
<img src="https://user-images.githubusercontent.com/1936716/107884506-09f62c80-6ebb-11eb-9f7b-42bdb3444cc1.png" width=“700” />



## 2. Installation and configuration

Description of the first section what we are going to try and do.

**✅ Step 2a: Terraform Setup.** 

In Linux we can simply add the hashicorp repositories so we can use our package manager to do the installation for us.  Offical docs can be found [here](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

```bash 
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

<img src="https://user-images.githubusercontent.com/1936716/115484364-50983800-a218-11eb-8de2-fff4b8e424d1.PNG" width=“700” />

Now that we have added the correct repo we can run the installation.

```bash
sudo apt-get update && sudo apt-get install terraform
```

<img src="https://user-images.githubusercontent.com/1936716/115484457-77566e80-a218-11eb-8a89-638eb4f53524.PNG" width=“700” />

To verify the installation we can run the following command

```bash 
terraform -help
```
<img src="https://user-images.githubusercontent.com/1936716/115484588-ab319400-a218-11eb-804f-7389cde3c03d.PNG" width=“700” />

**✅ Step 2b: Ansible setup.** 

If you are running on a Ubuntu box you can run the following commands to install Ansible. The offical docs can be found [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#prerequisites-installing-pip).  When prompted make sure to enter a capital Y to confirm that you would like to install ansible.

```bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

Ommited output for the above as we will verify the install 

```bash
ansible --help
```

<img src="https://user-images.githubusercontent.com/1936716/115484920-475b9b00-a219-11eb-8ff0-09e8679e97cc.PNG" width=“700” />

**✅ Step 2c: AWS setup.** 

For this next step we will need to install unzip

```bash
sudo apt install unzip
```

<img src="https://user-images.githubusercontent.com/1936716/115484997-740fb280-a219-11eb-8d44-3fc8fcdbc2aa.PNG" width=“700” />

Lastly we will install and configure the AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Output ommited as we can verify the install worked with the following 

```bash
/usr/local/bin/aws --version
```

<img src="https://user-images.githubusercontent.com/1936716/115485131-b46f3080-a219-11eb-8d4f-6054b0dc6382.PNG" width=“700” />

Once we have the CLI we will need to setup a number of values to allow us to access our AWS account from the tools.  We will use the configure command to start this process

To get the creds used in the configure command Follow [this link](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)

```bash
aws configure
```

Following the prompts on this command will produce a file at ~/.aws/ named credentials.  An example file has been included in the repo if you want to take a look.


**✅ Step 1d: ssh key setup.** 

In order to have access to the boxes once they are deployed we will need to generate an ssh key pair to use. 

```bash
ssh-keygen -t rsa -f ./id_rsa
```

<img src="https://user-images.githubusercontent.com/1936716/115485287-057f2480-a21a-11eb-948e-c03ba32c4c89.PNG" width=“700” />

## 3. Running the scripts

**✅ Step 3a: Look in the output.tf** 

Open up output.tf and notice the Asnsible jobs triggering with the values from that result for the Terraform job.  This is the "hook" we will use to configure everything on our deployment. 

**✅ Step 3b: First deployment** 

On our first run of Terraform we will need to initilize everything. 

```bash 
terraform init
```

<img src="https://user-images.githubusercontent.com/1936716/115485375-33646900-a21a-11eb-9f61-e1ef3fd85ccb.PNG" width=“700” />

To run the script we will use the terraform apply.

```bash 
terraform apply
```

<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

## 4. Resources
For further reading and labs go to: 

[Github](https://github.com/MayaLearning) 

[Discord](https://discord.gg/kkDTVQwJSN) 

[YouTube](https://www.youtube.com/channel/UCesdrOv6jbT8WyShLgAjoIw) 
