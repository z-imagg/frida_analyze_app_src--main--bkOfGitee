大致流程

1. 【可选】借助gitee将github的torch仓库导入本地GITEA：[github-gitee-GITEA](http://giteaz:3000/wiki/github-gitee-GITEA.git)
2.  编译torch过程中拦截编译命令修改调试信息级别：[cmd-wrap](http://giteaz:3000/bal/cmd-wrap.git)
3. 【例子应用程序】c++调用torch：[torch-cpp](http://giteaz:3000/frida_analyze_app_src/torch-cpp.git/src/branch/master/v1.0.0)
4.  利用frida生成 函数进出日志、进出时刻点日志：[frida_js](http://giteaz:3000/frida_analyze_app_src/frida_js.git)
5.  日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)