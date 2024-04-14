#!/usr/bin/env bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

echo "welcome to my_env"
#{miniconda
source /app/Miniconda3-py310_22.11.1-1/bin/activate
#}

#{nvm,nodejs
source /app/nvm/nvm.sh
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
# export PATH=/app/bin:$PATH
#}


#{本地gitea服务器
echo "10.0.4.9 westgw giteaz g" | tee -a /etc/hosts
#}

#{本项目fridaAnlzAp
mkdir /fridaAnlzAp/
git clone http://giteaz:3000/frida_analyze_app_src/main.git  /fridaAnlzAp/main
( cd /fridaAnlzAp/main &&  git submodule    update --recursive --init )

#直接子模块 链接到 上层目录
# /fridaAnlzAp/x --->  /fridaAnlzAp/main/x
# /fridaAnlzAp/main/analyze_by_graph --> /fridaAnlzAp/analyze_by_graph
# /fridaAnlzAp/main/cmd-wrap --> /fridaAnlzAp/cmd-wrap
# /fridaAnlzAp/main/frida_js --> /fridaAnlzAp/frida_js
# /fridaAnlzAp/main/github-gitee-GITEA --> /fridaAnlzAp/github-gitee-GITEA

# /fridaAnlzAp/main/app/cgsecurity--testdisk --> /fridaAnlzAp/cgsecurity--testdisk
# /fridaAnlzAp/main/app/torch-cpp --> /fridaAnlzAp/torch-cpp
git submodule foreach --recursive '
rootD="/fridaAnlzAp/main"
curD=$(pwd)

cat  << 'EOF' > _relative_to.py
from pathlib import Path
rootD="$rootD";
curD="$curD";
relative_path = Path(curD).relative_to(Path(rootD)) .as_posix()
print(relative_path)
EOF
rltvPth=$(python3 _relative_to.py)

cat  << 'EOF' > _slash_cnt.py
sm_path="$sm_path"; 
print(sm_path.count("/"))
EOF
slash_cnt=$(python3 _slash_cnt.py)

cat  << 'EOF' > _startwith_app.py
sm_path="$sm_path"; 
dash_bool_ls=["false","true"]
result:bool=sm_path.startswith("app/") ; 
print(dash_bool_ls[int(result)])
EOF
startwith_app=$(python3 _startwith_app.py)

# echo curD=$curD,path=$path, relative_path=$relative_path, name=$name, sm_path=$sm_path, slash_cnt=$slash_cnt, startwith_app=$startwith_app
echo  relative_path=$relative_path,   slash_cnt=$slash_cnt, startwith_app=$startwith_app
'

# }

#{python依赖安装
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

cd /fridaAnlzAp/main/
/usr/bin/bash --rcfile <(echo "source /app/Miniconda3-py310_22.11.1-1/bin/activate; source /app/nvm/nvm.sh")


