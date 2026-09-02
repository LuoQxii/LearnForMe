# GitHub 仓库使用指南

## 一、网页端创建仓库

1. 登录 [GitHub 官网](https://github.com/)，右上角点击 **+** → `New repository`
2. 填写仓库信息：

| 字段 | 说明 |
| :-- | :-- |
| **Repository name** | 仓库名称（必填，不能含中文空格） |
| **Description** | 仓库简介（可选） |
| **Public / Private** | 公开 / 私有仓库 |
| **Add a README file** | 推荐勾选，自动生成说明文件 |
| **Add .gitignore** | 可选，选择开发语言自动生成忽略文件 |
| **Add license** | 可选，选择开源协议 |

3. 点击底部 `Create repository` 创建完成

---

## 二、本地初始化（两种方式）

### 方式 1：本地已有项目，关联 GitHub 空仓库（最常用）

```bash
# 1. 进入本地项目文件夹，初始化 Git 仓库
git init

# 2. 将所有文件加入暂存区
git add .

# 3. 提交本地版本
git commit -m "第一次提交：初始化项目"

# 4. 绑定远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/用户名/仓库名.git

# 5. 推送代码到远程主分支
git push -u origin main
```

> **注意**：旧版本 git 默认分支叫 `master`，如果推送报错则把 `main` 换成 `master`。

### 方式 2：全新空白项目，直接克隆远程仓库到本地

```bash
# 1. 克隆仓库到本地
git clone https://github.com/用户名/仓库名.git

# 2. 进入仓库文件夹
cd 仓库名

# 3. 新建文件后提交推送
git add .
git commit -m "初始化"
git push
```

---

## 三、补充说明

### 空仓库初始化命令

如果创建仓库时未勾选 `Add a README`，GitHub 会给出官方初始化命令，直接复制运行即可：

```bash
echo "# test" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/xxx/xxx.git
git push -u origin main
```

### SSH 免密推送

配置 SSH 密钥后，使用 SSH 地址克隆/推送，无需重复输入账号密码。

### 常见报错

| 报错信息 | 原因 | 解决方案 |
| :-- | :-- | :-- |
| `fatal: remote origin already exists` | 已绑定远程仓库 | 执行 `git remote remove origin` 删除旧远程再重新绑定 |
| 推送权限不足 | HTTPS 方式需认证 | 使用 GitHub 个人令牌（token）替代密码登录 |

---

## 四、远程仓库管理

### 查看远程仓库

```bash
# 1. 简略查看（只显示远程名称 + 地址，最常用）
git remote -v

# 2. 只查看远程别名（极简）
git remote

# 3. 查看单个远程仓库详细信息（分支追踪、推送拉取配置等）
git remote show origin
```

`git remote -v` 输出示例：

```
origin  https://github.com/xxx/demo.git (fetch)
origin  https://github.com/xxx/demo.git (push)
```

| 字段 | 说明 |
| :-- | :-- |
| `origin` | 远程仓库别名（默认都叫 origin） |
| `fetch` | 拉取代码地址 |
| `push` | 推送代码地址 |

### 常用操作

| 操作 | 命令 |
| :-- | :-- |
| 删除已绑定的远程仓库 | `git remote remove origin` |
| 修改远程仓库地址 | `git remote set-url origin 新仓库地址` |
| 添加多个远程仓库 | `git remote add 别名 仓库地址` |

---

## 极简流程总结

```
网页新建仓库 → 本地 git init → add & commit → 绑定 remote origin → push 到远程
```
