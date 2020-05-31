#!/usr/bin/env bash

###############################################################################
# Install picture-upload prerequisites to Amazon Linux EC2 instance
###############################################################################

# Update all installed packages
sudo yum update -y

# Install docker and git
sudo yum install -y docker git

# Install additional development tools, i.e. gcc, make, etc.
sudo yum groupinstall -y 'Development Tools'

# Start the Docker service
sudo service docker start

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose

# Make docker-compose executable
sudo chmod +x /usr/local/bin/docker-compose

# Install Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.bashrc

# Install Node.js 6.x (yes, this is old)
nvm install 6

# Install Go 1.11
wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
tar xvf go1.11.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo mv go /usr/local
rm -rf go
rm -f go1.11.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

# Add current user to docker group
sudo usermod -a -G docker $USER
echo -e "\n>>> You must log out and log back in for docker commands to work as $USER.\n"

# Terraform
sudo yun install unzip wget -y
wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
unzip terraform_0.12.26_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform

#terraformando

git clone https://github.com/msfidelis/terraformando-eks.git
cd terraformando-eks
terraform init
terraform apply --auto-approve


# Criando repositório ECR para imagens
aws ecr create-repository --repository-name photo-filter
aws ecr create-repository --repository-name photo-storage
aws ecr create-repository --repository-name web-client

# Build das Imagens-Docker
cd ~/environment/eks-deep-dive-2019/picture-upload
make install

cd ~/environment/eks-deep-dive-2019/picture-upload/apps
go build


cd /home/ec2-user/environment/eks-deep-dive-2019/picture-upload
docker-compose up
