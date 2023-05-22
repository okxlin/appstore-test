## 1.简介
这是一些适配`1Panel`商店`2.0`版本的docker应用配置。


## 2.使用方式

默认`1Panel`安装在`/opt/`路径下，如果不是按需修改以下。


### 2.1 
- 当`/opt/1panel/resource/apps/local`文件夹下没有任何内容，则可以

```shell
git clone -b  localApps https://github.com/okxlin/appstore /opt/1panel/resource/apps/local
```
然后应用商店刷新本地应用即可。

###  2.2
-  当`/opt/1panel/resource/apps/local`文件夹下已经存在文件内容，

```shell
cd /opt/1panel/resource/apps/local  # 进入目标目录

wget https://github.com/okxlin/appstore/archive/refs/heads/localApps.zip  # 从GitHub下载ZIP文件

unzip localApps.zip  # 解压下载的ZIP文件

cd appstore-localApps  # 进入解压后的目录

mv ./* ..  # 将所有文件和目录移动到父目录中

cd /opt/1panel/resource/apps/local  # 进入目标目录

rm -r /opt/1panel/resource/apps/local/appstore-localApps  # 删除解压后的目录及其内容

rm /opt/1panel/resource/apps/local/localApps.zip  # 删除下载的ZIP文件

```


然后应用商店刷新本地应用即可。


## 3.备注

**未显示在本地应用列表里的，表示未完全适配应用商店面板操作**

**但是支持直接终端运行。**

以rustdesk为例

```shell
# 进入 rustdesk 的最新版本目录
cd /opt/1panel/resource/apps/local/rustdesk/versions/latest/

# 复制 .env.sample 为 .env
cp .env.sample .env

# 编辑 .env 文件，修改参数
nano .env

# 启动 RustDesk
docker-compose up -d

# 查看连接所需密钥
cat ./data/hbbs/id_ed25519.pub

```
