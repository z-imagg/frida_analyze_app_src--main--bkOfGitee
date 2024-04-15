#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e

source /fridaAnlzAp/main/docker/local_domain.sh

#添加本地gitea域名
local_domain_set

cd /fridaAnlzAp/
/usr/bin/bash


