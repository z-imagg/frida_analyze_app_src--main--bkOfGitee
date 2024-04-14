#!/usr/bin/bash -x

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

function get_bash_en_dbg() {
  bash_en_dbg=false; [[ $- == *x* ]] && bash_en_dbg=true #记录bash是否启用了调试模式
}

echo "welcome to my_env_prepare"

#{miniconda
get_bash_en_dbg  ;  $bash_en_dbg && set +x 
source /app/Miniconda3-py310_22.11.1-1/bin/activate
$bash_en_dbg && set -x
#}

#{nvm,nodejs
get_bash_en_dbg  ;  $bash_en_dbg && set +x 
source /app/nvm/nvm.sh
$bash_en_dbg && set -x

export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
# export PATH=/app/bin:$PATH
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm  ls-remote | grep v18. | grep LTS
NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm install v18.19.1
#v18.19.1 是 nodejs  LTS v18 系列 中 最后一个版本
#}


#{本地gitea服务器
echo "10.0.4.9 westgw giteaz g" | tee -a /etc/hosts
#}

#{本项目fridaAnlzAp
mkdir /fridaAnlzAp/
git clone http://giteaz:3000/frida_analyze_app_src/main.git  /fridaAnlzAp/main
( cd /fridaAnlzAp/main &&  git submodule    update --recursive --init )

cd /fridaAnlzAp/main/
#直接子模块 或 app 链接到 上层目录
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/x
# /fridaAnlzAp/main/analyze_by_graph --> /fridaAnlzAp/analyze_by_graph
# /fridaAnlzAp/main/cmd-wrap --> /fridaAnlzAp/cmd-wrap
# /fridaAnlzAp/main/frida_js --> /fridaAnlzAp/frida_js
# /fridaAnlzAp/main/github-gitee-GITEA --> /fridaAnlzAp/github-gitee-GITEA

# /fridaAnlzAp/main/app/cgsecurity--testdisk --> /fridaAnlzAp/cgsecurity--testdisk
# /fridaAnlzAp/main/app/torch-cpp --> /fridaAnlzAp/torch-cpp
git submodule foreach --recursive '
#py根目录
pyRootD=/tmp/
#写死项目根目录
rootD="/fridaAnlzAp/main"
#子模块目录
curD=$(pwd)
#当前时刻毫米数
nowMs=$(date +%s)

_relative_to__py=$pyRootD/_relative_to_$nowMs.py
#cat写py文件
cat  << 'EOF' > $_relative_to__py
from pathlib import Path
#py变量="dash shell变量的值作为py字符串字面量"
rootD="$rootD";
curD="$curD";
#计算相对目录
relative_path = Path(curD).relative_to(Path(rootD)) .as_posix()
#打印结果给到外围dash shell的"$()"
print(relative_path)
#py文件结尾
EOF
rltvPth=$(python3 $_relative_to__py)

_calc_doLink__py=$pyRootD/_calc_doLink_$nowMs.py
#cat写py文件
cat  << 'EOF' > $_calc_doLink__py
#py变量="dash shell变量的值作为py字符串字面量"
rltvPth="$rltvPth"; 
#斜线个数
slash_cnt=rltvPth.count("/")
#是否以app开头
startswith_app:bool=rltvPth.startswith("app/") ; 
#做软链接吗？ 假设不做
doLink:bool = False
#如果 不以app开头 且 无斜线 则 做软链接 
if (not startswith_app) and  slash_cnt == 0 : doLink=True
#如果 以app开头 且 斜线个数 为1  则 做软链接 
if startswith_app and  slash_cnt == 1 : doLink=True
#python的bool转为dash shell的bool
#  True|False --> 1|0 --> "true"|"false"
dash_bool_ls=["false","true"]
doLink_shell:str=dash_bool_ls[int(doLink)]
#打印结果给到外围dash shell的"$()"
print(doLink_shell)
#py文件结尾
EOF

echo  -n rltvPth=$rltvPth ；

doLink=$(python3 $_calc_doLink__py)
if $doLink ; then
  dst="/fridaAnlzAp/$(basename $sm_path)" 
  unlink  $dst 2>/dev/null ; { ln -s   $curD $dst && echo "【做软链接】 $curD --> $dst" ;}
else
  echo "【忽略】"
fi
'

# }

#{python依赖安装
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install -r /fridaAnlzAp/cmd-wrap/requirements.txt
pip install -r /fridaAnlzAp/frida_js/requirements.txt
pip install -r /fridaAnlzAp/analyze_by_graph/requirements.txt
#}

#{nodejs依赖安装
(cd /fridaAnlzAp/frida_js/ && npm install )
#}

#{neo4j安装
bash /fridaAnlzAp/analyze_by_graph/doc/neo4j_linux_dl_install.sh
#}

#{cytoscape还是运行在宿主机上吧
#}



