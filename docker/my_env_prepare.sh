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


