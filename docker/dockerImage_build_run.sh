#!/usr/bin/env bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

#去此脚本所在目录
declare -r f=$(readlink -f ${BASH_SOURCE[0]})  ; declare -r d=$(dirname $f)
cd $d

#构建基础镜像
docker images -q  --filter "reference=base_ubuntu_22.04"  ||  docker build --no-cache  -f "./base_ubuntu_22_Dockerfile" -t base_ubuntu_22.04:0.1 "./" 

#删除现有 frida_anlz_ap镜像
instanceIdLs=$(docker ps -a  -q --filter "ancestor=frida_anlz_ap:0.1")
[[ "x" == "x$instanceIdLs" ]] || { docker stop $instanceIdLs && docker rm $instanceIdLs ;}

#删除现有 frida_anlz_ap实例
imageIdLs=$(docker images -q  --filter "reference=frida_anlz_ap")
[[ "x" == "x$imageIdLs" ]] || { docker image rm $imageIdLs ;}


# curl --silent  localhost:2111 > /dev/null


#构建 frida_anlz_ap镜像
# docker镜像构建过程中使用本地域名   add-host=giteaz:10.0.4.9 供给Dockerfile使用
#      供给Dockerfile使用 == '构建过程中使用 而非docker实例运行过程中使用'
# --pull  --rm
docker build --add-host=giteaz:10.0.4.9    --no-cache  -f "./Dockerfile" -t frida_anlz_ap:0.1 "./" 

#启动 frida_anlz_ap镜像
#  --rm 
#  -v hostDir:dirInDocker
# -v  /tmp/app/:/app/ 
#-v  /tmp/fridaAnlzAp:/fridaAnlzAp
docker run -it  frida_anlz_ap:0.1

