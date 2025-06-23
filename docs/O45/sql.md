> 交易到清算的源数据 (根据清算表名 查询 对应的 数据库交易表)  
`select * from qs_tsynctradeconfig t where t.target_table_name like '%Qs表名%';`