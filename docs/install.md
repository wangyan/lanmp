## 一、系统需求

* 需要`2GB`以上磁盘剩余空间
* 需要`256M`以上内存空间
* 服务器必须配置好软件源和可连接外网
* 必须具有系统`Root`权限
* 建议使用干净系统全新安装

## 二、安装前准备

1. 使用`putty`或`Bitvise Tunnelier`等`SSH`工具登陆

    登陆后运行：`screen -S lanmp`

    1）关于`screen`请自行`Google`，简单说该命令可以防止网络中断等因素造成的安装失败。  
    2）如果提示`screen`命令不存在可以执行：`yum -y install screen` 安装。  

2. 下载`LANMP`一键安装包

    说明：稳定版是相对稳定的版本，开发版是更新频率较高的版本，带有新特性，但可能存在较多Bug。

    方法一：直接下载已打包版本
    
    1）下载稳定版：`wget -c http://wangyan.org/download/lanmp/lanmp-latest.tar.gz`  
    2）或者下载开发版：`wget -c http://wangyan.org/download/lanmp/lanmp-dev-latest.tar.gz`  
    2）开始安装：`cd lanmp && ./install.sh`  
    
    方法二：通过Git下载（推荐）

    1）安装`Git`软件：`yum -y install git`  
    2）开始克隆：`git clone https://github.com/wangyan/lanmp.git`  
    3）安装稳定版： `cd lanmp && ./install.sh`  
    4）或者安装开发版： `cd lanmp && git checkout develop && ./install.sh`  

## 三、安装步骤

1. 输入服务器公网IP地址(IPv4)

    脚本默认会自动获取IP地址，如果发现不准确，请手工输入。

    <a href="http://wangyan.org/pic/l/lanmp-setup-1.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-1.jpg" width="450" /></a>

2. 输入默认网站目录

    默认网站路径是 `/var/www`，虚拟主机数据目录是 `/home`，所以此项一般保持默认不要改动。

    <a href="http://wangyan.org/pic/l/lanmp-setup-2.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-2.jpg" width="450" /></a>

3. 输入`MySQL`数据库`Root`用户密码

    `MySQL`数据库`Root`最高权限用户密码，为安全起见，请尽可能使用复杂密码。

    <a href="http://wangyan.org/pic/l/lanmp-setup-3.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-3.jpg" width="450" /></a>

4. 输入`MySQL`数据库`PMA`用户密码

    `PMA`用户是为了让phpMyAdmin支持额外的链接表特性，该密码仅在安装时使用一次，因此你可以使用随机密码。

    <a href="http://wangyan.org/pic/l/lanmp-setup-4.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-4.jpg" width="450" /></a>

5. 请选择服务器架构 （重要）

    1）单独 `Nginx`（`lnmp`）：效率高，但不兼容`Apache`的`Rewrite`规则，低内存微型用户首选。    
    2）单独 `Apache` (`lamp`)：经典组合，兼容性好，几乎所有程序都支持。    
    3）`Apache` + `Nginx (`lanmp`)：`Nginx`作为前端处理静态文件，`Php`脚本转后端`Apache`处理，该架构可发挥`Nginx`处理静态文件优势，还可以作负载均衡，个人推荐。

    <a href="http://wangyan.org/pic/l/lanmp-setup-5.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-5.jpg" width="450" /></a>

6. 选择安装的`PHP`版本

    默认是`PHP 5.4`系列，但有些程序需要旧版Zend支持如`ShopEX`，所以也可以安装旧版`PHP 5.2`系列

    <a href="http://wangyan.org/pic/l/lanmp-setup-6.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-6.jpg" width="450" /></a>

7. 是否要初始化阿里云服务器（选做）

    1）程序会自动判断你是否使用的是阿里云服务器，非阿里云用户不会出现该选项。  
    2）如果选择是(y)，那么程序会格式化数据盘，并挂载到/home目录。（适用于初次安装或重装系统后的用户）  

    <a href="http://wangyan.org/pic/l/lanmp-setup-7.png"><img src="http://wangyan.org/pic/l/lanmp-setup-7.png" width="450" /></a>

8. 选择是否安装的`xCache`加速器

    可大幅提高PHP性能，不需要犹豫，立即安装吧！这货甚至比`eaccelerator`还牛逼。

    <a href="http://wangyan.org/pic/l/lanmp-setup-8.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-8.jpg" width="450" /></a>

9. 选择是否安装的`ioncube`

    PHP解密工具，类似于`Zend Optimizer`，如果你不玩`WHMCS`，可以不装。

    <a href="http://wangyan.org/pic/l/lanmp-setup-9.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-9.jpg" width="450" /></a>

10. 选择是否安装的`Zend Optimizer`

    如果您用的是开源程序，则可以不装。    
    注意：如果您上面选择安装的PHP版本是5.2，那么这里自动安装`Zend Optimizer`，否则自动安装`Zend GuardLoader`

    <a href="http://wangyan.org/pic/l/lanmp-setup-10.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-10.jpg" width="450" /></a>

11. 最后一步，按任意键开始安装。

    注意：任意键可不包括主机电源键。。。 
    按 `<Ctrl> + c` 可放弃安装。

    <a href="http://wangyan.org/pic/l/lanmp-setup-11.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-11.jpg" width="450" /></a>

## 四、结束

* 安装结束后，可看到下图，意思很明确了，请谨记该图中的帐号信息。    
* 在浏览器中打开图中所示的PHP探针地址，如：`http://192.168.8.134/p.php`，即可看到整个安装过程是否成功。
* 部分VPS装有`iptables`防火墙，请使用下面命令关闭。`service iptables stop && chkconfig iptables off`
* 安装失败的，请按下面提示进行反馈，谢谢！

    <a href="http://wangyan.org/pic/l/lanmp-setup-12.jpg"><img src="http://wangyan.org/pic/l/lanmp-setup-12.jpg" width="450" /></a>

## 五、反馈

如果安装失败，请您将安装目录下的`log.txt`日志文件发给我分析。    
或者通过下面方式与我联系，谢谢！

> Email: [WangYan@188.com](WangYan@188.com)    
> Twitter：[@wang_yan](https://twitter.com/wang_yan)    
> Home Page: [WangYan Blog](http://wangyan.org/blog)    