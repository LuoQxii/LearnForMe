### SQL Server数据库备份与恢复

SQL Server 备份以 **T-SQL 命令** 或 **SSMS 图形界面** 为主，支持完整备份、差异备份、日志备份。

#### 一、备份方法

##### 1.完整备份

备份数据库所有数据和结构，是其他备份的基础。

```sql
-- 完整备份数据库到指定路径
BACKUP DATABASE db TO DISK = 'D:\backup\db_YYYYMMDD.bak' with STATS = 1,compression;
```
   - 使用的 SQL Server 专有的 `BACKUP DATABASE` 语句，每一条命令针对特定的数据库(db)进行备份。
   - 备份文件会被存储在 `D:\backup\` 目录下，文件名的格式为 `数据库名+日期.bak`，路径及文件名可以自定义。
   - `WITH STATS = 1` 这个参数的作用是每完成 1% 的备份进度就显示一次统计信息。
   - `COMPRESSION` 参数表明在备份过程中启用了备份压缩功能。

##### 2.差异备份（基于完整备份）

仅备份自上次完整备份后变化的数据，体积小、速度快。

```sql
BACKUP DATABASE db 
TO DISK = 'D:\backup\db_diff.bak' 
WITH DIFFERENTIAL, COMPRESSION;
```

##### 3.事务日志备份

备份自上次日志备份后产生的事务日志，支持时点恢复。

```sql
BACKUP LOG db 
TO DISK = 'D:\backup\db_log.trn' 
WITH COMPRESSION;
```

##### 4.图形界面操作

通过 SQL Server Management Studio（SSMS）右键数据库 → **任务** → **还原** → 选择备份文件和恢复选项，适合新手。

#### 二、恢复方法

恢复需按 **完整备份 → 差异备份 → 日志备份** 的顺序进行（若有）。

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
-- RECOVERY：完成恢复，数据库可用；STOPAT：恢复到指定时间点
```

### SQL Server单表备份
```sql       
SELECT *
        INTO database..table_backup_YYYYMMDD
        FROM database..table;
```
这是 SQL Server 中常用的快速备份表数据的方法，不需要预先创建目标表。这种方式会自动创建目标表，并将源表的数据复制过去。

```sql
-- 先创建备份表（结构与原表相同）
SELECT * INTO database..table_backup_YYYYMMDD FROM database..table WHERE 1=0;

-- 再复制数据
INSERT INTO database..table_backup_YYYYMMDD SELECT * FROM database..table;
```
在 SQL 中，WHERE 1=0 是一个始终为假的条件表达式。当它被用在 SELECT ... INTO 语句中时，作用是只复制表的结构（列定义、数据类型等），而不复制任何数据行。 复制的表结构无需手动编写列定义，保留所有约束和数据类型（如主键、外键等）。

### MYSQL数据库备份与恢复

MySQL 备份方式分为 **逻辑备份**（基于 SQL 语句）和 **物理备份**（基于数据文件），恢复方式对应备份类型。

#### 一、备份方法
##### 1. **物理备份（文件复制）**
适用于大规模数据库，直接复制 MySQL 数据目录文件（需先停止服务或锁定表）。

```bash
# 停止 MySQL 服务
systemctl stop mysql

# 复制数据目录
cp -R /var/lib/mysql/ /backup/mysql/

# 启动 MySQL 服务
systemctl start mysql
```
##### 2. **逻辑备份（mysqldump命令）**
适用于中小规模数据库，生成 SQL 脚本（包含表结构和数据）。

```bash
# 备份单个数据库（包含数据和结构）
mysqldump -u root -p --databases db_name > db_backup.sql

# 备份所有数据库
mysqldump -u root -p --all-databases > all_databases_backup.sql

# 备份时包含表结构但不包含数据
mysqldump -u root -p --no-data db_name > db_structure.sql
```
##### 3. **第三方工具（如 Percona XtraBackup）**

开源热备份工具，支持增量备份和压缩备份，无需停止服务（适合 InnoDB 引擎）。
XtraBackup 基于**物理备份**的工具核心原理是直接复制数据库的数据文件。 默认情况下会备份**整个 MySQL/Percona Server 实例的所有数据**。
```bash
# 全量备份
xtrabackup --user=root --password=xxx --backup --target-dir=/backup/mysql_full

# 增量备份（基于全量备份）
xtrabackup --user=root --password=xxx --backup --target-dir=/backup/mysql_incr --incremental-basedir=/backup/mysql_full
```
   - 可以增加--database参数指定单个或多个数据库，用空格隔开（格式：`--databases="db1 db2"`）
   - 可在数据库后加表名精确到表（格式：`dbname.tablename`）

#### 二、恢复方法
##### 1.**物理备份（文件复制）**

```bash
# 停止服务
systemctl stop mysql

# 删除原数据目录（谨慎操作！）
rm -rf /var/lib/mysql/*

# 复制备份文件到数据目录
cp -R /backup/mysql/* /var/lib/mysql/

# 授权并启动服务
chown -R mysql:mysql /var/lib/mysql
systemctl start mysql
```
##### 2.逻辑备份恢复（mysql 命令）

```bash
# 恢复单个数据库
mysql -u root -p db_name < db_backup.sql

# 恢复所有数据库（需先创建同名数据库）
mysql -u root -p < all_databases_backup.sql
```
##### 3.第三方工具（如 Percona XtraBackup）

```bash
# 准备备份（合并增量备份到全量备份）
xtrabackup --prepare --target-dir=/backup/mysql_full

# 恢复到数据目录
xtrabackup --copy-back --target-dir=/backup/mysql_full

# 授权并启动服务
chown -R mysql:mysql /var/lib/mysql
systemctl start mysql
```

### MYSQL单表备份
MySQL 使用 `CREATE TABLE ... LIKE`实现表结构备份（包含索引、约束）或使用子查询 `CREATE TABLE ... AS SELECT`实现单表备份：

```sql
-- 创建空表（结构复制）
CREATE TABLE 新表 LIKE 原表;

-- 创建表并复制数据
CREATE TABLE 新表 AS SELECT * FROM 原表;
```

### Oracle数据库备份与恢复

#### 一、备份方法

##### 1.逻辑备份



```bash
-- 导出整个数据库，包括所有用户、表、存储过程等。参数`FULL=Y`：指定全库导出。`COMPRESSION=ALL`：启用数据压缩，减小备份文件体积。
expdp user/password@SID FULL=Y DIRECTORY=dpump_dir DUMPFILE=full_db.dmp LOGFILE=exp_full_db.log COMPRESSION=ALL

-- 导出指定用户的所有对象。参数`EXCLUDE=PROCEDURE,FUNCTION`：排除存储过程和函数，`PARALLEL=4`：并行数量为 4。
expdp user/password@SID SCHEMAS=user1,user2 DIRECTORY=dpump_dir DUMPFILE=schemas.dmp LOGFILE=exp_schemas.log EXCLUDE=PROCEDURE,FUNCTION PARALLEL=4

-- 导出指定表的数据和结构。参数`QUERY`：过滤导出的数据。
expdp user/password@SID TABLES=table1,table2 DIRECTORY=dpump_dir DUMPFILE=tables.dmp LOGFILE=exp_tables.log QUERY="WHERE salary > 10000"
```

- **常用参数汇总**

| 参数                | 说明                                                         |
| ------------------- | ----------------------------- |
| `DIRECTORY`         | 数据库目录对象，需提前创建（如 `CREATE OR REPLACE DIRECTORY dpump_dir AS '/u01/backup';`）。     |
| `DUMPFILE`          | 备份文件名，支持 `%U` 通配符生成多个文件（如 `dump_%U.dmp`）。 |
| `LOGFILE`           | 日志文件名。                    |
| `PARALLEL`          | 并行度，根据服务器 CPU 核心数调整。|
| `COMPRESSION`       | 压缩级别（`ALL`、`DATA_ONLY`、`METADATA_ONLY`）。    |
| `CONTENT`           | 导出内容（`ALL`、`DATA_ONLY`、`METADATA_ONLY`）。    |
| `EXCLUDE`/`INCLUDE` | 过滤对象类型或名称（如 `EXCLUDE=TABLE:"LIKE 'TEMP%'"`）。    |
| `FILESIZE` | 单个备份文件的最大大小 |

##### 2.物理备份（RMAN）

Oracle 官方推荐工具，支持热备份（归档模式）和冷备份，可备份数据文件、控制文件、日志等。

```sql
-- 连接 RMAN
rman target /

-- 全量备份数据库（含归档日志）
backup database plus archivelog delete input;

-- 备份控制文件和参数文件
backup current controlfile;
backup spfile;
```

##### 3.冷备份（关闭数据库后复制文件）

需停止数据库，复制数据文件、控制文件、联机日志。

```bash
-- 关闭数据库
sqlplus / as sysdba
shutdown immediate;

-- 复制文件（Linux 示例）
cp $ORACLE_BASE/oradata/orcl/* /backup/oracle_cold/

-- 启动数据库
startup;
```

#### 二、恢复方法

##### 1.数据泵恢复（impdp）

```bash
-- 恢复整个数据库（包含所有用户、表、存储过程等）,`REPLACE`替换,`SKIP`跳过,`APPEND`追加
-- 注意：执行前需确保数据库处于 OPEN 状态，且有足够权限（如 DBA 角色）
impdp user/password@SID FULL=Y DIRECTORY=dpump_dir DUMPFILE=full_db.dmp LOGFILE=imp_full_db.log TABLE_EXISTS_ACTION=REPLACE  -- 若表已存在则替换（可选，根据需求调整）

-- 恢复指定用户（user1、user2）的所有对象（排除了存储过程和函数，与备份一致）
-- 注意：需先创建用户 user1、user2（若不存在），并分配对应权限
impdp user/password@SID SCHEMAS=user1,user2 DIRECTORY=dpump_dir DUMPFILE=schemas.dmp LOGFILE=imp_schemas.log \
  PARALLEL=4 \  -- 并行恢复，与备份时的并行度一致
  REMAP_SCHEMA=old_user:new_user  -- 若需将对象恢复到新用户（可选，如 user1→user1_new）
  
-- 恢复指定表（table1、table2）的数据和结构（包含备份时过滤后的结果）
-- 注意：需确保表所在的用户已存在，且表结构兼容（或允许替换）
impdp user/password@SID TABLES=table1,table2 DIRECTORY=dpump_dir DUMPFILE=tables.dmp LOGFILE=imp_tables.log \
  TABLE_EXISTS_ACTION=APPEND  -- 若表已存在，追加数据（可选）
  REMAP_TABLE=old_table:new_table  -- 若需将表恢复为新表名（可选，如 table1→table1_bak）
```

##### 2.物理 恢复（RMAN 恢复）

```sql
-- 连接 RMAN
rman target /

-- 完全恢复数据库（适用于归档模式）
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

##### 3.冷备份恢复

```bash
-- 关闭数据库
shutdown immediate;

-- 复制备份文件到原路径
cp /backup/oracle_cold/* $ORACLE_BASE/oradata/orcl/

-- 启动数据库
startup;
```

### Oracle单表备份

Oracle 使用 `CREATE TABLE ... AS SELECT`实现表结构或单表备份：
```sql
-- 创建空表（结构复制）
CREATE TABLE 新表 AS SELECT * FROM 原表 WHERE 1=0;

-- 创建表并复制数据
CREATE TABLE 新表 AS SELECT * FROM 原表;
```
