#!/usr/bin/bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】

function local_domain_set() {
    grep "giteaz" /etc/hosts ||  ( echo "10.0.4.9 westgw giteaz g" | tee -a /etc/hosts || true )
}