## 一、简介

1.	`LANMP` 指的是 `Linux` + `Apache` + `Nginx` + `MySQL` + `PHP` 运行环境。
2.	`LANMP` 一键安装包是用 `Linux Shell` 语言编写的，用于在 `Linux` 系统(`Redhat`/`CentOS`/`Debian`/`Ubuntu`)上一键安装 `LANMP`环境的工具包。

## 二、特点与优势

1.	3种Web环境自由组合

	`lnmp`、`lamp`、`lanmp`（Nginx前端Apache后端）可自主选择，甚至安装完后还可以自由调整。

2.	最新版本软件包

	全部采用最新稳定版本的软件包，如`PHP 5.5`（可选择`PHP 5.2`）系列，`MySQL 5.5`系列。

3.	下载更智能更方便

	自动从官方地址下载最新稳定版本源码安装，如果官网挂了或被和谐了，可自动从备选地址下载最新版。

4.	完美多用户支持

	配套了虚拟主机用户添加和删除脚本，因此可用来做虚拟主机销售。（主网站位于`/var/www`目录，用户网站位于`/home/user1`、`/home/user2`...）

5.	完善的扩展支持

	除小型依赖库外，都尽可能从源码编译安装。如PHP支持了`gd`,`memcache`,`xcache`,`pdo mysql`等扩展。

6.	多种PHP处理方式

	`Nginx`以`FastCGI`方式解析`PHP`，`Nginx`+`Apache`可选以`php moudle`或`FastCGI`方式方式解析`PHP`。

7.	模块化安装流程

	模块化、清晰的安装流程，脚本非常易于理解，因此您可以很容易修改脚本。

8.	其他

	如`phpMyAdmin`支持额外的链接表特性，支持添加二级子域名，自定义`Rewrite`规则等等。

## 三、安装和使用

详细安装和使用说明请参阅 [《Wiki 文档》](https://github.com/wangyan/lanmp/wiki)

	yum -y install screen git
	screen -S lanmp
	git clone https://github.com/wangyan/lanmp.git
	cd lanmp && ./install.sh

虚拟主机管理

	cd lanmp/
	./vhost_add.sh #添加
	./vhost_del.sh #删除

## 四、注意事项

1.	可能会经常更新

	改进措施：日常更新会推送到`develop`分支，较稳定版本才推送到`master`主分支。

2.	可能会不兼容你的VPS

	改进措施：如果您安装失败，麻烦您将安装目录下的`log.txt`日志文件发给我分析 [WangYan@188.com](WangYan@188.com)

3.	针对512M内存的VPS进行了优化

	如果你的内存较低或更高，建议您要修改php或apache的配置文件。

## 五、联系方式

> Email: [WangYan@188.com](WangYan@188.com) （推荐）
> Gtalk: [myidwy@gmail.com](myidwy@gmail.com)    
> QQ：[89791172](http://wpa.qq.com/msgrd?v=3&uin=89791172&site=qq&menu=yes)    
> Twitter：[@wang_yan](https://twitter.com/wang_yan)    
> Home Page: [WangYan Blog](http://wangyan.org/blog)    