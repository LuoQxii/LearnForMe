## 安装部署

SQLite 是一种嵌入式数据库，不需要独立的服务器进程，直接访问存储在磁盘上的数据库文件，部署简单。

### 安装（Windows）

1. 访问 [SQLite 官方下载页面](https://www.sqlite.org/download.html)
2. 下载 `sqlite-tools-win32-x86-*.zip`
3. 解压后将 `sqlite3.exe` 所在目录添加到系统环境变量 `PATH` 中

### 创建数据库文件

SQLite 使用单个文件作为数据库。创建一个新数据库（例如 `wealth.db`）：

```bash
sqlite3 wealth.db
```

执行后进入 SQLite 交互式 shell，同时创建名为 `wealth.db` 的文件（若数据库存在则直接打开）。

> **注意**：只要执行 `sqlite3 数据库名.db` 且命令行进入 `sqlite>` 交互模式，数据库文件就已创建。若想看到实际内容，需要在交互模式里创建表、插入数据。