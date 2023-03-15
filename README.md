# ml-docker

## Introduction

It is very cumbersome for machine learning researchers and developers to repeatedly configure their familiar development environment on each different machine, and sometimes there will be version incompatibility. ml-docker is committed to solving this problem. Based on **Docker** technology, researchers/developers can package the running environment in a container to run in the cloud server cluster conveniently and quickly. ml-docker can greatly improve the efficiency of research/development, reduce human errors and environmental inconsistencies, and also save maintenance costs, so that researchers/developers can focus more on machine learning algorithms without too much concern about the development environment.

## Usage

1. **install and run nvidia docker**

    ```shell
    export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
    wget -O- https://get.docker.com/ | sh
    service docker start
    ```

    if nvidia-docker is not installed, nvidia device is not supported by docekr itself, you should copy the following script to anywhere of your machine:

    ```bash
    # nvidia-container-runtime-script.sh
    
    sudo curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
      sudo apt-key add -
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    sudo curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
      sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
    sudo apt-get update
    ```

    and execute it to install nvidia docker:

    ```shell
    sudo sh nvidia-container-runtime-script.sh && apt-get install nvidia-container-runtime
    ```

2. **clone this repo**

    ```shell
    git clone https://github.com/Adenialzz/ml-docker.git
    ```

3. **prepare necessary files**

    ```shell
    cd ml-docker/prepare
    wget https://mirrors.bfsu.edu.cn/anaconda/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh -O Miniconda3.sh		# for building miniconda
    cp ~/.ssh/id_rsa.pub id_rsa.pub		# for ssh public key login
    wget https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip -O ohmyzsh-master.zip		# for building ohmyzsh
    ```

    edit `prepare/init.vim` and `prepare/alias.sh` as you like to meet your customized requirement.

4. **build docker image**

    ```shell
    # at ml-docker dir
    docker build --build-arg INSTALL_NVIM=true --progress=plain --tag ubuntu-song:20.04 .
    ```

5. **run docker image**

    ```shell
    docker compose up
    ```

6. **ssh to the container (in another terminal) and start developing with your familiar envionment**

    firstly, add the following content to  `~/.ssh/config`, to config ssh public key to the container:

    ```shell
    Host 127.0.0.1
      HostName 127.0.0.1
      User root
      PreferredAuthentications publickey
      IdentityFile /home/ps/.ssh/id_rsa
    ```

    and ssh to the container with public key (no password required):

    ```shell
    ssh root@127.0.0.1 -p 3232
    ```

    you will enter a zsh shell, and you can start developing.

    

## Notes

**build args**

you can use `--build-arg` option to switch python version / pytorch version etc. like this:

```shell
docker build --build-arg INSTALL_NVIM=true --build-arg PYTHON_VERSION=3.10 --progress=plain --tag ubuntu-song:20.04 .
```

**others**

you can fully customize Dockerfile to build your familiar developing environment, this repo just provides an example of building machine learning environment with docker.
