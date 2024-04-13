#!/usr/bin/env bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

echo "welcome to my_env"
source /app/Miniconda3-py310_22.11.1-1/bin/activate

#已安装好nvm环境， 参考 https://blog.csdn.net/hfcaoguilin/article/details/124598084#t9
#/app/nvm/.git/config ::  https://gitclone.com/github.com/nvm-sh/nvm.git
# source /app/nvm/nvm.sh
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
export PATH=/app/bin:$PATH

#github-gitee-GITEA
# alias gg='source /fridaAnlzAp/github-gitee-GITEA/script/cmd_setup.sh'




#【编译命令拦截器】根据入口者查询业务者
# export PATH=$PATH:/app/cmd-wrap/tool_bin
# source /app/cmd-wrap/tool_bin/bash-complete--queryBuszByFakeCmd.sh
# #以自安装miniconda环境中的python运行 此脚本，不影响系统自带python
# alias queryBuszByFakeCmd.py='/app/Miniconda3-py310_22.11.1-1/bin/python /app/cmd-wrap/tool_bin/queryBuszByFakeCmd.py'


/usr/bin/bash