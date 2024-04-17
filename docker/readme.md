
#### 创建环境

1. 以docker镜像 创建 环境，  http://giteaz:3000/frida_analyze_app_src/main/src/branch/fridaAnlzAp/docker/docker/main_dockerImage_build_run.sh

2. 在物理机上 创建 环境， http://giteaz:3000/frida_analyze_app_src/main/src/branch/fridaAnlzAp/docker/docker/main_realEnv_build_run.sh


#### 稍微说明
[base_ubuntu_22.04.Dockerfile.sh](http://giteaz:3000/frida_analyze_app_src/main/src/branch/fridaAnlzAp/docker/docker/base_ubuntu_22.04.Dockerfile.sh) 、 [fridaAnlzAp.Dockerfile.sh](http://giteaz:3000/frida_analyze_app_src/main/src/branch/fridaAnlzAp/docker/docker/fridaAnlzAp.Dockerfile.sh)  表面上是在物理机上执行的bash脚本，但实际上经过
[convert_sh_to_Dockerfile.sh](http://giteaz:3000/frida_analyze_app_src/main/src/branch/fridaAnlzAp/docker/docker/convert_sh_to_Dockerfile.sh) 稍微转化 即变成 定义了docker镜像的 .Dockerfile文件






