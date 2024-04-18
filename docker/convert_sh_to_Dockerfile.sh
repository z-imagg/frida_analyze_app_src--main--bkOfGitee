#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】  

#去此脚本所在目录
declare -r f=$(readlink -f ${BASH_SOURCE[0]})  ; declare -r d=$(dirname $f)
cd $d

#文案，脚本用法
declare -r exitCode_errUsage=3
declare -r usage="usage syntax: '$0 x.Dockerfile.sh y.Dockerfile' , exit code $exitCode_errUsage"

#若 脚本参数不够，则退出
declare -r exitCode_errNoShFile=3
[[ $# -lt 2 ]] && { echo $usage && exit $exitCode_errUsage ;}

#脚本参数定义
shF=$1
dockerF=$2

#若 输入文件 x.Dockerfile.sh 不存在 ，则退出
declare -r errTxt_NoShFile="usage syntax: $shF not existed,  exit code  $exitCode_errNoShFile"
[[ -f $shF ]] || { echo $errTxt_NoShFile && exit $exitCode_errNoShFile ;}

#执行sh转Dockerfile :  x.Dockerfile.sh  --->  x.Dockerfile
sed -e "s/#dk# //g"  -e  "s/#dk# '''//g"    $shF | tee $dockerF 1>/dev/null

#打印提示消息
echo "converted: $shF ---> $dockerF"