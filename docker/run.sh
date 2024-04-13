#!/usr/bin/env bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

#构建基础镜像
docker images -q  --filter "reference=base_ubuntu_22.04"  ||  docker build  --no-cache  -f "./base_ubuntu_22_Dockerfile" -t base_ubuntu_22.04:0.1 "./" 

#删除现有 frida_anlz_ap镜像
instanceIdLs=$(docker ps -a  -q --filter "ancestor=frida_anlz_ap:0.1")
[[ "x" == "x$instanceIdLs" ]] || { docker stop $instanceIdLs && docker rm $instanceIdLs ;}

#删除现有 frida_anlz_ap实例
imageIdLs=$(docker images -q  --filter "reference=frida_anlz_ap")
[[ "x" == "x$imageIdLs" ]] || { docker image rm $imageIdLs ;}


# curl --silent  localhost:8000 > /dev/null

#开发用，重启宿主机的web服务
{ kill -9 $(ps auxf | grep python3 | grep 8000 | awk '{print $2}')  && sleep 1 ;}  ;  ( cd /tmp/app/ && python3 -m http.server 8000 & )

#去此脚本所在目录
f=$(readlink -f ${BASH_SOURCE[0]})  ; d=$(dirname $f)
cd $d

#构建 frida_anlz_ap镜像
# --pull  --rm
docker build  --no-cache  -f "./Dockerfile" -t frida_anlz_ap:0.1 "./" 

#启动 frida_anlz_ap镜像
#  --rm 
#  -v hostDir:dirInDocker
# -v  /tmp/app/:/app/ 
#-v  /tmp/fridaAnlzAp:/fridaAnlzAp
docker run -it  frida_anlz_ap:0.1

