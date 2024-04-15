#【备注】 

# FROM ubuntu:22.04 as base
FROM base_ubuntu_22.04:0.1 as base

# WORKDIR /tmp/ROOT/app
WORKDIR /

# 标明 目录含义:  dockerImage_build_run.sh  : 'docker build  ... -t frida_anlz_ap:0.1 "/左"  '     ，  'COPY /左  /右'   
#         注意 两者 的 左 是同一个东西
COPY /fridaAnlzAp/main/docker /fridaAnlzAp/main/docker

RUN --mount=type=cache,target=/dockerBuildROOT \
/fridaAnlzAp/main/docker/my_env_prepare.sh && \
# 标明 目录含义:  'cp /左 /右'  ,   'RUN ... target=/左'  
#         注意 两者 的 左 是同一个东西
# 保存 my_env_prepare.sh 执行结果目录
true

RUN ls /app/

LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"



ENTRYPOINT [ "/fridaAnlzAp/main/docker/docker_entry.sh" ]