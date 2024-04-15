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

# #region 基础头
# shopt -s expand_aliases
# echo -n "PWD="; pwd ; ls /fridaAnlzAp/main/docker/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh; set +x;  echo "DEBUG=$-";  exit 1 #调试用，在脚本中间退出，免去大量日志
#PWD=/;  ; DEBUG=hB

# docker的RUN命令运行在另一个操作系统中，该操作系统 基于 Ubuntu Jammy Jellyfish 名为  buildkitsandbox
# echo -n "PYTHON="; which python ; exit 0
# 无python

# echo -n "uname="; uname -a ; exit 0
# Linux buildkitsandbox 6.5.0-27-generic #28~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Fri Mar 15 10:51:06 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

# echo -n "/etc/issue:"; cat /etc/issue ; exit 0
# #/etc/issue:  Ubuntu Jammy Jellyfish (development branch) \n \l

# apt search --names-only python; which python; exit 0
# apt install -y python3; which python3; ln -s `which python3` /usr/bin/python; #exit 0

# #region 开发体

#开发用，本地文件下载web服务
# 物理机下才 启动 本地文件下载web服务
$inDocker || {  { kill -9 $(ps auxf | grep python | grep 2111 | awk '{print $2}')  && sleep 1 ;}  ;  ( cd /app/pack/ && python -m http.server 2111 & ) ;}
#本地文件下载web服务 url主要部分
LocalFileWebSrv=http://172.17.0.1:2111

# #endregion


# 若在docker下 根目录为 /dockerBuildROOT/ 否则 根目录为 /
{ $inDocker && { RT=/dockerBuildROOT  ;} ;} || RT="/"
#&& mkdir -p $RT


F_dl_unpkg_sh=/tmp/download_unpack.sh
wget --quiet --output-document=$F_dl_unpkg_sh http://giteaz:3000/bal/bash-simplify/raw/branch/app_spy/dev/download_unpack.sh
# http://giteaz:3000/bal/bash-simplify/raw/commit/83e2651a5c5dc95ebe2a1331c410742617680e2b/download_unpack.sh
chmod +x $F_dl_unpkg_sh


mkdir -p $RT/app/pack/ $RT/app/

#Dockfile构建过程中需要的miniconda3 下载、安装、使用
Conda3_Home_4dockerbuild=$RT/Miniconda3-py310_22.11.1-1/
F="Miniconda3-py310_22.11.1-1-Linux-x86_64.sh" ; $F_dl_unpkg_sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/$F e01420f221a7c4c6cde57d8ae61d24b5  $F /tmp/ /not_unpack  $LocalFileWebSrv/$F  ; unset F
bash  /tmp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p $Conda3_Home_4dockerbuild
# exit 1
# ls / /tmp $RT $Conda3_Home_4dockerbuild
source  $Conda3_Home_4dockerbuild/bin/activate ;  #exit 0

which python #/app/Miniconda3-py310_22.11.1-1/bin/python
ls   $Conda3_Home_4dockerbuild #

# apt install -y python3-pip; pip show urllib3; #exit 0

# #region cytoscape 运行在宿主机上
rootFsType=$(findmnt -n -o FSTYPE /)
#若根目录挂载的文件系统类型为overlay, 则当前极有可能在docker下
inDocker=$( { [[ "$rootFsType" == "overlay" ]] && echo "true" ;} || echo "false"  )


# #endregion


# #region 业务体

echo "welcome to my_env_prepare"

# #region nvm克隆、nvm函数导入、nvm安装nodejs-v18.19.1
#nvm克隆
git clone --branch=v0.39.7   https://gitee.com/repok/nvm-sh--nvm.git  $RT/app/nvm

#nvm函数导入
source $RT/app/nvm/nvm.sh 1>/dev/null 2>/dev/null

#nvm安装nodejs-v18.19.1
#  v18.19.1 是 nodejs  LTS v18 系列 中 最后一个版本
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
# export PATH=/app/bin:$PATH
# NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm  ls-remote | grep v18. | grep LTS
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm install v18.19.1  1>/dev/null 2>/dev/null
# #endregion

# #region 下载包 、 解压包 , miniconda3 、 neo4j-4.4.32 、 jdk11  、 neo4j的apoc插件

mkdir -p $RT/app/pack/ $RT/app/ 

#下载安装包们
RT=$RT bash dl_pack.sh

#conda安装目录后 目录不能移动，因此才做的软链接。 TODO, 待验证
ln -s $RT/app /app
bash  $RT/app/pack/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p /app/Miniconda3-py310_22.11.1-1/

ls $RT/app/pack/ $RT/app
# #endregion

# #endregion

# #region 配置包 , miniconda3 、 neo4j-4.4.32 、 jdk11  、 neo4j的apoc插件

#miniconda3
source $RT/app/Miniconda3-py310_22.11.1-1/bin/activate

#jdk11 
export JAVA_HOME=$RT/app/zulu11.70.15-ca-jdk11.0.22-linux_x64

#neo4j-4.4.32
export NEO4J_HOME=$RT/app/neo4j-community-4.4.32

export PATH=$PATH:$NEO4J_HOME/bin:$JAVA_HOME/bin

#neo4j配置为 监听0.0.0.0 、 4个工作线程
neo4j --help
# console start   stop    restart status  version help 
neo4j version #neo4j 4.4.32
F_cfg=$RT/app/neo4j-community-4.4.32/conf/neo4j.conf
grep dbms.default_listen_address $F_cfg
grep dbms.memory $F_cfg
cp -v $F_cfg "${F_cfg}_$(date +%s)"
#修改 neo4j 监听地址为0.0.0.0
sed -i  "s/#dbms.default_listen_address=0.0.0.0/dbms.default_listen_address=0.0.0.0/g"  $F_cfg
#修改 neo4j 线程数目为 4 
sed -i  's/#dbms.threads.worker_count=/dbms.threads.worker_count=4/'   $F_cfg
echo """
#neo4j重启
neo4j restart
#neo4j状态
neo4j status

#启动neo4j
neo4j start


#浏览器打开 neo4j的web控制端 http://ip:7474/browser/
#neo4j-community-4.4.32默认用户名密码 neo4j/neo4j
#web端修改密码, 输入命令 ':server change-password'
"""

# #endregion

# #endregion








# #region 项目代码拉取

#本地gitea服务器. 当文件系统是只读时，tee可能会写入了 但还是报错， 因此放入'子进程()'中 避免干扰此脚本
( echo "10.0.4.9 westgw giteaz g" | tee -a /etc/hosts )

#本项目fridaAnlzAp 代码拉取
mkdir -p $RT/fridaAnlzAp/
git clone http://giteaz:3000/frida_analyze_app_src/main.git  $RT/fridaAnlzAp/main
#递归拉取所有子模块
( cd $RT/fridaAnlzAp/main &&  git submodule    update --recursive --init )

cd $RT/fridaAnlzAp/
#删除软链接
find  .  -maxdepth 1 -type l | xargs -I% unlink %
#直接子模块 或 app 链接到 上层目录
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/x
ln -s  ./main/analyze_by_graph  ./analyze_by_graph
ln -s ./main/cmd-wrap  ./cmd-wrap
ln -s ./main/frida_js   ./frida_js
ln -s  ./main/github-gitee-GITEA   ./github-gitee-GITEA
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/app/x
ln -s ./main/app/cgsecurity--testdisk   ./cgsecurity--testdisk
ln -s ./main/app/torch-cpp  ./torch-cpp


# #endregion


# #region 项目依赖安装
#{python依赖安装
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install -r $RT/fridaAnlzAp/cmd-wrap/requirements.txt
pip install -r $RT/fridaAnlzAp/frida_js/requirements.txt
pip install -r $RT/fridaAnlzAp/analyze_by_graph/requirements.txt
#}

#{nodejs依赖安装
# (cd $RT/fridaAnlzAp/frida_js/ && npm install )
#}

# #endregion





