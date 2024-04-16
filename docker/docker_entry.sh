#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e

source /dockerBuildROOT/fridaAnlzAp/main/docker/local_domain.sh

#添加本地gitea域名
local_domain_set


#docker实例运行的时候，才克隆项目代码，方便docker image上传到dockerhub ，同时也不泄漏项目源码
[[ -f /fridaAnlzAp/main/.git/config ]] || bash /dockerBuildROOT/fridaAnlzAp/main/docker/init_proj.sh


# cd /fridaAnlzAp/

/usr/bin/bash


