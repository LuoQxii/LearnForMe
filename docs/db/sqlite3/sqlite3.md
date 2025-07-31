SQLite 是一种嵌入式数据库，部署相对简单，因为它不需要独立的服务器进程，而是直接访问存储在磁盘上的数据库文件。

### 1. Windows下载 SQLite3
  1. 访问 [SQLite 官方下载页面](https://www.sqlite.org/download.html)
  2. 下载 `sqlite-tools-win32-x86-*.zip`
  3. 解压后将 `sqlite3.exe` 所在目录添加到系统环境变量 `PATH` 中。

### 2. 创建数据库文件
SQLite 使用单个文件作为数据库。创建一个新数据库（例如 `wealth.db`）：
```bash
  sqlite3 wealth.db
```
这将进入 SQLite 交互式 shell，并创建一个名为 `wealth.db` 的文件，若数据库存在则打开数据库。
备注：只要执行 sqlite3 数据库名.db 且命令行进入 sqlite> 交互模式，数据库文件就已创建（除非路径、权限有问题）。若想看到 “实际内容”，需要在交互模式里创建表、插入数据，这样文件才会有实质内容体现～
### 3. 创建表结构
在 SQLite shell 中执行 SQL 命令创建表。
```sql
-- 创建新表
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT);

-- 插入数据
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');

-- 查询数据
SELECT * FROM users;
```
### 4.常用命令
```sql
.open new.db -- 连接到数据库/创建数据库并连接
.tables  -- 查看所有表
.schema [表名]  -- 查看表结构
.headers ON  -- 显示查询结果的列名
.mode column  -- 以列格式显示查询结果
.help  -- 查看所有命令行帮助
.quit 或 Ctrl + D  -- 退出sqlite
```

