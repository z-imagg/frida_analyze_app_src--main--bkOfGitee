#!/usr/bin/bash +x

#【描述】  
#【依赖】   
#【术语】 
#【备注】   
#【运行环境】 
#    1. 此脚本 被Dockerfile的RUN命令调用  , 则运行在 Ubuntu Jammy Jellyfish 下
#    2. 此脚本 在宿主机ubuntu22.04下运行

#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e

mkdir -p /app/pack/ /app/

# #region 基础头
shopt -s expand_aliases

#   #region 开发体

chmod +x /dockerBuildROOT/fridaAnlzAp/main/docker/*.sh

source /dockerBuildROOT/fridaAnlzAp/main/docker/file_web_srv.sh
source /dockerBuildROOT/fridaAnlzAp/main/docker/util.sh
source /dockerBuildROOT/fridaAnlzAp/main/docker/local_domain.sh

#判定当前 是在docker实例中 还是 在 宿主物理机 中 
isInDocker # 返回变量为 inDocker

#开发用，本地文件下载web服务
# 物理机下才 启动 本地文件下载web服务
$inDocker || {  kill_file_web_srv  ;  boot_file_web_srv  ;}
#本地文件下载web服务 url主要部分 ， 172.17.0.1 是 物理真实宿主机 ip
LocalFileWebSrv=http://172.17.0.1:2111

#   #endregion

F_dl_unpkg_sh=/tmp/download_unpack.sh
wget --quiet --output-document=$F_dl_unpkg_sh http://giteaz:3000/bal/bash-simplify/raw/branch/app_spy/dev/download_unpack.sh
# http://giteaz:3000/bal/bash-simplify/raw/commit/83e2651a5c5dc95ebe2a1331c410742617680e2b/download_unpack.sh
chmod +x $F_dl_unpkg_sh

#Dockfile构建过程中需要的miniconda3 下载、安装、使用
Conda3_Home_4dockerbuild=/Miniconda3-py310_22.11.1-1/
F="Miniconda3-py310_22.11.1-1-Linux-x86_64.sh" ; $F_dl_unpkg_sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/$F e01420f221a7c4c6cde57d8ae61d24b5  $F /tmp/ /not_unpack  $LocalFileWebSrv/$F  ; unset F
bash  /tmp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p $Conda3_Home_4dockerbuild

# ls / /tmp  $Conda3_Home_4dockerbuild ; exit 1  #提前结束，常用来 调试Dockerfile用

source  $Conda3_Home_4dockerbuild/bin/activate 

which python #/app/Miniconda3-py310_22.11.1-1/bin/python
ls   $Conda3_Home_4dockerbuild #


# #endregion


# #region 软件包 安装、配置

echo "welcome to my_env_prepare"

#   #region nvm克隆、nvm函数导入、nvm安装nodejs-v18.19.1
#nvm克隆
git clone --branch=v0.39.7   https://gitee.com/repok/nvm-sh--nvm.git  /app/nvm

#nvm函数导入
source /app/nvm/nvm.sh 1>/dev/null 2>/dev/null

#nvm安装nodejs-v18.19.1
#  v18.19.1 是 nodejs  LTS v18 系列 中 最后一个版本
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
# NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm  ls-remote | grep v18. | grep LTS
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm install v18.19.1  1>/dev/null 2>/dev/null
#   #endregion

#   #region 下载包 、 解压包 , miniconda3 、 neo4j-4.4.32 、 jdk11  、 neo4j的apoc插件

#下载安装包们
/dockerBuildROOT/fridaAnlzAp/main/docker/dl_pack.sh

#miniconda的安装目录和使用目录要保持一致，否则无法使用
bash  /app/pack/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p /app/Miniconda3-py310_22.11.1-1/

# ls /app/pack/ /app
#   #endregion

#   #region 配置包 , miniconda3 、 neo4j-4.4.32 、 jdk11  、 neo4j的apoc插件

#miniconda3
# miniconda的安装目录和使用目录要保持一致，否则无法使用
source /app/Miniconda3-py310_22.11.1-1/bin/activate

#jdk11 
export JAVA_HOME=/app/zulu11.70.15-ca-jdk11.0.22-linux_x64

#neo4j-4.4.32
export NEO4J_HOME=/app/neo4j-community-4.4.32

export PATH=$PATH:$NEO4J_HOME/bin:$JAVA_HOME/bin

#neo4j配置为 监听0.0.0.0 、 4个工作线程
neo4j --help
# console start   stop    restart status  version help 
neo4j version #neo4j 4.4.32
F_cfg=/app/neo4j-community-4.4.32/conf/neo4j.conf
grep dbms.default_listen_address $F_cfg
grep dbms.memory $F_cfg
cp -v $F_cfg "${F_cfg}_$(date +%s)"
#修改 neo4j 监听地址为0.0.0.0
sed -i  "s/#dbms.default_listen_address=0.0.0.0/dbms.default_listen_address=0.0.0.0/g"  $F_cfg
#修改 neo4j 线程数目为 4 
sed -i  's/#dbms.threads.worker_count=/dbms.threads.worker_count=4/'   $F_cfg
echo """
neo4j重启 : neo4j restart ; neo4j状态 : neo4j status; 启动neo4j: neo4j start
浏览器打开 neo4j的web控制端 http://ip:7474/browser/
neo4j-community-4.4.32默认用户名密码 neo4j/neo4j
web端修改密码, 输入命令 ':server change-password'
"""

#   #endregion


#{nodejs依赖安装
# (cd /fridaAnlzAp/frida_js/ && npm install )
#}


# #endregion


# #region 结尾
cp -v /dockerBuildROOT/fridaAnlzAp/main/docker/.bashrc /root/.bashrc
# #endregion



