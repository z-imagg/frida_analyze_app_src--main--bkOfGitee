#!/usr/bin/bash +x

#【描述】  
#【依赖】   
#【术语】 
#【备注】   
#【运行环境】 
#    1. 此脚本 被docker实例(运行ubuntu22.04) 执行
#    2. 此脚本 在宿主机ubuntu22.04下运行

#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e

chmod +x /fridaAnlzAp/main/docker/*.sh

source /fridaAnlzAp/main/docker/util.sh
source /fridaAnlzAp/main/docker/local_domain.sh



# #region 项目

#   #region 项目代码拉取

#本地gitea服务器. 当文件系统是只读时，tee可能会写入了 但还是报错， 因此放入'子进程()'中 避免干扰此脚本
local_domain_set

#本项目fridaAnlzAp 代码拉取
#  删除 构建Dockerfile时 用的目录 /fridaAnlzAp/main/docker
mv /fridaAnlzAp /tmp_fridaAnlzAp ; mkdir -p /fridaAnlzAp/
git clone -b tag/fridaAnlzAp/docker_hub http://giteaz:3000/frida_analyze_app_src/main.git  /fridaAnlzAp/main
#git项目忽略文件权限变动
( cd /fridaAnlzAp/main ; git_ignore_filemode ;)
chmod +x /fridaAnlzAp/main/docker/*.sh
#递归拉取所有子模块
( cd /fridaAnlzAp/main &&  git submodule    update --recursive --init )

cd /fridaAnlzAp/
#删除软链接
find  .  -maxdepth 1 -type l | xargs -I% unlink %
#直接子模块 或 app 链接到 上层目录
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/x
ln -s  ./main/analyze_by_graph  ./analyze_by_graph
ln -s ./main/cmd-wrap  ./cmd-wrap
ln -s ./main/frida_js   ./frida_js
ln -s  ./main/github-gitee-GITEA   ./github-gitee-GITEA
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/app/x
ln -s ./main/app/cgsecurity--testdisk   ./cgsecurity--testdisk
ln -s ./main/app/torch-cpp  ./torch-cpp


#   #endregion


#   #region 项目依赖安装
#{python依赖安装
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install -r /fridaAnlzAp/cmd-wrap/requirements.txt
pip install -r /fridaAnlzAp/frida_js/requirements.txt
pip install -r /fridaAnlzAp/analyze_by_graph/requirements.txt
#}

ls -lh /

#   #endregion

# #endregion
