
#!/usr/bin/env bash

#【描述】  
#【依赖】   
#【术语】 
#【备注】  

#判定当前 是在docker实例中 还是 在 宿主物理机 中 
function isInDocker() {
    _rootFsType=$(findmnt -n -o FSTYPE /)
    #若根目录挂载的文件系统类型为overlay, 则当前极有可能在docker下
    inDocker=$( { [[ "$_rootFsType" == "overlay" ]] && echo "true" ;} || echo "false"  )
}

function git_ignore_filemode() {
    (  git config --unset-all core.filemode  ; git config core.filemode false ; true ;)
}