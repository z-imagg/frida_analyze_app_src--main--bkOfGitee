
#【术语】 #dk# == #docker# == 仅docker有,  #sh# == #bash# == 仅bash有, #dksh# == #docker_shell# == docker有、bash有 
#【备注】 在bash中 冒号':' 表示 空指令

#dk# FROM ubuntu:22.04 as base
#dk# WORKDIR /

#dk# RUN bash -c ''' \
{ \
sudo apt-get update && \
sudo apt-get install -y axel wget curl  net-tools git  iputils-ping python3 python3-urllib3 sudo && \
true ;} \
|| false #dk# '''

#dk# RUN bash -c ''' \
{ \
mkdir -p /app/nvm && \
#nvm克隆
git clone --branch=v0.39.7   https://gitee.com/repok/nvm-sh--nvm.git  /app/nvm && \
#nvm函数导入
source /app/nvm/nvm.sh 1>/dev/null 2>/dev/null && \
#nvm安装nodejs-v18.19.1 ;  v18.19.1 是 nodejs  LTS v18 系列 中 最后一个版本
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/ && \
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/ && \
# NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm  ls-remote | grep v18. | grep LTS
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm install v18.19.1  1>/dev/null 2>/dev/null && \
true ;} \
|| false #dk# '''
