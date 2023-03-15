# 使用docker构建自己的机器学习开发环境

## 引言

对于机器学习研究人员和开发人员来说，在每台不同的机器上重复配置自己熟悉的开发环境是非常麻烦的，有时还会出现版本不兼容的问题。ml docker致力于解决这个问题。基于**Docker**技术，研究者/开发者可以将运行环境打包在一个容器中，方便快捷地在云服务器集群中运行。ml-docker可以大大提高研究/开发的效率，减少人为错误和环境不一致性，还可以节省维护成本，这样研究者/开发者可以更加专注于机器学习算法，而不必过于关注开发环境。

## 使用方法

1. **安装并运行 nvidia-docker**

    ```shell
    export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
    wget -O- https://get.docker.com/ | sh
    service docker start
    ```

    如果机器尚未安装 nvidia-docker，docker 本身不支持英伟达显卡设备，首先将如下脚本复制到机器的任意位置：

    ```bash
    # nvidia-container-runtime-script.sh
    
    sudo curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
      sudo apt-key add -
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    sudo curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
      sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
    sudo apt-get update
    ```

    然后运行并安装 nvidia-docker：

    ```shell
    sudo sh nvidia-container-runtime-script.sh && apt-get install nvidia-container-runtime
    ```

2. **复制本仓库**

    ```shell
    git clone https://github.com/Adenialzz/ml-docker.git
    ```

3. **准备必要的文件**

    ```shell
    cd ml-docker/prepare
    wget https://mirrors.bfsu.edu.cn/anaconda/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh -O Miniconda3.sh		# for building miniconda
    cp ~/.ssh/id_rsa.pub id_rsa.pub		# for ssh public key login
    wget https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip -O ohmyzsh-master.zip		# for building ohmyzsh
    ```

    按需编辑 `prepare/init.vim` 和 `prepare/alias.sh` ，构建自己熟悉的开发环境选项

4. **构建 docker 镜像**

    ```shell
    # at ml-docker dir
    docker build --build-arg INSTALL_NVIM=true --progress=plain --tag ubuntu-song:20.04 .
    ```

5. 运行 docker 镜像

    ```shell
    docker compose up
    ```

6. **ssh 连接（在另一个终端中）到启动的容器，然后即可在熟悉的环境中进行开发**

    首先，将以下内容添加到  `~/.ssh/config`，来配置 ssh 公钥：

    ```shell
    Host 127.0.0.1
      HostName 127.0.0.1
      User root
      PreferredAuthentications publickey
      IdentityFile /home/ps/.ssh/id_rsa
    ```

    然后即可 ssh 到容器内（无需密码）：

    ```shell
    ssh root@127.0.0.1 -p 3232
    ```

    你应该进入到一个 zsh 终端，然后就可以愉快地开发啦！

    

## 注意

**构建参数**

可以通过 `--build-arg` 选项来修改 python 版本 / pytorch 版本等，比如像这样：

```shell
docker build --build-arg INSTALL_NVIM=true --build-arg PYTHON_VERSION=3.10 --progress=plain --tag ubuntu-song:20.04 .
```

**其他**

本仓库只是提供一个通过 docker 构建机器学习开发环境的示例，你可以按照自己的需求完全定制 Dockerfile，来构建自己熟悉的开发环境。