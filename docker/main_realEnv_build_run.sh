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

#本地文件下载web服务 停止 ; 从而 强迫 从真实web地址 下载安装包们
kill_file_web_srv ;  RT="/" bash  dl_pack.sh

declare -r errMsg6="无可执行文python，请手工安装python3或软链接python3为python,退出代码6"
which python || {  echo "$errMsg6" && exit 6 ;}

#本地文件下载web服务 重启
{  kill_file_web_srv  ;  boot_file_web_srv  ;}

#构建基础镜像 
bash    base_ubuntu_22.04.Dockerfile.sh
bash   fridaAnlzAp.Dockerfile.sh
