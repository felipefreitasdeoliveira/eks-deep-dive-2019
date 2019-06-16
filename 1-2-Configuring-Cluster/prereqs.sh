#!/usr/bin/env bash

# * Configuração do manager com os pré requisitos para gestão do EKS.
# * AMI CentOS7
# * kubectl
# * aws-iam-authenticator
# * AWS CLI
# 
# # # # # # # # # # # # # # NOTA IMPORTANTE # # # # # # # # # # # # # # # # # # # # # # # # 
#
# # Antes de Continuar faça a instalação dos Scripts : Centos7 Essencial e CW_CustomMetrics
#
#
# # # # # # # # # # # # # # NOTA IMPORTANTE # # # # # # # # # # # # # # # # # # # # # # # # 


set -e

mkdir -p $HOME/bin
echo 'export PATH=$HOME/bin:$PATH' >>~/.bashrc

# Instala o  kubectl, if absent
if ! type kubectl >/dev/null 2>&1; then
	curl -o "kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/$(uname -s)/amd64/kubectl"
	chmod +x ./kubectl
	cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
	echo 'kubectl installed'
else
	echo 'kubectl already installed'
fi

# Instala o aws-iam-authenticator
if ! type aws-iam-authenticator >/dev/null 2>&1; then
	curl -o aws-iam-authenticator "https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/$(uname -s)/amd64/aws-iam-authenticator"
	chmod +x ./aws-iam-authenticator
	cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
	echo 'aws-iam-authenticator installed'
else
	echo 'aws-iam-authenticator already installed'
fi

# Instala o AWS CLI
if ! type aws >/dev/null 2>&1; then
	curl -o awscli-bundle.zip https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
	unzip awscli-bundle.zip
	./awscli-bundle/install -b $HOME/bin/aws
	echo 'AWS CLI installed'
else
	echo 'AWS CLI already installed'
fi

# Instala o eksctl
if ! type eksctl >/dev/null 2>&1; then
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	mv /tmp/eksctl $HOME/bin
	echo 'eksctl installed'
else
	echo 'eksctl already installed'
fi

# Instala o kubectx/kubens
if ! type kubectx >/dev/null 2>&1; then
	sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
	sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
	echo 'kubectx installed'
else
	echo 'kubectx already installed'
fi

# Testando se o AWS credentials existi no path do linux
aws sts get-caller-identity
