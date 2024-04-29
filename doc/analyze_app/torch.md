#### 分析torch大致流程

1. 【可选】借助gitee将github的torch仓库导入本地GITEA：[github-gitee-GITEA](http://giteaz:3000/wiki/github-gitee-GITEA.git)
2. 编译torch-v1.3.1【[github-gitee-GITEA/torch-v1.3.1-build.md](http://giteaz:3000/github_tool/github-gitee-GITEA/src/branch/main/torch-v1.3.1-build.md)】
3.  编译torch过程中拦截编译命令修改调试信息级别,，```-O2 -g``` --> ```-O1 -g1```【[cmd-wrap](http://giteaz:3000/bal/cmd-wrap.git)】；
4. 【例子应用程序】c++调用torch：[torch-cpp](http://giteaz:3000/frida_analyze_app_src/torch-cpp.git/src/branch/master/v1.0.0)
5.  frida_js生成 函数进出日志、进出时刻点日志：[frida_js](http://giteaz:3000/frida_analyze_app_src/frida_js.git)
6.  日志最终载入neo4j进行分析：[analyze_by_graph](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph.git)


[【只有一张图】cytoscape可视化应用程序torch函数调用日志半成品](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph/src/commit/96baadd4a06f57aed634cc415f7a6fecfec7ea0f/doc/img/cytoscape_yFiles_Circular_Layout.png)， 该图的产生步骤 请参考 [cytoscape可视化应用程序qphotorec函数调用日志半成品](http://giteaz:3000/frida_analyze_app_src/analyze_by_graph/src/commit/aed2f1cbe736f3f42e6a3a9db3075f50571f2589/visual/cytoscape__testdisk_qphotorec/readme.md)