# Ansible
  We have two roles here
  1. Tomcat - Install, configure and start tomcat server 
  2. deploywar - Deploy application war file from S3 bucket
  
### Pre-requisite
  Create an *ec2-s3* role in AWS which will help us to download files from S3 to EC2 instances
  
### Install ansible in Amazon Linux2
  sudo amazon-linux-extras install ansible2

### Set environment variables
  export AWS_ACCESS_KEY_ID='<AWS ACCESS KEY>' </br>
  export AWS_SECRET_ACCESS_KEY='<AWS SECRET ACCESS KEY>'

### List of aws ec2 instances in groups
  ansible-inventory -i aws_ec2.yml --graph </br>
  ansible-inventory -i aws_ec2.yml --list

### Execute ansible playbook to install, configure and deploy tomcat and war file 
  ansible-playbook -i aws_ec2.yml site.yml -e "ansible_user=ec2-user passed_in_hosts=<host or group name> ARTIFACT_VERSION=<path of the file in s3 bucket>" </br>
  Example: ansible-playbook -i aws_ec2.yml site.yml -e "ansible_user=ec2-user passed_in_hosts=tag_my_app_asg ARTIFACT_VERSION=81f8102d-c371-4991-bf51-669d3e2d903b"
  
# Terraform

### 1. Install ansible in Amazon Linux2
wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
 
#### Unzip the package
unzip terraform_0.11.13_linux_amd64.zip
 
#### Move the package to /usr/local/bin
sudo mv terraform /usr/local/bin/ && rm terraform_0.11.13_linux_amd64.zip
 
#### Check if terraform working properly
terraform --version
 
#### Get help
terraform
terraform <command> --help

### 2. change to terraform directory
cd terraform

### 3. Initialize terraform (download's provider [AWS] packages)
terraform init
 
### 4. Create the terraform plan
terraform plan
 
### 5. Create the resources, type yes when prompted (creates a VPC named myvpc in AWS)
terraform apply
