# Docsify 搭建教程

本知识库基于 [Docsify](https://docsify.js.org/) 搭建，以下是完整的搭建流程。

## 1. 环境准备

确保电脑已安装 Node.js 和 npm：

```bash
node -v
npm -v
```

若未安装，从 [Node.js 官网](https://nodejs.org/) 下载安装包，双击 `.msi` 文件按向导完成安装。安装时确保勾选 **Add to PATH** 选项。

## 2. 安装 Docsify

借助 npm 全局安装 docsify-cli 工具：

```bash
npm install -g docsify-cli
```

## 3. 创建项目目录

```bash
mkdir my-knowledge-base
cd my-knowledge-base
```

## 4. 初始化项目

```bash
docsify init ./docs
```

初始化后，`docs` 文件夹中会生成以下文件：

| 文件 | 说明 |
| :-- | :-- |
| `index.html` | 项目入口文件 |
| `README.md` | 知识库首页内容 |
| `.nojekyll` | 阻止 GitHub Pages 对项目进行不必要的处理 |

## 5. 本地预览

```bash
docsify serve docs
```

浏览器访问 `http://localhost:3000` 即可看到知识库页面。

## 6. 配置侧边栏

在 `docs` 目录下创建 `_sidebar.md` 文件，定义侧边栏结构：

```markdown
- [首页](README.md)
- [基础知识](basic/README.md)
  - [入门指南](basic/guide.md)
  - [常用命令](basic/commands.md)
- [高级技巧](advanced/README.md)
  - [插件开发](advanced/plugins.md)
  - [主题定制](advanced/themes.md)
- [常见问题](faq.md)
```

## 7. 部署至 GitHub Pages

### 推送代码

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/my-knowledge-base.git
git push -u origin master
```

### 配置 GitHub Pages

1. 进入仓库的 `Settings` → `Pages`
2. 在 `Source` 中选择 `master branch /docs folder`
3. 等待部署完成，访问生成的 URL（如 `https://yourusername.github.io/my-knowledge-base`）
