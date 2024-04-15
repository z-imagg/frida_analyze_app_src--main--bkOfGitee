#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】   

#此脚本任何语句 退出代码不为正常值0 ，都会导致整个脚本退出
set -e

#添加本地gitea域名
grep "giteaz" /etc/hosts ||  ( echo "10.0.4.9 westgw giteaz g" | tee -a /etc/hosts || true )

cd /fridaAnlzAp/
/usr/bin/bash


