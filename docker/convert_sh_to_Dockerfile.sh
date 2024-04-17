#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】  

sed -e "s/#dk# //g"  -e  "s/#dk# '''//g"  -e   "s/#dksh# COPY/cp/g"  -e   "s/#dksh# WORKDIR/cd/g"  docker/fridaAnlzAp.Dockerfile.sh | tee docker/fridaAnlzAp.Dockerfile