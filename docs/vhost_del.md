## 一、概述

* 删除虚拟主机用户的操作比较简单，唯一需要注意的是，删除前请做好备份工作。

## 二、删除步骤

1. 进入安装目录并运行删除虚拟主机脚本

        cd lanmp/
        ./vhost_del.sh

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-1.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-1.jpg" width="450" /></a>

2. 请输入虚拟主机用户帐号

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-2.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-2.jpg" width="450" /></a>

3. 询问是否删除`FTP`帐号

    注意：删除`FTP`帐号的前提是，你已经成功添加了FTP帐号。（[了解添加FTP帐号条件](https://github.com/wangyan/lanmp/wiki/%E6%B7%BB%E5%8A%A0%E8%99%9A%E6%8B%9F%E4%B8%BB%E6%9C%BA%E7%94%A8%E6%88%B7%E6%96%B9%E6%B3%95)）

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-3.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-3.jpg" width="450" /></a>

4. 询问是否添加`MySQL`数据库

    1）默认不删除，如果需要删除请输入`y`    
    2）然后输入MySQL的Root密码。（注意是ROOT用户密码）

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-4.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-4.jpg" width="450" /></a>

5. 请输入需要删除的`MySQL`数据库名

    1）`MySQL`数据库名默认为您的虚拟主机帐号    
    2）一次只能删除一个数据库，这点请注意。

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-5.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-5.jpg" width="450" /></a>

6. 请输入网站域名

    1）注意是域名不包含`WWW`    
    2）脚本会自动判断，您输入的域名是否存在。
    
    <a href="http://wangyan.org/pic/l/lanmp-vh_del-6.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-6.jpg" width="450" /></a>

7. 请选择服务器架构

    1）这里默认值为`3`，选择`3`是删除最彻底的。

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-7.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-7.jpg" width="450" /></a>

8. 选择是否删除二级子域名？

    注意：一次只能删除一个，要么是删除一级域名（`wangyan.org`)，要么是删除二级子域名(`bbs.wangyan.org`)。

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-8.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-8.jpg" width="450" /></a>

9. 最后一步，按任意键开始删除虚拟主机用户。

    注意：任意键可不包括主机电源键。。。     
    按 `<Ctrl> + c` 可放弃删除。

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-9.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-9.jpg" width="450" /></a>

## 三、结束

* 安装结束后，可看到下图。
* 上半部分的意思是运行`nginx -t`和`apache -t`命令测试NGINX和APACHE删除用户是否成功，OK就表示成功了。
* 下半部分是给出了该虚拟主机用户的账户信息。
* 再最后？没有了，已经大功告成了。

    <a href="http://wangyan.org/pic/l/lanmp-vh_del-10.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_del-10.jpg" width="450" /></a>

## 四、反馈

如果删除虚拟主机用户失败，请将出错页面截图发给我。    
或者通过下面方式与我联系，谢谢！

> Email: [WangYan@188.com](WangYan@188.com)    
> Twitter：[@wang_yan](https://twitter.com/wang_yan)    
> Home Page: [WangYan Blog](http://wangyan.org/blog)    