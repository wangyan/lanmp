#Lanmp 组件升级说明

## 一、概述

* Lanmp 现已支持自动升级，程序会查找当前版本和最新版本，并提示你是否升级。  
* 升级有风险，请务必做好所有数据备份，注意是所有重要数据，包括mysql数据。  

## 二、升级步骤

1. 输入默认网站目录

    这里要输入您当时选择的目录，如果您当时没有修改，则保持默认网站路径 `/var/www`。  

    <a href="http://wangyan.org/pic/l/lanmp-upgrade-1.png"><img src="http://wangyan.org/pic/l/lanmp-upgrade-1.png" width="450" /></a>  

2. 请选择服务器架构

    这里不能乱填，如果您安装时是选择`3`，那么这里也要选择`3`  

    <a href="http://wangyan.org/pic/l/lanmp-upgrade-2.png"><img src="http://wangyan.org/pic/l/lanmp-upgrade-2.png" width="450" /></a>  

3. 询问是否需要升级PHP

    如下图，程序已成功获取已安装PHP版本是`5.2.17p1`，最新PHP版本是`5.4.7`，于是询问你是否需要升级。  

    请注意：目前不支持从PHP 5.2系列跳跃升级到5.4系列。（下图仅作为演示）  

    <a href="http://wangyan.org/pic/l/lanmp-upgrade-3.png"><img src="http://wangyan.org/pic/l/lanmp-upgrade-3.png" width="450" /></a>  

4. 询问是否需要升级xCache组件

   一般默认升级，xCache可是个好东西。 ^_^

    <a href="http://wangyan.org/pic/l/lanmp-upgrade-4.png"><img src="http://wangyan.org/pic/l/lanmp-upgrade-4.png" width="450" /></a>  

5. 询问是否需要升级Nginx

    如下图，程序已成功获取已安装Nginx版本是`1.3.5`，最新Nginx版本是`1.3.6`，于是询问你是否需要升级。  

    <a href="http://wangyan.org/pic/l/lanmp-upgrade-5.png"><img src="http://wangyan.org/pic/l/lanmp-upgrade-5.png" width="450" /></a>  

6. 询问是否需要升级phpMyAdmin

    如下图，程序已成功获取已安装phpMyAdmin版本是`3.5.2.1`，最新phpMyAdmin版本是`3.5.2.2`，于是询问你是否需要升级。  

    <a href="http://wangyan.org/pic/l/lanmp-upgrade-6.png"><img src="http://wangyan.org/pic/l/lanmp-upgrade-6.png" width="450" /></a>  

## 三、反馈

如果您升级失败，请您运行`nginx -t`和`apache -t`命令，查找原因。    
或者通过下面方式与我联系，谢谢！

> Email: [WangYan@188.com](WangYan@188.com)    
> Twitter：[@wang_yan](https://twitter.com/wang_yan)    
> Home Page: [WangYan Blog](http://wangyan.org/blog)    