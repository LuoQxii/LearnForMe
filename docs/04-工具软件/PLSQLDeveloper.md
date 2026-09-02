
## PL/SQL Developer 查询数据乱码

### 问题原因

PL/SQL Developer 查询出现乱码，通常是因为客户端的 `NLS_LANG` 环境变量与数据库字符集不一致。

### 解决步骤

#### 1. 查询数据库字符集

```sql
SELECT value FROM nls_database_parameters WHERE parameter = 'DB_CHARACTERSET';
```

#### 2. 配置 Windows 环境变量

`NLS_LANG` 环境变量的格式必须严格为 `语言_地区.字符集`：

| 数据库字符集 | NLS_LANG 设置值 |
| :-- | :-- |
| `ZHS16GBK` | `SIMPLIFIED CHINESE_CHINA.ZHS16GBK` |
| `AL32UTF8` | `SIMPLIFIED CHINESE_CHINA.AL32UTF8` |

设置方法：右键 **此电脑** → **属性** → **高级系统设置** → **环境变量** → 新建系统变量 `NLS_LANG`，填入对应值，然后重启 PL/SQL Developer。
