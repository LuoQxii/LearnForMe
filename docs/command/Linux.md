## 压缩命令

> tar命令（tar格式只是将文件打包，并没有压缩。bz2的压缩率最高）  

> **压缩**  
tar -cvf [文件名].tar [文件目录]   //打包成.tar文件  
tar -jcvf [文件名].tar.bz2 [文件目录]   //打包成.bz2文件  
tar -zcvf [文件名].tar.gz [文件目录]   //打包成.gz文件  

> 解压缩  
tar -xvf [文件名].tar   //解压到当前文件  
tar -xvf [文件名].tar -C [文件目录]   //将.tar文件解压到指定目录  
tar -jxvf [文件名].tar.bz2 -C [文件目录]   //解压.bz2文件到指定目录  
tar -zxvf [文件名].tar.gz -C [文件目录]   //解压.gz文件到指定目录  

> 参数说明
-c 建立新的压缩文件  
-C 指定解压目录，该目录必须存在  
-x 从压缩的文件中提取文件  
-j 支持bzip2解压文件  
-f 指定压缩文件  
-v 显示操作过程  
-z 支持gzip解压文件  

---
## 上传与下载命令(ZMODEM协议)
> 上传命令：rz -bye  
> 下载命令：sz file1 file2 file3  
> 安装命令：yum install lrzsz -y  
---
## 日期时间命令
> 设置时区：timedatectl set-timezone "Asia/Shanghai"  
> 修改日期时间：  
date -s MM/DD/YY  
date -s "hh:mm:ss"  
---
## 环境变量
> 查看环境变量：env  
> 环境变量文件：cat /etc/profile  
> 修改环境变量：vi /etc/profile  
export PATH=$PATH:路径  
> 使修改的环境变量生效：source /etc/profile  
检查环境变量是否生效：echo $PATH
---
## 挂载
> 启动nfs服务：systemctl start nfs.service  
重启nfs服务：systemctl restart nfs.service  
启动rpcbind服务：systemctl start rpcbind.service  
记录允许挂载授权信息：/etc/exports  
记录挂载点配置文件：/etc/fstab  
强制解除挂载：umount -f [路径]  
恢复挂载：umount -a  

> linux挂载windows：mount -t cifs -o username="用户名",password="密码",uid=2001,gid=2001 //windowsIP/windows路径  /linux路径
---
## 防火墙
> 设置开机启用防火墙：systemctl enable firewalld.service  
设置开机禁用防火墙：systemctl disable firewalld.service  
启动防火墙：systemctl start firewalld  
关闭防火墙：systemctl stop firewalld  
检查防火墙状态：systemctl status firewalld  
---
## 网络端口
> nc命令  
机器一：nc -ul port 打开端口  
机器二：nc -u ip port 建立连接  
输入任意内容，若收到相应内容，则通  

>netstat 是一个命令行工具，可以提供有关网络连接的信息  
-t – 显示 TCP 端口  
-u – 显示 UDP 端口  
netstat -anp    
netstat -tnlp | grep :80
---
## 清理缓存
> echo 1 > /proc/sys/vm/drop_caches  
echo 2 > /proc/sys/vm/drop_caches  
echo 3 > /proc/sys/vm/drop_caches  
---
## yum指定本地源
> yum仓库配置文件所在目录：cd /etc/yum.repos.d/（只保留Local）  
禁用subscription-manager插件：vi /etc/yum/pluginconf.d/subscription-manager.conf（将参数改为0）  
清理所有的yum缓存：yum clean all  
重新生成yum缓存：yum makecache  
---
## 命令安装
> 安装nfs和rpcbind服务：yum install rpcbind nfs-utils  
> 安装gdb应用包(包含gcore命令)：yum -y install gdb  
> 获取zip/unzip命令安装列表：yum list|grep zip/unzip  
> 安装zip：yum install zip  
> 安装unzip：yum install unzip  
安装lsof命令：yum install lsof  
