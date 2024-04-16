
#【描述】  
#【依赖】   
#【术语】 #dk# == #docker# == 仅docker有,  #sh# == #bash# == 仅bash有, #dksh# == #docker_shell# == docker有、bash有 
#【备注】

FROM base_ubuntu_22.04:0.1 as base



WORKDIR /

COPY /fridaAnlzAp/main/docker /fridaAnlzAp/main/docker



RUN \
bash -c ''' \
{ \
#公共依赖
source /fridaAnlzAp/main/docker/common_all.sh && \
#Dockfile构建过程中需要的miniconda3 下载、安装、使用
Conda3_Home_4dockerbuild=/dockerBuildROOT/Miniconda3-py310_22.11.1-1/  && \
F="Miniconda3-py310_22.11.1-1-Linux-x86_64.sh" ; $F_dl_unpkg_sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/$F e01420f221a7c4c6cde57d8ae61d24b5  $F /tmp/ /not_unpack  $LocalFileWebSrv/$F  ; unset F && \
bash  /tmp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p $Conda3_Home_4dockerbuild && \
true ;} \
|| : ''' #RUN_END#




RUN \
bash -c """ \
{ \
#公共依赖
source /fridaAnlzAp/main/docker/common_all.sh && \
ls /app/ /  && \
true ;} \
|| : """ #RUN_END#






LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
LABEL version="0.1"
LABEL description="fridaAnlzAp docker 环境"



ENTRYPOINT [ "/dockerBuildROOT/fridaAnlzAp/main/docker/docker_entry.sh" ]