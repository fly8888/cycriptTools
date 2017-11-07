# 说明：

   ## cy调试：可用cyc + 进程注入调试
        
    内部定义了一些函数：

        function windows();
        function vc();
        function keywindow();
        function loadFramework(fw);
        function delegate();
        function mgr();
        function views();
        function ivars(a);
        function CGPointMake(x, y);
        function CGSizeMake(w, h);
        function CGRectMake(x, y, w, h);

   ## defaults: plist文件读取工具

        defaults + plistPath

   ## Clutch: 砸壳工具

         Clutch -i 列出已安装的App
         Clutch -b 导出砸壳后的binary
         etc...

   ## keychain: 钥匙串操作工具

        keychain -r -g appGroup //删除指定组钥匙串信息
        keychain -r -a          //删除所有钥匙串信息
        keychain -l -g          //列出所有钥匙串组
        keychain -l -a          //输出所有钥匙串信息
        keychain -ghost -p  -g  //备份keychain 指定组数据到指定路径
        keychain -recover -p -g //从指定备份恢复某个组的钥匙串数据



[相关资料](http://iphonedevwiki.net/index.php/Cycript_Tricks)

