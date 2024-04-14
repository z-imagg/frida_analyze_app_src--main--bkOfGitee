# FROM ubuntu:22.04 as base
FROM base_ubuntu_22.04:0.1 as base

WORKDIR /app

#{miniconda
RUN wget  --output-document=/tmp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh http://172.17.0.1:8000/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh  
# RUN axel --insecure   --output=/app/pack/fridaAnlzAp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh  -n 7 https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh
RUN bash /tmp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p /app/Miniconda3-py310_22.11.1-1 
# RUN rm -v /tmp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh
#}

#{nvm,nodejs
#https://gitee.com/repok/nvm-sh--nvm.git
RUN git clone --branch=v0.39.7   https://gitee.com/repok/nvm-sh--nvm.git  /app/nvm
#}

COPY  my_env_prepare.sh /

LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"



ENTRYPOINT [ "/my_env_prepare.sh" ]