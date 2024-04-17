
#【描述】  
#【依赖】   
#【术语】 #dk# == #docker# == 仅docker有,  #sh# == #bash# == 仅bash有, #dksh# == #docker_shell# == docker有、bash有 
#【备注】 在bash中 冒号':' 表示 空指令

#dk# FROM base_ubuntu_22.04:0.1 as base



#dk# WORKDIR /

#dk# COPY /fridaAnlzAp/main/docker /fridaAnlzAp/main/docker



#dk# RUN bash -c ''' \
{ \
#公共依赖
source /fridaAnlzAp/main/docker/common_all.sh && \
# #Dockfile构建过程中需要的miniconda3 下载、安装、使用
# Conda3_Home_4dockerbuild=/dockerBuildROOT/Miniconda3-py310_22.11.1-1/  && \
# F="Miniconda3-py310_22.11.1-1-Linux-x86_64.sh" ; $F_dl_unpkg_sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/$F e01420f221a7c4c6cde57d8ae61d24b5  $F /tmp/ /not_unpack  $LocalFileWebSrv/$F  ; unset F && \
# bash  /tmp/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p $Conda3_Home_4dockerbuild && \
true ;} \
|| : #dk# '''


## 下载包 、 解压包 , miniconda3  
#dk# RUN bash -c ''' \
{ \
#公共依赖
source /fridaAnlzAp/main/docker/common_all.sh && \
# source  $Conda3_Home_4dockerbuild/bin/activate && which python && \
#下载安装包们
/dockerBuildROOT/fridaAnlzAp/main/docker/dl_pack.sh && \
#miniconda3
bash  /app/pack/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p /app/Miniconda3-py310_22.11.1-1/ && \
source /app/Miniconda3-py310_22.11.1-1/bin/activate && which python && \
true ;} \
|| : #dk# '''


##   neo4j-4.4.32 尝试启动
#dk# RUN bash -c ''' \
{ \
#公共依赖
source /fridaAnlzAp/main/docker/common_all.sh && \
#jdk11 
export JAVA_HOME=/app/zulu11.70.15-ca-jdk11.0.22-linux_x64 && \
#neo4j-4.4.32
export NEO4J_HOME=/app/neo4j-community-4.4.32 && \
export PATH=$PATH:$NEO4J_HOME/bin:$JAVA_HOME/bin && \
#neo4j配置为 监听0.0.0.0 、 4个工作线程
neo4j --help && \
# neo4j 4.4.32
neo4j version && \
F_cfg=/app/neo4j-community-4.4.32/conf/neo4j.conf && \
grep dbms.default_listen_address $F_cfg && \
grep dbms.memory $F_cfg && \
cp -v $F_cfg "${F_cfg}_$(date +%s)" && \
#修改 neo4j 监听地址为0.0.0.0
sed -i  "s/#dbms.default_listen_address=0.0.0.0/dbms.default_listen_address=0.0.0.0/g"  $F_cfg && \
#修改 neo4j 线程数目为 4 
sed -i  's/#dbms.threads.worker_count=/dbms.threads.worker_count=4/'   $F_cfg && \
echo $msg1 && \
true ;} \
|| : #dk# '''


#结尾
#dk# RUN bash -c ''' \
{ \
#公共依赖
source /fridaAnlzAp/main/docker/common_all.sh && \
cp -v /dockerBuildROOT/fridaAnlzAp/main/docker/.bashrc /root/.bashrc && \
rm -fr $Conda3_Home_4dockerbuild && \
ls /app/ /  && \
true ;} \
|| : #dk# '''






#dk# LABEL maintainer="prgrmz07 <prgrmz07@163.com>"
#dk# LABEL version="0.1"
#dk# LABEL description="fridaAnlzAp docker 环境"



#dk# ENTRYPOINT [ "/dockerBuildROOT/fridaAnlzAp/main/docker/docker_entry.sh" ]