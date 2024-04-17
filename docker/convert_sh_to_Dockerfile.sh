#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】  

#去此脚本所在目录
declare -r f=$(readlink -f ${BASH_SOURCE[0]})  ; declare -r d=$(dirname $f)
cd $d

declare -r exitCode_errUsage=3
declare -r usage="usage syntax: '$0 x.Dockerfile.sh y.Dockerfile' , exit code $exitCode_errUsage"

declare -r exitCode_errNoShFile=3


[[ $# -lt 2 ]] && { echo $usage && exit $exitCode_errUsage ;}

shF=$1
dockerF=$2

declare -r errTxt_NoShFile="usage syntax: $shF not existed,  exit code  $exitCode_errNoShFile"
[[ -f $shF ]] || { echo $errTxt_NoShFile && exit $exitCode_errNoShFile ;}

sed -e "s/#dk# //g"  -e  "s/#dk# '''//g"  -e   "s/#dksh# COPY/cp/g"  -e   "s/#dksh# WORKDIR/cd/g"  $shF | tee $dockerF 1>/dev/null

echo $dockerF