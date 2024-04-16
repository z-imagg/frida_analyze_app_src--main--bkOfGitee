#【备注】 

##FROM base_ubuntu_22.04:0.1 as base

##WORKDIR /

##COPY /fridaAnlzAp/main/docker /dockerBuildROOT/fridaAnlzAp/main/docker

##RUN \
/dockerBuildROOT/fridaAnlzAp/main/docker/my_env_prepare.sh

##RUN \
ls /app/ / && find /dockerBuildROOT -type f 


##LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
##LABEL version="0.1"
##LABEL description="fridaAnlzAp docker 环境"



##ENTRYPOINT [ "/dockerBuildROOT/fridaAnlzAp/main/docker/docker_entry.sh" ]