#!/usr/bin/bash -x

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

function get_bash_en_dbg() {
  bash_en_dbg=false; [[ $- == *x* ]] && bash_en_dbg=true #记录bash是否启用了调试模式
}

echo "welcome to my docker_entry"



cd /fridaAnlzAp/main/
/usr/bin/bash --rcfile <(echo "source /app/Miniconda3-py310_22.11.1-1/bin/activate; source /app/nvm/nvm.sh")


