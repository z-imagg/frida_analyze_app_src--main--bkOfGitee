#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】

##FROM base_ubuntu_22.04:0.1 as base

#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
##RUN \
set -e && \
shopt -s expand_aliases && \
true

##WORKDIR /

##COPY /fridaAnlzAp/main/docker /fridaAnlzAp/main/docker

##RUN \
mkdir -p /app/pack/ /app/ && \
chmod +x /fridaAnlzAp/main/docker/*.sh && \
source /fridaAnlzAp/main/docker/file_web_srv.sh && \
source /fridaAnlzAp/main/docker/util.sh && \
source /fridaAnlzAp/main/docker/local_domain.sh && \
#判定当前 是在docker实例中 还是 在 宿主物理机 中 
# 返回变量为 inDocker
isInDocker && \
true

##RUN \
/dockerBuildROOT/fridaAnlzAp/main/docker/my_env_prepare.sh

##RUN \
ls /app/ / && find /dockerBuildROOT -type f 


##LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
##LABEL version="0.1"
##LABEL description="fridaAnlzAp docker 环境"



##ENTRYPOINT [ "/dockerBuildROOT/fridaAnlzAp/main/docker/docker_entry.sh" ]