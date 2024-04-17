#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】  

#去此脚本所在目录
declare -r f=$(readlink -f ${BASH_SOURCE[0]})  ; declare -r d=$(dirname $f)
cd $d

sed -e "s/#dk# //g"  -e  "s/#dk# '''//g"  -e   "s/#dksh# COPY/cp/g"  -e   "s/#dksh# WORKDIR/cd/g"  docker/fridaAnlzAp.Dockerfile.sh | tee docker/fridaAnlzAp.Dockerfile