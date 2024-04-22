

#### 分析 frida_agent.so大致流程

暂停， 理由是 linux内核启动过程 可以通过 初始化脚本 启动后 自动关机，从而不具备交互性，即可避开frida交互性的干扰。  
  因此无需通过研究frida_agent.so 以通过frida_agent.so写出 干净的、定制的、无交互性的 等价"frida工具"

由此 理论上 frida 可分析 qemu运行  由初始化脚本在自动关机的linux内核

#### frida 分析 qemu运行 linux内核

1. 无
2. 正常编译linux4内核，[bal.git/bldLinux4RunOnBochs/readme.md](http://giteaz:3000/bal/bal/src/branch/fridaAnlzAp/app/qemu-linux4/bldLinux4RunOnBochs/readme.md)；正常编译qemu-v8.2.2, [cmd-wrap.git/build/qemu/readme.md](http://giteaz:3000/frida_analyze_app_src/app_bld/src/branch/main/qemu/readme.md); qemu-system-x86_64 v8.2.2 正常启动linux4内核到busybox终端、正常关机,  [cmd-wrap.git/build/qemu/linux4.md](http://giteaz:3000/frida_analyze_app_src/app_bld/src/branch/main/qemu/linux4.md)
3.  TODO 编译qemu程中拦截编译命令修改调试信息级别,，```-O2 -g``` --> ```-O1 -g1```【[cmd-wrap/build_qemu.md](http://giteaz:3000/bal/cmd-wrap/src/branch/fridaAnlzAp/app/qemu/build_qemu/readme.md)】；
4.  frida如何拦截到qemu源码中目标操作系统linux内核中的call指令
5. TODO, frida_js生成 函数进出日志、进出时刻点日志：[frida_js](http://giteaz:3000/frida_analyze_app_src/frida_js.git)
6.  TODO, 日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)




