#【备注】 

# FROM ubuntu:22.04 as base
FROM base_ubuntu_22.04:0.1 as base

WORKDIR /

# 标明 目录含义:  dockerImage_build_run.sh  : 'docker build  ... -t frida_anlz_ap:0.1_prv "/左"  '     ，  'COPY /左  /右'   
#         注意 两者 的 左 是同一个东西
COPY /fridaAnlzAp/main/docker /dockerBuildROOT/fridaAnlzAp/main/docker

RUN   \
/dockerBuildROOT/fridaAnlzAp/main/docker/my_env_prepare.sh
# 为什么 从提交 fc1d33c88b11497cd7b850b7b4f5714d2ada879e  到提交 579b6b58d676b524cf88cc348c9ca1cdd6a56b31 上一行脚本 my_env_prepare.sh 的修改结果没有 保存到镜像 中， 
#    而此时 到了提交 26a58563ca0f415cdf32b3beb0b5949016861348  上一行脚本 my_env_prepare.sh 的修改结果 却正常 保存到镜像

RUN ls /app/ / && find /dockerBuildROOT -type f 


LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"



ENTRYPOINT [ "/dockerBuildROOT/fridaAnlzAp/main/docker/docker_entry.sh" ]