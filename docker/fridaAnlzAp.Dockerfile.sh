
#【描述】  
#【依赖】   
#【术语】 #dk# == #docker# == 仅docker有,  #sh# == #bash# == 仅bash有, #dksh# == #docker_shell# == docker有、bash有 
#【备注】

FROM base_ubuntu_22.04:0.1 as base



WORKDIR /

COPY /fridaAnlzAp/main/docker /fridaAnlzAp/main/docker

RUN \
bash -c """ \
#公共依赖
source /fridaAnlzAp/main/docker/common_all.sh && \
ls /app/ / && find /dockerBuildROOT -type f  && \
true \
|| : """


LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"



ENTRYPOINT [ "/dockerBuildROOT/fridaAnlzAp/main/docker/docker_entry.sh" ]