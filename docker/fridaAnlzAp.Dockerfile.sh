
#【描述】  
#【依赖】   
#【术语】 #dk# == #docker# == 仅docker有,  #sh# == #bash# == 仅bash有, #dksh# == #docker_shell# == docker有、bash有 
#【备注】

FROM base_ubuntu_22.04:0.1 as base



WORKDIR /

COPY /fridaAnlzAp/main/docker /fridaAnlzAp/main/docker

RUN \
bash -c """ \
#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e && \
shopt -s expand_aliases && \
mkdir -p /app/pack/ /app/ && \
chmod +x /fridaAnlzAp/main/docker/*.sh && \
source /fridaAnlzAp/main/docker/file_web_srv.sh && \
source /fridaAnlzAp/main/docker/util.sh && \
source /fridaAnlzAp/main/docker/local_domain.sh && \
#判定当前 是在docker实例中 还是 在 宿主物理机 中 
# 返回变量为 inDocker
isInDocker && \
ls /app/ / && find /dockerBuildROOT -type f  && \
true \
|| true \
"""


LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"



ENTRYPOINT [ "/dockerBuildROOT/fridaAnlzAp/main/docker/docker_entry.sh" ]