---
title: TRUNCATE 和 DELETE 的区别
date: 2016-11-14 22:15:00
categories:
- Java 编程
tags: 
- MySQL
description: 
---

##前言
  工作中有这么一个业务场景，数据库里的数据需要定时全量删除。全量删除数据有两个选择，1：**DELETE FROM table_name** 2:**TRUNCATE TABLE table_name**。
由于**TRUNCATE TABLE** 相当于不带 **WHERE**条件的**DELETE**语句，那么不论是选择**DELETE**还是选择**TRUNCATE TABLE**好像都能达到我删除全量数据的目的。
<!-- more -->
##DELETE 语法
**DELETE** 语句大家都熟悉，语法如下：

```sql
<!-- 单表操作 -->
DELETE [LOW_PRIORITY] [QUICK] [IGNORE] FROM tbl_name
    [PARTITION (partition_name,...)]
    [WHERE where_condition]
    [ORDER BY ...]
    [LIMIT row_count]
    
<!-- 多表操作1 -->
DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
    tbl_name[.*] [, tbl_name[.*]] ...
    FROM table_references
    [WHERE where_condition]
    
<!-- 多表操作2 -->
DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
    FROM tbl_name[.*] [, tbl_name[.*]] ...
    USING table_references
    [WHERE where_condition]
```
##TRUNCATE TABLE 语法

```sql
TRUNCATE [TABLE] tbl_name
```
##**DELETE**和**TRUNCATE TABLE**的区别
现在我们了解了**DELETE**和**TRUNCATE TABLE**的共同点和语法后，现在我们来了解一下它们的区别。
**DELETE**和**TRUNCATE TABLE**的最大区别在于执行速度和是否可以条件删除。
**DELETE**可以通过**WHERE**条件来筛选需要删除的记录，且可以返回删除的记录数。
**TRUNCATE TABLE**不能条件筛选需要删除的记录，且不返回删除的记录数。
**TRUNCATE TABLE**的执行速度非常快，**DELETE**的执行速度不是很快。

未完待续。。。
