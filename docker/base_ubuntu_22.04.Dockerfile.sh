
#【术语】 #dk# == #docker# == 仅docker有,  #sh# == #bash# == 仅bash有, #dksh# == #docker_shell# == docker有、bash有 
#【备注】 在bash中 冒号':' 表示 空指令

#dk# FROM ubuntu:22.04 as base
#dk# WORKDIR /

#dk# RUN bash -c ''' \
{ \
SUDO="sudo" ; { [[ $(whoami) == root ]] && SUDO="" ;} && \
$SUDO apt-get update && \
$SUDO apt-get install -y  sudo && \
sudo apt-get install -y axel wget curl  net-tools git  iputils-ping python3 python3-urllib3 && \
true ;} \
|| false #dk# '''

#dk# RUN bash -c ''' \
{ \
mkdir -p /app/nvm && \
#nvm克隆. TODO 有隐患， 应改为 在下一行写 切换到 远程标签v0.39.7 ，但我始终不知道怎么写这句命令。
{ [[ -f /app/nvm/.git/config ]] || git clone --branch=v0.39.7   https://gitee.com/repok/nvm-sh--nvm.git  /app/nvm ;} && \
#nvm函数导入
source /app/nvm/nvm.sh 1>/dev/null 2>/dev/null && \
#nvm安装nodejs-v18.19.1 ;  v18.19.1 是 nodejs  LTS v18 系列 中 最后一个版本
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/ && \
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/ && \
# NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm  ls-remote | grep v18. | grep LTS
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm install v18.19.1  1>/dev/null 2>/dev/null && \
true ;} \
|| false #dk# '''
