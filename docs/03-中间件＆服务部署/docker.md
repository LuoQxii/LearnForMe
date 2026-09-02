# Docker 与镜像仓库

## 一、Windows 安装 Docker Desktop

Docker Desktop 是 Windows 上官方推荐的 Docker 环境，内置了 `docker` 命令行工具、容器引擎等必要组件。

### 1. 检查系统要求

| 系统版本 | 支持方式 |
| :-- | :-- |
| Windows 10/11 专业版、企业版、教育版 | 支持 Hyper-V（推荐） |
| Windows 10/11 家庭版 | 需启用 WSL 2（不支持 Hyper-V） |

### 2. 启用必要功能

- 搜索并打开"启用或关闭 Windows 功能"
- 勾选 **Hyper-V** 及其子选项（管理工具和平台）
- 勾选 **适用于 Linux 的 Windows 子系统**
- 勾选 **虚拟机平台**
- 重启计算机完成安装

### 3. 下载并安装

访问 [Docker 官网](https://www.docker.com/) 下载 Windows 版安装包。安装时勾选：

- `Use WSL 2 instead of Hyper-V`（家庭版必选，专业版可选）
- `Add shortcut to desktop`

安装完成后启动 Docker，首次启动可能需要几分钟（后台初始化 WSL 2 环境）。

### 4. 验证安装

```bash
docker --version
# 成功输出示例：Docker version 24.0.5, build ced0996
```

---

## 二、创建阿里云镜像仓库

| 步骤 | 操作 |
| :-- | :-- |
| **开通服务** | 注册并登录 [阿里云控制台](https://account.aliyun.com/)，搜索"容器镜像服务（ACR）"，开通个人版实例（免费，需实名认证） |
| **访问凭证** | 在拉取/上传镜像前需 `docker login` 输入凭证，可选择 **固定密码** 作为访问凭证 |
| **创建命名空间** | ACR 控制台 → 左侧 **命名空间** → 新建（如 `my-namespace`，全局唯一） |
| **创建镜像仓库** | ACR 控制台 → 左侧 **镜像仓库** → 新建：选择命名空间，自定义仓库名，类型选 **私有**，代码源选 **本地仓库** |

---

## 三、在本地构建 Docker 镜像

> 需要先打开 Docker Desktop 才能在本地构建镜像。

### 1. 编写 Dockerfile

在项目根目录创建 `Dockerfile` 文件（待补充具体示例）。

### 2. 构建镜像

在命令行切换到项目主文件夹目录（需包含 Dockerfile）：

```bash
cd C:\path\to\your\js-project

# 构建镜像
docker build -t 镜像名称:版本号 .

# 查看本地镜像列表
docker images

# 运行容器测试应用
docker run -p 8080:3000 financial:v1
```

### 3. 推送镜像到仓库

```bash
# 登录镜像仓库
docker login --username=LUOQXI shanghai.personal.cr.aliyuncs.com

# 给镜像打标签（关联仓库地址）
docker tag [ImageId] shanghai.personal.cr.aliyuncs.com/space/financial:[镜像版本号]

# 推送镜像
docker push shanghai.personal.cr.aliyuncs.com/space/financial:[镜像版本号]
```

### 4. 验证与拉取

- **验证**：阿里云 ACR 控制台 → 对应镜像仓库 → 镜像版本，可见推送结果
- **拉取**：其他机器执行 `docker pull` 上述标签即可（私有仓库需先 `docker login`）
