#【备注】 

# FROM ubuntu:22.04 as base
FROM base_ubuntu_22.04:0.1 as base

WORKDIR /


COPY  my_env_prepare.sh /my_env_prepare.sh

RUN bash /my_env_prepare.sh
# 保存 my_env_prepare.sh 执行结果目录
COPY /tmp/ROOT/app /app
COPY /tmp/ROOT/fridaAnlzAp /fridaAnlzAp

LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"


COPY  docker_entry.sh /docker_entry.sh

ENTRYPOINT [ "/docker_entry.sh" ]