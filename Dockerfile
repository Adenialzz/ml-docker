FROM ubuntu:20.04

ARG CUDA_VERSION=11.7
ARG PYTHON_VERSION=3.10
ARG TORCH_VERSION=1.13
ARG TORCHVISION_VERSION=0.14.0
ARG INSTALL_NVIM=true

SHELL [ "/bin/bash", "-l", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    echo "Asia/Shanghai" > /etc/timezone

RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list &&\
	sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list &&\
	apt update &&\
	apt install -f -y vim curl sudo zsh unzip openssh-server openssh-client git &&\
	apt clean

COPY prepare/* /root/

# prepare ssh
RUN mkdir /root/.ssh &&\
	mv /root/id_rsa.pub /root/.ssh/authorized_keys &&\
	service ssh start

# setup zsh
EXPOSE 22
RUN unzip /root/ohmyzsh-master.zip -d /root/ohmyzsh-master &&\
	mv /root/ohmyzsh-master/ohmyzsh-master /root/.oh-my-zsh/ &&\
	rm -r /root/ohmyzsh-master /root/ohmyzsh-master.zip &&\
	echo "export ZSH=/root/.oh-my-zsh/" >> /root/.bashrc &&\
	echo "/bin/zsh" >> /root/.bashrc &&\
	cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc &&\
	mv /root/alias.sh /root/.bash_alias &&\
	echo "source /root/.bash_alias" >> /root/.zshrc &&\
	sed -i s/"plugins=(git)"/"plugins=(vi-mode git)"/g /root/.zshrc

# setup conda
RUN chmod +x /root/Miniconda3.sh &&\
	/root/Miniconda3.sh -b -p /opt/miniconda &&\
	rm /root/Miniconda3.sh &&\
	/opt/miniconda/bin/conda init zsh &&\
	/opt/miniconda/bin/conda init bash &&\
	/opt/miniconda/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple; \
	/opt/miniconda/bin/conda create -y -n JJ_env python=${PYTHON_VERSION} &&\
	/opt/miniconda/bin/conda install -n JJ_env -y pytorch==${TORCH_VERSION} torchvision==${TORCHVISION_VERSION} cudatoolkit=${CUDA} -c pytorch &&\
	/opt/miniconda/bin/conda clean -a -y

# setup nvim
RUN apt install -y neovim nodejs npm &&\
	npm install yarn@latest -g &&\
	curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&\
	mkdir -p /root/.config/nvim &&\
	mv /root/init.vim /root/.config/nvim

