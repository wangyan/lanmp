## 一、概述

* 安装完成后请添加首个虚拟主机用户（`/home/user1`），不建议您直接将网站放置在默认的网站目录`/var/www`。
* 本教程会分两种情况讲解。一种是`lnmp`架构，另外一种是`lamp`和`lanmp`架构。
* `LANMP` 指的是 `Linux` + `Apache` + `Nginx` + `MySQL` + `PHP` 运行环境。 （[了解更多](https://github.com/wangyan/lanmp/wiki/LANMP-%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85%E5%8C%85%E7%AE%80%E4%BB%8B)）

## 二、添加虚拟主机用户（共同步骤）

1. 进入安装目录并运行添加虚拟主机脚本

        cd lanmp/
        ./vhost_add.sh

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-2_1.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-2_1.jpg" width="450" /></a>

2. 请输入虚拟主机用户帐号

    用户目录位于`/home/username`，另外该帐号会作为默认的数据库用户名和数据库名（可修改）

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-2_2.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-2_2.jpg" width="450" /></a>

3. 询问是否添加`FTP`帐号

    注意：添加`FTP`帐号的前提是，你已经安装了`pureftpd`并且安装了`pureftpd`图像管理界面。（本人有提供一键安装脚本）

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-2_3.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-2_3.jpg" width="450" /></a>

4. 询问是否添加`MySQL`数据库

    1）默认不添加，如果需要添加请输入`y`    
    2）然后输入MySQL的Root密码。（注意是ROOT用户密码）

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-2_4.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-2_4.jpg" width="450" /></a>

5. 请输入`MySQL`数据库名及用户密码

    1）`MySQL`数据库名和数据库用户名，默认为您的虚拟主机帐号    
    2）如果您上面添加了FTP用户，那么默认的密码为FTP密码，否则为123456

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-2_5.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-2_5.jpg" width="450" /></a>

6. 请输入网站域名

    1）注意是域名不包含`WWW`    
    2）脚本会自动判断，您输入的域名是否已经添加过。
    
    <a href="http://wangyan.org/pic/l/lanmp-vh_add-2_6.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-2_6.jpg" width="450" /></a>

## 三、添加虚拟主机用户（`LNMP`）

> 注意：该部分教程仅适用单独使用`Nginx`用户（`lnmp`）    
> 如果您当时安装的是`lamp`或`lanmp`架构，请跳过此节，直接移步到第四部分。

1. 请选择服务器架构

    1）注意：这里要输入`1`    
    2）单独使用`NGINX`的特点是，效率高，但不兼容`Apache`的`Rewrite`规则，低内存微型用户首选。

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-3_1.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-3_1.jpg" width="450" /></a>

2. 请选择是否载入NGINX `rewrite`规则？

    默认值为`否`，如果您程序需要支持`伪静态`，请输入`y`

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-3_2.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-3_2.jpg" width="450" /></a>

3. 请选择预置的`rewrite`规则 （可选步骤）

    1）Nginx和Apache的重写规则不同，你需要单独定义，这里提供一些常见的规则供您选择。    
    2）目前已经预置的规则有：`wordpress`、`discuzx`、`discuzx`、`ecshop`、`sablog`、`typecho`    
    3）如果您输入的程序名`XXX`没有预置规则，则脚本自动在`/usr/local/nginx/conf/`目录创建`XXX.conf`文件，您需要另外编辑该文件。

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-3_3.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-3_3.jpg" width="450" /></a>

4. 选择是否添加二级子域名？

    注意：一次添加，要么是一级域名（`wangyan.org`)，要么是二级子域名(`bbs.wangyan.org`)。

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-3_4.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-3_4.jpg" width="450" /></a>

5. 最后一步，按任意键开始添加用户。

    注意：任意键可不包括主机电源键。。。     
    按 `<Ctrl> + c` 可放弃安装。

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-3_5.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-3_5.jpg" width="450" /></a>

## 四、添加虚拟主机用户（`LANMP`）

> 注意：该部分教程仅适用于使用`Apache`+`Nginx`用户（`lanmp`）    
> 如果您当时安装的是`lnmp`架构，请移步到上一节，即到第三部分。

1. 请选择服务器架构

    1）注意：这里要输入`3`    
    2）使用`Apache` + `Nginx (`lanmp`)的特点是，Nginx`作为前端处理静态文件，`Php`脚本转后端`Apache`处理，该架构可发挥`Nginx`处理静态文件优势，还可以作负载均衡，个人推荐。

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-4_1.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-4_1.jpg" width="450" /></a>

2. 选择是否添加二级子域名？

    注意：一次添加，要么是一级域名（`wangyan.org`)，要么是二级子域名(`bbs.wangyan.org`)。

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-4_2.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-4_2.jpg" width="450" /></a>

3. 最后一步，按任意键开始添加用户。

    注意：任意键可不包括主机电源键。。。     
    按 `<Ctrl> + c` 可放弃安装。

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-4_3.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-4_3.jpg" width="450" /></a>

## 五、结束

* 安装结束后，可看到下图。
* 上半部分的意思是运行`nginx -t`和`apache -t`命令测试NGINX和APACHE添加用户是否成功，OK就表示成功了。
* 下半部分是给出了该虚拟主机用户的账户信息，请谨记。
* 最后，在浏览器中输入该该虚拟主机用户的域名，如：`http://example.com`，如果看到`example.com`则表示一切正常。
* 再最后？没有了，已经大功告成了。
* 安装失败的，请按下面提示进行反馈，谢谢！

    <a href="http://wangyan.org/pic/l/lanmp-vh_add-5_1.jpg"><img src="http://wangyan.org/pic/l/lanmp-vh_add-5_1.jpg" width="450" /></a>

## 六、反馈

如果添加虚拟主机用户失败，请您运行`nginx -t`和`apache -t`命令，然后将截图发给我。    
或者通过下面方式与我联系，谢谢！

> Email: [WangYan@188.com](WangYan@188.com)    
> Twitter：[@wang_yan](https://twitter.com/wang_yan)    
> Home Page: [WangYan Blog](http://wangyan.org/blog)    