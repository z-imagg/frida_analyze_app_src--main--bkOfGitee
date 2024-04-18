#### 分析torch大致流程

1. 【可选】借助gitee将github的torch仓库导入本地GITEA：[github-gitee-GITEA](http://giteaz:3000/wiki/github-gitee-GITEA.git)
2. 编译torch-v1.3.1【[github-gitee-GITEA/torch-v1.3.1-build.md](http://giteaz:3000/github_tool/github-gitee-GITEA/src/branch/main/torch-v1.3.1-build.md)】
3.  编译torch过程中拦截编译命令修改调试信息级别,，```-O2 -g``` --> ```-O1 -g1```【[cmd-wrap](http://giteaz:3000/bal/cmd-wrap.git)】；
4. 【例子应用程序】c++调用torch：[torch-cpp](http://giteaz:3000/frida_analyze_app_src/torch-cpp.git/src/branch/master/v1.0.0)
5.  frida_js生成 函数进出日志、进出时刻点日志：[frida_js](http://giteaz:3000/frida_analyze_app_src/frida_js.git)
6.  日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)



#### ~~分析testdisk大致流程~~

放弃testdisk原因： **frida_tools/frida.py 中的交互式界面的输入 与  testdisk的ncurse交互式界面的输入 有冲突**

1. 【可选】github原始仓库[ cgsecurity/testdisk.git](https://github.com/cgsecurity/testdisk.git)
2.  testdisk编译步骤, 禁用qt, 方便frida的函数___loop_step__,  [cgsecurity--testdisk.git/11d31](https://gitee.com/disk_recovery/cgsecurity--testdisk/commit/11d31526c66f494111334bf97194104f68c31256)

3. 有cmd-wrap时testdisk编译步骤 ，```-O2 -g``` --> ```-O1 -g1``` [cmd-wrap.git/v2.2.simpl/build_testdisk.md](http://giteaz:3000/bal/cmd-wrap/src/tag/v2.2.simpl/build_testdisk.md)  , [cmd-wrap.git/7fc35/build_testdisk.md](http://giteaz:3000/bal/cmd-wrap/src/commit/7fc355dd259b847f14b9b8db61d649d3ff3df3b6/build_testdisk.md)

4. 无

5. 【卡住】py驱动frida加载frida_js 以 生成 函数进出日志、进出时刻点日志； 

因 frida_js的console.log输出干扰了testdisk的ncurses界面按键输入,  

解决办法

a. 【[用py驱动frida  , frida_develop 49d6e](http://giteaz:3000/frida_analyze_app_src/frida_develop/commit/49d6e412210580b1ba6c343cd721d608b21ef03c) 】但是frida_develop有问题 其在main之后才开始监控而错过了main, 【[console.log ---> send ，frida_js a443](http://giteaz:3000/frida_analyze_app_src/frida_js/commit/a443ba1cfe8a4313fc703e9923dc0094f89e09b1)】

b.  放弃 基于ncurse交互的testdisk, 尝试 图形化界面 'testdisk/qphotorec'



6. 【因步骤5卡住，本步骤无从做起】 日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)


#### 分析 testdisk/qphotorec大致流程

【术语】 qphotorec==带qt的testdisk



- . 2. qphotorec编译步骤，对u盘创建6个分区， [testdisk/c27a3/README.md](https://gitee.com/disk_recovery/cgsecurity--testdisk/blob/c27a3ae0a9aed9b2a31f2eab9ca4b49ab80ab767/README.md),  [testdisk/fridaAnlzAp/qphotorec/README.md](https://gitee.com/disk_recovery/cgsecurity--testdisk/blob/fridaAnlzAp/qphotorec/README.md)

- . 5. frida_js生成 函数进出日志、进出时刻点日志,[frids_js/f8d80/fridaJs_runApp.sh](http://giteaz:3000/frida_analyze_app_src/frida_js/src/commit/f8d80c10899042cd7d660d93dc5c2b107db01d2f/fridaJs_runApp.sh),  [frids_js/ok/qphotorec_01/fridaJs_runApp.sh](http://giteaz:3000/frida_analyze_app_src/frida_js/src/tag/ok/qphotorec_01/fridaJs_runApp.sh)。 请务必选6个分区中的最小分区，可以节省大量时间



其余可看文档， [frids_js/f8d80/README.md](http://giteaz:3000/frida_analyze_app_src/frida_js/src/commit/f8d80c10899042cd7d660d93dc5c2b107db01d2f/README.md)， 



#### 分析 frida_agent.so大致流程

暂停， 理由是 linux内核启动过程 可以通过 初始化脚本 启动后 自动关机，从而不具备交互性，即可避开frida交互性的干扰。  
  因此无需通过研究frida_agent.so 以通过frida_agent.so写出 干净的、定制的、无交互性的 等价"frida工具"

由此 理论上 frida 可分析 qemu运行  由初始化脚本在自动关机的linux内核

#### frida 分析 qemu运行 linux内核

1. 无
2. 正常编译qemu-v8.2.2, [cmd-wrap.git/build/qemu/readme.md](http://giteaz:3000/bal/cmd-wrap/src/branch/fridaAnlzAp/app/qemu/build/qemu/readme.md); qemu-system-x86_64 v8.2.2 正常启动linux4内核到busybox终端、正常关机,  [cmd-wrap.git/build/qemu/linux4.md](http://giteaz:3000/bal/cmd-wrap/src/branch/fridaAnlzAp/app/qemu/build/qemu/linux4.md)； 正常编译linux4内核，[bal.git/bldLinux4RunOnBochs/readme.md](http://giteaz:3000/bal/bal/src/branch/fridaAnlzAp/app/qemu-linux4/bldLinux4RunOnBochs/readme.md)
3.  TODO 编译qemu程中拦截编译命令修改调试信息级别,，```-O2 -g``` --> ```-O1 -g1```【[cmd-wrap/build_qemu.md](http://giteaz:3000/bal/cmd-wrap/src/branch/fridaAnlzAp/app/qemu/build_qemu/readme.md)】；
4.  frida如何拦截到qemu源码中目标操作系统linux内核中的call指令
5. TODO, frida_js生成 函数进出日志、进出时刻点日志：[frida_js](http://giteaz:3000/frida_analyze_app_src/frida_js.git)
6.  TODO, 日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)




