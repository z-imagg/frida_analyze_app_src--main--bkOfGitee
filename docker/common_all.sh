#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】  


#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e
shopt -s expand_aliases

mkdir -p /app/pack/ /app/
chmod +x /fridaAnlzAp/main/docker/*.sh

source /fridaAnlzAp/main/docker/file_web_srv.sh
source /fridaAnlzAp/main/docker/util.sh
source /fridaAnlzAp/main/docker/local_domain.sh

#去此脚本所在目录
declare -r f=$(readlink -f ${BASH_SOURCE[0]})  ; declare -r d=$(dirname $f)
cd $d


#判定当前 是在docker实例中 还是 在 宿主物理机 中 
# 返回变量为 inDocker
isInDocker

# 本地文件下载web服务  只在 物理机下 启动  在 docker下 不启动 
$inDocker || {  kill_file_web_srv  ;  boot_file_web_srv  ;}
#本地文件下载web服务 url主要部分 ， 172.17.0.1 是 物理真实宿主机 ip
LocalFileWebSrv=http://172.17.0.1:2111

#下载 download_unpack.sh
F_dl_unpkg_sh=/tmp/download_unpack.sh
wget --quiet --output-document=$F_dl_unpkg_sh http://giteaz:3000/bal/bash-simplify/raw/branch/app_spy/dev/download_unpack.sh
# http://giteaz:3000/bal/bash-simplify/raw/commit/83e2651a5c5dc95ebe2a1331c410742617680e2b/download_unpack.sh
chmod +x $F_dl_unpkg_sh