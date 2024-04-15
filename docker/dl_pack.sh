#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   


# #region cytoscape 运行在宿主机上
rootFsType=$(findmnt -n -o FSTYPE /)
#若根目录挂载的文件系统类型为overlay, 则当前极有可能在docker下
inDocker=$( { [[ "$rootFsType" == "overlay" ]] && echo "true" ;} || echo "false"  )



#本地文件下载web服务 url主要部分
LocalFileWebSrv=http://172.17.0.1:2111


declare -r errMsg5="无目录$RT/app/pack，请手工创建并设置主人为当前用户,退出代码5"
[[ -d $RT/app/pack/ ]] || {  echo "$errMsg5" && exit 5 ;}

F_dl_unpkg_sh=/tmp/download_unpack.sh
wget --quiet --output-document=$F_dl_unpkg_sh http://giteaz:3000/bal/bash-simplify/raw/branch/app_spy/dev/download_unpack.sh
# http://giteaz:3000/bal/bash-simplify/raw/commit/83e2651a5c5dc95ebe2a1331c410742617680e2b/download_unpack.sh
chmod +x $F_dl_unpkg_sh

#miniconda3
F="Miniconda3-py310_22.11.1-1-Linux-x86_64.sh" ; bash  $F_dl_unpkg_sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/$F e01420f221a7c4c6cde57d8ae61d24b5  $F $RT/app/pack/ $RT/app/  $LocalFileWebSrv/$F
#neo4j-4.4.32
F="neo4j-community-4.4.32-unix.tar.gz" ; $F_dl_unpkg_sh https://neo4j.com/artifact.php?name=$F a88d5de65332d9a5acbe131f60893b55  $F $RT/app/pack/ $RT/app/  $LocalFileWebSrv/$F
#neo4j-4.4.32需要的jdk11
F="zulu11.70.15-ca-jdk11.0.22-linux_x64.tar.gz" ; $F_dl_unpkg_sh https://cdn.azul.com/zulu/bin/$F f13d179f8e1428a3f0f135a42b9fa75b  $F $RT/app/pack/ $RT/app/  $LocalFileWebSrv/$F
#neo4j安装apoc插件
F="apoc-4.4.0.26-all.jar" ;   $F_dl_unpkg_sh https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.4.0.26/$F 5a42a32e12432632124acd682382c91d  $F $RT/app/pack/ $RT/app/  $LocalFileWebSrv/$F
#若docker下 不安装cytoscape，因为很麻烦
$inDocker || { \
# #region 物理机中安装 cytoscape
# https://github.com/cytoscape/cytoscape/releases/tag/3.10.2
# cytoscape-3.10.2
F="cytoscape-unix-3.10.2.tar.gz" ;   $F_dl_unpkg_sh https://github.com/cytoscape/cytoscape/releases/download/3.10.2/$F a6b5638319b301bd25e0e6987b3e35fd  $F $RT/app/pack/ $RT/app/  $LocalFileWebSrv/$F
# cytoscape-3.10.2需要的jdk17
F="zulu17.48.15-ca-jdk17.0.10-linux_x64.tar.gz" ; $F_dl_unpkg_sh https://cdn.azul.com/zulu/bin/$F bb826d2598b6ceaaae56a6c938f2030e  $F $RT/app/pack/ $RT/app/  $LocalFileWebSrv/$F
}