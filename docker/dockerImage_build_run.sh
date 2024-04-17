#!/usr/bin/env bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e

source /fridaAnlzAp/main/docker/file_web_srv.sh
source /fridaAnlzAp/main/docker/util.sh

#去此脚本所在目录
declare -r f=$(readlink -f ${BASH_SOURCE[0]})  ; declare -r d=$(dirname $f)
cd $d

chmod +x my_env_prepare.sh

#本地文件下载web服务 停止 ; 从而 强迫 从真实web地址 下载安装包们
kill_file_web_srv ;  RT="/" bash  dl_pack.sh

declare -r errMsg6="无可执行文python，请手工安装python3或软链接python3为python,退出代码6"
which python || {  echo "$errMsg6" && exit 6 ;}

#本地文件下载web服务 重启
{  kill_file_web_srv  ;  boot_file_web_srv  ;}

#构建基础镜像 
bash   convert_sh_to_Dockerfile.sh base_ubuntu_22.Dockerfile.sh base_ubuntu_22.Dockerfile
[[ $(docker images -q  --filter "reference=base_ubuntu_22.04" | wc -l ) -gt 0 ]] ||  docker build --progress=plain --no-cache  -f "/fridaAnlzAp/main/docker/base_ubuntu_22.Dockerfile" -t base_ubuntu_22.04:0.1 "/" 

#删除现有 frida_anlz_ap镜像
instanceIdLs=$(docker ps -a  -q --filter "ancestor=frida_anlz_ap:0.1_prv")
[[ "x" == "x$instanceIdLs" ]] || { docker stop $instanceIdLs && docker rm $instanceIdLs ;}

#删除现有 frida_anlz_ap实例
imageIdLs=$(docker images -q  --filter "reference=frida_anlz_ap")
[[ "x" == "x$imageIdLs" ]] || { docker image rm $imageIdLs ;}


# curl --silent  localhost:2111 > /dev/null


#构建 frida_anlz_ap镜像
# docker镜像构建过程中使用本地域名   add-host=giteaz:10.0.4.9 供给Dockerfile使用
#      供给Dockerfile使用 == '构建过程中使用 而非docker实例运行过程中使用'
#删除现有镜像
docker images -q  --filter "reference=prgrmz07/frida_anlz_ap" |xargs -I%  docker image rm %
docker images -q  --filter "reference=frida_anlz_ap" |xargs -I%  docker image rm %
#重建镜像
# --pull  --rm
bash   convert_sh_to_Dockerfile.sh fridaAnlzAp.Dockerfile.sh fridaAnlzAp.Dockerfile
docker build --progress=plain --add-host=giteaz:10.0.4.9    --no-cache  -f "/fridaAnlzAp/main/docker/fridaAnlzAp.Dockerfile" -t frida_anlz_ap:0.1_prv "/" 

#启动 frida_anlz_ap镜像
#  --rm 
#  -v hostDir:dirInDocker
# -v  /tmp/app/:/app/ 
#-v  /tmp/fridaAnlzAp:/fridaAnlzAp
# docker ps  -q  --filter "label=frida_anlz_ap"
docker run -it  frida_anlz_ap:0.1_prv
#docker run --name fap  -itd frida_anlz_ap:0.1_prv
