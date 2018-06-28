# EnvAutoDeploy自动部署工具使用说明

## 1.介绍

EnvAutoDeploy可以自动化部署 *DPrice* 和 *DBestBuy* 的编译、运行环境。可以分别或联合部署，方便使用。

## 2.准备
### 2.1 下载EnvAutoDeploy
本工具位于[FTP](ftp://10.221.148.94/C++/env/EnvAutoDeploy_v0.1.tar.gz)和[SVN](svn://10.221.148.94/EnvAutoDeploy)

可以通过如下命令下载到本机
```bash
curl -o EnvAutoDeploy_v0.1.tar.gz ftp://pricFtp:pricFtp2018@10.221.148.94:21/C++/env/EnvAutoDeploy_v0.1.tar.gz
```
### 2.2 解压缩
解压缩
```bash
tar xzvf EnvAutoDeploy_v0.1.tar.gz
```
### 2.3 配置变量
通过如下命令打开makeconfig.sh文件
```bash
cd EnvAutoDeploy
vim ./makeconfig.sh
```
需要配置的变量如下：
```bash
## some string variables need to config
FARE_DIRRUN=/DATA/test/todefare       #这是运行环境的安装路径
FARE_DIRCODE=/home/rdtfare/test2/src  #这是代码的保存路径
INTER_SVR_NAME=PRIC_PF35              #内部服务名，可随意修改
OUTER_SVR_NAME_PRICE=ODP              #对外暴露的Price服务名，不得超过6个字符
OUTER_SVR_NAME_BESTBUY=ODB            #对外暴露的Bestbuy服务名，不得超过6个字符，且不得与Price重名
PORT_OUTER_WSL=43000                  #WSL的端口号，一般无需修改
PORT_OUTER_JSL=44000                  #JSL的端口号，一般无需修改
PORT_INTER_TSMA=22222                 #tsma内部使用的端口号，一般无需修改
PORT_INTER_TSMC=22221                 #tsmc内部使用的端口号，一般无需修改
PORT_INTER_MPNODE=53000               #内部使用的端口号，一般无需修改
```
请根据实际情况配置

## 3.安装
### 3.1 可选安装参数
直接调用makeconfig.sh可以看到如下参数列表
```bash
./makeconfig.sh

must have 1 argument and be limited to string list below:
install_old_price          :install old price
install_old_bestbuy        :install old bestbuy
install_old_all            :install old price and old bestbuy
uninstall                  :uninstall all
```
### 3.2 *price*安装
#### 3.2.1 安装
```bash

#调用makeconfig.sh,此步骤完成运行时下载、price源码下载、创建软连接、输出配置文件
./makeconfig.sh install_old_price 

#加载环境变量
source {{FARE_DIRRUN}}/shell/setenv.tosf.sh 

 #编译源代码并安装
cd {{FARE_DIRCODE}}/dprice   
./replace cover

#启动tsma和tsmc
cd {{FARE_DIRRUN}}/shell     
./start.sh

#加载tsconfig.xml
cd {{FARE_DIRRUN}}/config    
tsloadcf -f tsconfig.xml

#启动服务
tsboot -y                    
```

#### 3.2.2 测试
[price测试页面](http://10.221.155.82:8011/test/tuxedo/project/11)
修改访问ip和端口、修改服务名、勾选TODE进行测试

### 3.3 *bestbuy*安装
#### 3.3.1 安装
```bash

#调用makeconfig.sh,此步骤完成运行时下载、price源码下载、创建软连接、输出配置文件
./makeconfig.sh install_old_bestbuy 

#加载环境变量
source {{FARE_DIRRUN}}/shell/setenv.tosf.sh 

 #编译源代码并安装
cd {{FARE_DIRCODE}}/dbestbuy   
./replace cover

#启动tsma和tsmc
cd {{FARE_DIRRUN}}/shell     
./start.sh

#加载tsconfig.xml
cd {{FARE_DIRRUN}}/config    
tsloadcf -f tsconfig.xml

#启动服务
tsboot -y                    
```
#### 3.3.2 测试
[bestbuy测试页面](http://10.221.155.82:8011/test/tuxedo/425)
修改访问ip和端口、修改服务名、勾选TODE进行测试
### 3.4 *price*和*bestbuy*联合安装
#### 3.4.1 安装
```bash

#调用makeconfig.sh,此步骤完成运行时下载、price源码下载、创建软连接、输出配置文件
./makeconfig.sh install_old_all

#加载环境变量
source {{FARE_DIRRUN}}/shell/setenv.tosf.sh 

 #编译源代码并安装
cd {{FARE_DIRCODE}}/dprice   
./replace cover

cd {{FARE_DIRCODE}}/dbestbuy   
./replace cover

#启动tsma和tsmc
cd {{FARE_DIRRUN}}/shell     
./start.sh

#加载tsconfig.xml
cd {{FARE_DIRRUN}}/config    
tsloadcf -f tsconfig.xml

#启动服务
tsboot -y                    
```
#### 3.4.2 测试
[price测试页面](http://10.221.155.82:8011/test/tuxedo/project/11)
[bestbuy测试页面](http://10.221.155.82:8011/test/tuxedo/425)
修改访问ip和端口、修改服务名、勾选TODE进行测试

### 3.5 卸载
调用makeconfig.sh
```bash
./makeconfig.sh uninstall
```
删除{{FARE_DIRRUN}}和{{FARE_DIRCODE}}下的所有文件
## 4.原理及扩展
### 4.1组成
EnvAutoDeploy自动部署工具包括如下组成部分
#### 4.1.1 编译运行库
所用到的所有库都存放的FTP服务器，使用时通过curl直接下载，具体的运行库见下表
|库名|FTP地址|说明|
|:-:|:-:|:-:|
|boost|ftp://10.221.148.94/C++/env/lib/boost.tar.gz||
|icu|ftp://10.221.148.94/C++/env/lib/icu.tar.gz||
|tode|ftp://10.221.148.94/C++/env/lib/tode_2.2.1_linux64_rhel6.3.tar.gz||
|tosf|ftp://10.221.148.94/C++/env/lib/tosf_4.1.5_linux64_rhel6.3.tar.gz||
|xerces|ftp://10.221.148.94/C++/env/lib/xerces.tar.gz||
|ora11g|ftp://10.221.148.94/C++/env/lib/ora11g/ora11g.tar.gz_a*|从ora11g.tar.gz_aa-ora11g.tar.gz_an共14个切片压缩包|

#### 4.1.2 代码库
##### 4.1.2.1 *DPrice* 源代码及修改
所用到 *DPrice* 源代码来自于Git代码(ssh://git@rdgit.travelsky.com:7999/dfare/dprice.git)的 *master* 分支 *26ef272dcf6* commit("first time @2018-02-08")并对其进行如下修改

- 删除所有*.so、*.o文件
- 将根目录下的fare_cache_mng和fare_cache_ser移至bin目录下
- 将沈阳的运行版本的liboc.so.4.2、liberr.so.5.1、libafpp.so.2.1复制到bin目录下
- 修改makefile_front_linux，将Line 6 的TOSF_HOME注释掉
- 修改makefile_display_linux，将Line 6 的TOSF_HOME注释掉
- 修改makefile_pricing_linux，将Line 5 的TOSF_HOME注释掉

并将其打包，并存放于 ftp://10.221.148.94/C++/env/src/dprice_2018_02_08_master.tar.gz

##### 4.1.2.2 *DBestBuy* 源代码及修改
所用到 *DBestBuy* 源代码来自于Git代码(ssh://git@rdgit.travelsky.com:7999/dfare/dbestbuy.git)的 *master* 分支 *77ad8fbb709* commit("first time @2018-02-08")并对其进行如下修改

- 将沈阳的运行版本的fare_cache_mng和fare_cache_ser移至bin目录下
- 修改makefile_tode，将Line 17-22 的ORACLE_HOME、BOOST_HOME、XERCES_HOME、TODEHOMEDIR、TOSF_HOME、TOSFTOOLS_HOME注释掉
- 修改[dbestbuy]\src\Front\Controller\farefercvplugin.cc中Line107 "PATSVC" 为"BBPATSVC"
- 修改[dbestbuy]\src\Front\Controller\farefercvplugin.cc中Line133 "ERRSVC" 为"BBERRSVC"
- 修改[dbestbuy]\src\Front\Controller\farefercvplugin.cc中Line 15 conf = "./T_FARE.cfg"; 为conf += ".cfg";
- 修改[dbestbuy]\src\Front\Controller\farefesndplugin.cc中Line 15 conf = "./T_FARE.cfg"; 为conf += ".cfg";
- 修改[dbestbuy]\src\Engine\ErrorEngine\errorplugin.cc中Line 19 conf = "./T_FARE.cfg"; 为conf += ".cfg";
- 修改[dbestbuy]\src\Engine\PricingEngine\Controller\patplugin.cc中Line 16 conf = "./T_FARE.cfg"; 为conf += ".cfg";

并将其打包，并存放于 ftp://10.221.148.94/C++/env/src/dbestbuy_2018_02_08_master.tar.gz

#### 4.1.3 脚本工具及模板文件
- 模板文件存于templates文件夹下，多为配置文件的模本
- makeconfig.sh 此脚为主要工具，会通过curl下载所需的lib和src，修改模板文件为适用的配置文件并分发到正确的位置

并将其打包，并存放于 ftp://10.221.148.94/C++/env/EnvAutoDeploy_v0.1.tar.gz

同时源码保存于 svn://10.221.148.94/EnvAutoDeploy
###4.2 扩展
在makeconfig.sh的 Line 279-307 为主函数，如果需要扩展安装参数可以从这里开始。