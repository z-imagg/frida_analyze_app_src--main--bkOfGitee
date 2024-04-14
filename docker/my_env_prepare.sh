#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

# #region 基础头
shopt -s expand_aliases

function get_bash_en_dbg() {
  bash_en_dbg=false; [[ $- == *x* ]] && bash_en_dbg=true #记录bash是否启用了调试模式
}

wget --quiet --output-document=download_unpack.sh http://giteaz:3000/bal/bash-simplify/raw/commit/5b9656e7bcf10b4d187eef6fcebaab627089160f/download_unpack.sh
chmod +x download_unpack.sh

#去此脚本所在目录
declare -r f=$(readlink -f ${BASH_SOURCE[0]})  ; declare -r d=$(dirname $f)
cd $d

# #endregion


# #region 开发体

#开发用，重启宿主机的web服务
{ kill -9 $(ps auxf | grep python3 | grep 2111 | awk '{print $2}')  && sleep 1 ;}  ;  ( cd /app/pack/ && python3 -m http.server 2111 & )

# #endregion

# #region 业务体

echo "welcome to my_env_prepare"


# #region nvm克隆、nvm函数导入、nvm安装nodejs-v18.19.1
#nvm克隆
git clone --branch=v0.39.7   https://gitee.com/repok/nvm-sh--nvm.git  /app/nvm

#nvm函数导入
get_bash_en_dbg  ;  $bash_en_dbg && set +x 
source /app/nvm/nvm.sh
$bash_en_dbg && set -x

#nvm安装nodejs-v18.19.1
#  v18.19.1 是 nodejs  LTS v18 系列 中 最后一个版本
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
# export PATH=/app/bin:$PATH
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm  ls-remote | grep v18. | grep LTS
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm install v18.19.1
# #endregion

# #region 下载包 、 解压包 , miniconda3 、 neo4j-4.4.32 、 jdk11  、 neo4j的apoc插件

#miniconda3
F="Miniconda3-py310_22.11.1-1-Linux-x86_64.sh" ; ./download_unpack.sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/$F e01420f221a7c4c6cde57d8ae61d24b5  $F /app/pack/ /app/  http://172.17.0.1:2111/$F ; unset F

#neo4j-4.4.32
F="neo4j-community-4.4.32-unix.tar.gz" ; ./download_unpack.sh https://neo4j.com/artifact.php?name=$F a88d5de65332d9a5acbe131f60893b55  $F /app/pack/ /app/  http://172.17.0.1:2111/$F ; unset F

#neo4j-4.4.32需要的jdk11
F="zulu11.70.15-ca-jdk11.0.22-linux_x64.tar.gz" ; ./download_unpack.sh https://cdn.azul.com/zulu/bin/$F f13d179f8e1428a3f0f135a42b9fa75b  $F /app/pack/ /app/  http://172.17.0.1:2111/$F ; unset F

#neo4j安装apoc插件
F="apoc-4.4.0.26-all.jar" ; ./download_unpack.sh https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.4.0.26/$F 5a42a32e12432632124acd682382c91d  $F /app/pack/ /app/  http://172.17.0.1:2111/$F ; unset F

# #endregion

# #region cytoscape 运行在宿主机上
rootFsType=$(findmnt -n -o FSTYPE /)
#若根目录挂载的文件系统类型为overlay, 则当前极有可能在docker下。 docker下 不安装cytoscape，因为很麻烦
[[ "$rootFsType" == "overlay" ]] || { \

# #region 物理机中安装 cytoscape
# https://github.com/cytoscape/cytoscape/releases/tag/3.10.2

# cytoscape-3.10.2
F="cytoscape-unix-3.10.2.tar.gz" ; ./download_unpack.sh https://github.com/cytoscape/cytoscape/releases/download/3.10.2/$F a6b5638319b301bd25e0e6987b3e35fd  $F /app/pack/ /app/  http://172.17.0.1:2111/$F ; unset F

# cytoscape-3.10.2需要的jdk17
F="zulu17.48.15-ca-jdk17.0.10-linux_x64.tar.gz" ; ./download_unpack.sh https://cdn.azul.com/zulu/bin/$F bb826d2598b6ceaaae56a6c938f2030e  $F /app/pack/ /app/  http://172.17.0.1:2111/$F ; unset F

# #endregion


;}
# #endregion

# #region 配置包 , miniconda3 、 neo4j-4.4.32 、 jdk11  、 neo4j的apoc插件

#miniconda3
get_bash_en_dbg  ;  $bash_en_dbg && set +x 
source /app/Miniconda3-py310_22.11.1-1/bin/activate
$bash_en_dbg && set -x

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

#本地gitea服务器
echo "10.0.4.9 westgw giteaz g" | tee -a /etc/hosts

#本项目fridaAnlzAp 代码拉取
mkdir /fridaAnlzAp/
git clone http://giteaz:3000/frida_analyze_app_src/main.git  /fridaAnlzAp/main
#递归拉取所有子模块
( cd /fridaAnlzAp/main &&  git submodule    update --recursive --init )

#删除软链接
find  /fridaAnlzAp/  -maxdepth 1 -type l | xargs -I% unlink %
#直接子模块 或 app 链接到 上层目录
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/x
ln -s  /fridaAnlzAp/main/analyze_by_graph  /fridaAnlzAp/analyze_by_graph
ln -s /fridaAnlzAp/main/cmd-wrap  /fridaAnlzAp/cmd-wrap
ln -s /fridaAnlzAp/main/frida_js   /fridaAnlzAp/frida_js
ln -s  /fridaAnlzAp/main/github-gitee-GITEA   /fridaAnlzAp/github-gitee-GITEA
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/app/x
ln -s /fridaAnlzAp/main/app/cgsecurity--testdisk   /fridaAnlzAp/cgsecurity--testdisk
ln -s /fridaAnlzAp/main/app/torch-cpp  /fridaAnlzAp/torch-cpp


# #endregion


# #region 项目依赖安装
#{python依赖安装
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install -r /fridaAnlzAp/cmd-wrap/requirements.txt
pip install -r /fridaAnlzAp/frida_js/requirements.txt
pip install -r /fridaAnlzAp/analyze_by_graph/requirements.txt
#}

#{nodejs依赖安装
(cd /fridaAnlzAp/frida_js/ && npm install )
#}

# #endregion





