

#### ~~分析testdisk大致流程~~

放弃testdisk原因： **frida_tools/frida.py 中的交互式界面的输入 与  testdisk的ncurse交互式界面的输入 有冲突**

1. 【可选】github原始仓库[ cgsecurity/testdisk.git](https://github.com/cgsecurity/testdisk.git)
2.  testdisk编译步骤, 禁用qt, 方便frida的函数___loop_step__,  [cgsecurity--testdisk.git/11d31](https://gitee.com/disk_recovery/cgsecurity--testdisk/commit/11d31526c66f494111334bf97194104f68c31256)

3. 有cmd-wrap时testdisk编译步骤 ，```-O2 -g``` --> ```-O1 -g1``` [app_bld.git/tag_release/testdisk.md](http://giteaz:3000/frida_analyze_app_src/app_bld/src/branch/main/testdisk.md)   

4. 无

5. 【卡住】py驱动frida加载frida_js 以 生成 函数进出日志、进出时刻点日志； 

因 frida_js的console.log输出干扰了testdisk的ncurses界面按键输入,  

解决办法

a. 【[用py驱动frida  , frida_develop 49d6e](http://giteaz:3000/frida_analyze_app_src/frida_develop/commit/49d6e412210580b1ba6c343cd721d608b21ef03c) 】但是frida_develop有问题 其在main之后才开始监控而错过了main, 【[console.log ---> send ，frida_js a443](http://giteaz:3000/frida_analyze_app_src/frida_js/commit/a443ba1cfe8a4313fc703e9923dc0094f89e09b1)】

b.  放弃 基于ncurse交互的testdisk, 尝试 图形化界面 'testdisk/qphotorec'



6. 【因步骤5卡住，本步骤无从做起】 日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)

