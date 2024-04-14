#【备注】 

# FROM ubuntu:22.04 as base
FROM base_ubuntu_22.04:0.1 as base

# WORKDIR /tmp/ROOT/app
WORKDIR /

# RUN mkdir /tmp/ROOT

COPY /fridaAnlzAp/main/docker /fridaAnlzAp/main/docker

# COPY my_env_prepare.sh /my_env_prepare.sh

RUN --mount=type=cache,target=/dockerBuildROOT \
# RUN --mount=type=bind,source=/host_dockerBuildROOT,target=/dockerBuildROOT,readwrite \
# RUN --mount=type=cache,target=/dockerBuildROOT,sharing=locked,id=id_preapare \
/fridaAnlzAp/main/docker/my_env_prepare.sh && \
cp -r /dockerBuildROOT/app /
# cp -rv /host_dockerBuildROOT/fridaAnlzAp /

# 保存 my_env_prepare.sh 执行结果目录
# COPY --from=id_preapare /dockerBuildROOT/app /app
# COPY /tmp/ROOT/fridaAnlzAp /fridaAnlzAp

RUN ls /app/

LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"


COPY  /fridaAnlzAp/main/docker/docker_entry.sh /docker_entry.sh

ENTRYPOINT [ "/docker_entry.sh" ]