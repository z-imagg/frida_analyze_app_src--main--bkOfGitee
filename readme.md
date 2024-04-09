#### 分析torch大致流程

1. 【可选】借助gitee将github的torch仓库导入本地GITEA：[github-gitee-GITEA](http://giteaz:3000/wiki/github-gitee-GITEA.git)
2. 编译torch-v1.3.1【[github-gitee-GITEA/torch-v1.3.1-build.md](http://giteaz:3000/github_tool/github-gitee-GITEA/src/branch/main/torch-v1.3.1-build.md)】
3.  编译torch过程中拦截编译命令修改调试信息级别,，```-O2 -g``` --> ```-O1 -g1```【[cmd-wrap](http://giteaz:3000/bal/cmd-wrap.git)】；
4. 【例子应用程序】c++调用torch：[torch-cpp](http://giteaz:3000/frida_analyze_app_src/torch-cpp.git/src/branch/master/v1.0.0)
5.  利用frida生成 函数进出日志、进出时刻点日志：[frida_js](http://giteaz:3000/frida_analyze_app_src/frida_js.git)
6.  日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)



#### 分析testdisk大致流程
1. 【可选】github原始仓库[ cgsecurity/testdisk.git](https://github.com/cgsecurity/testdisk.git)
2.  testdisk编译步骤, 禁用qt, 方便frida的函数___loop_step__,  [cgsecurity--testdisk.git/11d31](https://gitee.com/disk_recovery/cgsecurity--testdisk/commit/11d31526c66f494111334bf97194104f68c31256)

3. 有cmd-wrap时testdisk编译步骤 ，```-O2 -g``` --> ```-O1 -g1``` [cmd-wrap.git/v2.2.simpl/build_testdisk.md](http://giteaz:3000/bal/cmd-wrap/src/tag/v2.2.simpl/build_testdisk.md)  , [cmd-wrap.git/7fc35/build_testdisk.md](http://giteaz:3000/bal/cmd-wrap/src/commit/7fc355dd259b847f14b9b8db61d649d3ff3df3b6/build_testdisk.md)

4. 无
5. TODO  利用frida生成 函数进出日志、进出时刻点日志：[frida_js](http://giteaz:3000/frida_analyze_app_src/frida_js.git)
6. TODO 日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)
