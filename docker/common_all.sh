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

#判定当前 是在docker实例中 还是 在 宿主物理机 中 
# 返回变量为 inDocker
isInDocker