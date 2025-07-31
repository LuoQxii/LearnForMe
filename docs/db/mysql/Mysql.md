## 解析binlog

1.将binlog解析为sql语句格式  

```sql
mysqlbinlog --no-defaults --base64-output=decode-rows -vvv --start-datetime="2023-04-28 16:30:00" --stop-datetime="2023-04-28 17:30:00" /mysql/log/mysql-bin.028706 > /mysql/backup/binlog_0515.sql
```

2.用来解析MySQL二进制日志文件(mysql-bin.070951)，并在解析过程中筛选出UPDATE、INSERT和DELETE操作的日志，然后使用awk命令对这些操作进行处理，去除"###"字符串，以及对INSERT INTO和DELETE FROM进行替换，最后统计每种操作的次数，并按照次数进行排序，最终显示出现次数最多的前10种操作  
```/home/root/mysql/mysql/bin/mysqlbinlog --no-defaults --base64-output=decode-rows -vv mysql-bin.070951| awk '/UPDATE|INSERT|DELETE/{gsub("###","");gsub("INSERT.*INTO","INSERT");gsub("DELETE.*FROM","DELETE");count[$1" "$2]++}END{for(i in count)print i,"\t",count[i]}' |sort -k3nr|head -n 10```

3.某个关键字在file中出现的次数  
```grep -o "关键字" file | wc -l```

4.把sql文件中“# UPDATE”重写到log文件中  
```egrep  "# UPDATE" xxx.sql  >  xxx_update.log```


5.从名为xxx_update.log的文件中筛选出包含"###INSERT"的行，然后使用awk命令以空格为分隔符提取出每行的第四个字段，接着使用sort命令对提取出的字段进行排序，最后使用uniq命令统计并显示每个唯一的字段出现的次数  
```egrep  "### INSERT" xxx_update.log  |  awk -F " " '{print $4}' | sort | uniq -c```


---
