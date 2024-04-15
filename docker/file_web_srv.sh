#!/usr/bin/bash

#本地文件下载web服务 停止
function kill_file_web_srv() {
    { kill -9 $(ps auxf | grep python | grep 2111 | awk '{print $2}')  && sleep 1 ;}
}

#本地文件下载web服务 启动
function boot_file_web_srv() {
    (cd /app/pack/ && python -m http.server 2111 & )  ; echo "booting_file_web_server"
}

