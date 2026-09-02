# 备份与恢复

本文档涵盖 SQL Server、MySQL、Oracle 三大数据库的备份与恢复方案。

---

## SQL Server

### 备份方法

#### 完整备份

备份数据库所有数据和结构，是其他备份的基础。

```sql
BACKUP DATABASE db TO DISK = 'D:\backup\db_YYYYMMDD.bak'
WITH STATS = 1, COMPRESSION;
```

| 参数 | 说明 |
| :-- | :-- |
| `TO DISK` | 备份文件存储路径，文件名格式建议为 `数据库名_日期.bak` |
| `WITH STATS = 1` | 每完成 1% 的备份进度显示一次统计信息 |
| `COMPRESSION` | 启用备份压缩 |

#### 差异备份

仅备份自上次完整备份后变化的数据，体积小、速度快。

```sql
BACKUP DATABASE db
TO DISK = 'D:\backup\db_diff.bak'
WITH DIFFERENTIAL, COMPRESSION;
```

#### 事务日志备份

备份自上次日志备份后产生的事务日志，支持时点恢复。

```sql
BACKUP LOG db
TO DISK = 'D:\backup\db_log.trn'
WITH COMPRESSION;
```

#### 图形界面操作

通过 SSMS 右键数据库 → **任务** → **还原** → 选择备份文件和恢复选项，适合新手。

### 恢复方法

恢复需按 **完整备份 → 差异备份 → 日志备份** 的顺序进行：

```sql
-- 1. 恢复完整备份（NORECOVERY：保留恢复状态，允许后续恢复）
RESTORE DATABASE db
FROM DISK = 'D:\backup\db_full.bak'
WITH NORECOVERY, REPLACE;

-- 2. 恢复差异备份（若有）
RESTORE DATABASE db
FROM DISK = 'D:\backup\db_diff.bak'
WITH NORECOVERY;

-- 3. 恢复日志备份（若有，可指定时点）
RESTORE LOG TestDB
FROM DISK = 'D:\backup\db_log.trn'
WITH RECOVERY, STOPAT = '2023-10-01 12:00:00';
```

| 参数 | 说明 |
| :-- | :-- |
| `NORECOVERY` | 保留恢复状态，允许后续继续恢复 |
| `RECOVERY` | 完成恢复，数据库变为可用状态 |
| `REPLACE` | 覆盖现有数据库 |
| `STOPAT` | 恢复到指定时间点 |

### 单表备份

```sql
-- 快速备份（自动创建目标表并复制数据）
SELECT * INTO database..table_backup_YYYYMMDD FROM database..table;

-- 仅复制表结构（不复制数据）
SELECT * INTO database..table_backup_YYYYMMDD FROM database..table WHERE 1=0;

-- 先创建空表再复制数据
INSERT INTO database..table_backup_YYYYMMDD SELECT * FROM database..table;
```

> `WHERE 1=0` 是始终为假的条件，用于只复制表结构（列定义、数据类型、约束等），不复制任何数据行。

---

## MySQL

### 备份方法

#### 物理备份（文件复制）

适用于大规模数据库，直接复制 MySQL 数据目录文件（需先停止服务或锁定表）：

```bash
systemctl stop mysql              # 停止 MySQL 服务
cp -R /var/lib/mysql/ /backup/mysql/  # 复制数据目录
systemctl start mysql             # 启动 MySQL 服务
```

#### 逻辑备份（mysqldump）

适用于中小规模数据库，生成 SQL 脚本（包含表结构和数据）：

```bash
# 备份单个数据库
mysqldump -u root -p --databases db_name > db_backup.sql

# 备份所有数据库
mysqldump -u root -p --all-databases > all_databases_backup.sql

# 仅备份表结构（不包含数据）
mysqldump -u root -p --no-data db_name > db_structure.sql
```

#### 第三方工具（Percona XtraBackup）

开源热备份工具，支持增量备份和压缩备份，无需停止服务（适合 InnoDB 引擎）：

```bash
# 全量备份
xtrabackup --user=root --password=xxx --backup --target-dir=/backup/mysql_full

# 增量备份（基于全量备份）
xtrabackup --user=root --password=xxx --backup \
  --target-dir=/backup/mysql_incr \
  --incremental-basedir=/backup/mysql_full
```

> 可使用 `--databases="db1 db2"` 指定数据库，或在数据库名后加表名精确到表（如 `dbname.tablename`）。

### 恢复方法

#### 物理备份恢复

```bash
systemctl stop mysql                          # 停止服务
rm -rf /var/lib/mysql/*                       # 删除原数据目录（谨慎操作！）
cp -R /backup/mysql/* /var/lib/mysql/         # 复制备份文件到数据目录
chown -R mysql:mysql /var/lib/mysql           # 授权
systemctl start mysql                         # 启动服务
```

#### 逻辑备份恢复

```bash
# 恢复单个数据库
mysql -u root -p db_name < db_backup.sql

# 恢复所有数据库（需先创建同名数据库）
mysql -u root -p < all_databases_backup.sql
```

#### XtraBackup 恢复

```bash
# 准备备份（合并增量备份到全量备份）
xtrabackup --prepare --target-dir=/backup/mysql_full

# 恢复到数据目录
xtrabackup --copy-back --target-dir=/backup/mysql_full

# 授权并启动服务
chown -R mysql:mysql /var/lib/mysql
systemctl start mysql
```

### 单表备份

```sql
-- 创建空表（仅复制结构，包含索引和约束）
CREATE TABLE 新表 LIKE 原表;

-- 创建表并复制数据
CREATE TABLE 新表 AS SELECT * FROM 原表;
```

---

## Oracle

### 备份方法

#### 逻辑备份（数据泵 expdp）

```bash
# 导出整个数据库
expdp user/password@SID FULL=Y DIRECTORY=dpump_dir DUMPFILE=full_db.dmp \
  LOGFILE=exp_full_db.log COMPRESSION=ALL

# 导出指定用户的所有对象
expdp user/password@SID SCHEMAS=user1,user2 DIRECTORY=dpump_dir DUMPFILE=schemas.dmp \
  LOGFILE=exp_schemas.log EXCLUDE=PROCEDURE,FUNCTION PARALLEL=4

# 导出指定表（可过滤数据）
expdp user/password@SID TABLES=table1,table2 DIRECTORY=dpump_dir DUMPFILE=tables.dmp \
  LOGFILE=exp_tables.log QUERY="WHERE salary > 10000"
```

**常用参数汇总：**

| 参数 | 说明 |
| :-- | :-- |
| `DIRECTORY` | 数据库目录对象，需提前创建（如 `CREATE OR REPLACE DIRECTORY dpump_dir AS '/u01/backup';`） |
| `DUMPFILE` | 备份文件名，支持 `%U` 通配符生成多个文件（如 `dump_%U.dmp`） |
| `LOGFILE` | 日志文件名 |
| `PARALLEL` | 并行度，根据服务器 CPU 核心数调整 |
| `COMPRESSION` | 压缩级别（`ALL`、`DATA_ONLY`、`METADATA_ONLY`） |
| `CONTENT` | 导出内容（`ALL`、`DATA_ONLY`、`METADATA_ONLY`） |
| `EXCLUDE`/`INCLUDE` | 过滤对象类型或名称（如 `EXCLUDE=TABLE:"LIKE 'TEMP%'"`） |
| `FILESIZE` | 单个备份文件的最大大小 |

#### 物理备份（RMAN）

Oracle 官方推荐工具，支持热备份（归档模式）和冷备份：

```sql
rman target /                              -- 连接 RMAN
backup database plus archivelog delete input;  -- 全量备份（含归档日志）
backup current controlfile;                -- 备份控制文件
backup spfile;                             -- 备份参数文件
```

#### 冷备份

需停止数据库，复制数据文件、控制文件、联机日志：

```bash
sqlplus / as sysdba                        -- 关闭数据库
shutdown immediate;
cp $ORACLE_BASE/oradata/orcl/* /backup/oracle_cold/  -- 复制文件
startup;                                   -- 启动数据库
```

### 恢复方法

#### 数据泵恢复（impdp）

```bash
# 恢复整个数据库
impdp user/password@SID FULL=Y DIRECTORY=dpump_dir DUMPFILE=full_db.dmp \
  LOGFILE=imp_full_db.log TABLE_EXISTS_ACTION=REPLACE

# 恢复指定用户
impdp user/password@SID SCHEMAS=user1,user2 DIRECTORY=dpump_dir DUMPFILE=schemas.dmp \
  LOGFILE=imp_schemas.log PARALLEL=4 REMAP_SCHEMA=old_user:new_user

# 恢复指定表
impdp user/password@SID TABLES=table1,table2 DIRECTORY=dpump_dir DUMPFILE=tables.dmp \
  LOGFILE=imp_tables.log TABLE_EXISTS_ACTION=APPEND REMAP_TABLE=old_table:new_table
```

| `TABLE_EXISTS_ACTION` 值 | 说明 |
| :-- | :-- |
| `REPLACE` | 若表已存在则替换 |
| `SKIP` | 跳过已存在的表 |
| `APPEND` | 追加数据到已存在的表 |

#### RMAN 恢复

```sql
-- 完全恢复（适用于归档模式）
restore database;
recover database;
alter database open;

-- 不完全恢复（指定时间点）
run {
  set until time "to_date('2023-10-01 12:00:00','yyyy-mm-dd hh24:mi:ss')";
  restore database;
  recover database;
}
alter database open resetlogs;
```

#### 冷备份恢复

```bash
shutdown immediate;                                -- 关闭数据库
cp /backup/oracle_cold/* $ORACLE_BASE/oradata/orcl/  -- 复制备份文件到原路径
startup;                                           -- 启动数据库
```

### 单表备份

```sql
-- 创建空表（仅复制结构）
CREATE TABLE 新表 AS SELECT * FROM 原表 WHERE 1=0;

-- 创建表并复制数据
CREATE TABLE 新表 AS SELECT * FROM 原表;
```