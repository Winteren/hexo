---
title: MySQL 入库操作的优化 
date: 2016-06-01 22:22:22
categories:
- Java 编程
tags: 
- MySQL
description: 
---


最近开始玩 **MyBatis** ，想实现这么一个功能，就是将一张表里的数据作为历史数据存储到另一张表里去。
一开始我的代码是这么写的：
```java
  List<BookHistory> bookHistories = bookHisDao.getBookList();//获取需要存储的历史数据
		for (BookHistory BookHistory:bookHistories) {
			BookHistory book = bookHisDao.selectBookById(BookHistory);
			if(null == book){
				bookHisDao.insertBook(bookHistory);// 数据入库操作
			}
		}
```	
看起来简单粗暴，似乎没有什么问题，查询出来一个`list`，然后循环遍历，检查是否已经存在历史库中，如果不存在则入库。功能也正确实现，但是，存在的问题是，速度有点太慢。`2007` 条数据的执行时间是 `2m 1s 505ms` 。对于追求完美的我，这是不能忍受的，首先我能想到的就是优化入库操作，因为一条数据一条数据的插入，确实会速度特别慢，说干就干，首先先将入库操作由原来的一条一条入库改成批量入库。接下来我的代码变成了这样：

```java
  List<BookHistory> bookHistories = bookHisDao.getBookList();
		Iterator<BookHistory> bookIter= bookHistories.iterator();
		while (bookIter.hasNext()){
			BookHistory bookHistory = bookIter.next();
			BookHistory book = bookHisDao.selectBookById(bookHistory);
			if(null != book){
				bookIter.remove();
			}

		}
		int count = bookHisDao.insertBookBatch(bookHistories);//批量入库操作
		System.out.println("insert "+count+" records");
```
	改成批量入库操作后，速度直线上升，`2007`条数据的执行时间是 `6s 737ms` ，现在看来，情况很乐观，但是随之而来的又出来了另一个问题，因为做测试，我并没有将所有字段都进行入库操作。	当我把字段补齐时，控制台报了这样一个错：
> org.springframework.dao.TransientDataAccessResourceException: 
> ### Error updating database.  Cause: com.mysql.jdbc.PacketTooBigException: Packet for query is too large (13513737 > 4194304). You can change this value on the server by setting the max_allowed_packet' variable.
> ### The error may involve BookHistory.insertBookBatch-Inline
  
  

看到控制台提到了  **max_allowed_packet** 这个参数，那么我们就需要了解一下，这个参数是干什么用的。**max_allowed_packet** 是 **MySQL** 变量的一个变量，用于控制其通信缓冲区的最大长度。默认值是：`4194304`.从控制台的报错信息可以看出来，我此时需要的缓冲区长度为：`13513737`，远大于`4194304`。最简单粗暴的办法就是修改 **MySQL** 的 **max_allowed_packet** 参数。修改这个参数，可以暂时的解决问题，但是不能长久的解决问题，因为我无法保证线上的数据量会是多大。这时候，我需要寻找别的突破点。既然`2007`条数据同时入库，会导致 **MySQL** 的缓冲区不够用，那么，我是否可以改一下自己的程序，不让数据一次性都插入，而是，分批插入，比如说每次 `500` 条数据呢？接下来，我又对我的代码做了如下修改：

```java
  List<BookHistory> bookHistories = bookHisDao.getBookList();
		Iterator<BookHistory> bookIter= bookHistories.iterator();
		while (bookIter.hasNext()){
			BookHistory bookHistory = bookIter.next();
			BookHistory book = bookHisDao.selectBookById(bookHistory);
			if(null != book){
				bookIter.remove();
			}

		}
		//int count = bookHisDao.insertBookBatch(bookHistories);//批量入库操作
		//System.out.println("insert "+count+" records");

		//分批，批量入库操作
		int batch = 0;
		List<BookHistory>  bookList = new ArrayList<BookHistory>();
		for (BookHistory bookHistory:bookHistories){
			batch++;
			bookList.add(bookHistory);
			System.out.println(batch);
			if (batch == 500){
				bookHisDao.insertBookBatch(bookList);
				System.out.println(bookList.size());
				batch = 0;
				bookList.clear();
			}
		}
		bookHisDao.insertBookBatch(bookList);
```
	这样一修改之后，控制台的错误消失，程序的运行速度是 `8s 393ms` 。比刚才的 一次性批量入库慢了 `2s` 。。。暂时还没有想到更好的解决方案，先这样，我再想想还有么有更好的解决方案。
	以上的修改，虽然解决了问题，但是代码不够优雅。
	
	最后，我们需要思考的问题是，为什么 **MySQL** 入库，批量入库比一条一条的数据入库性能好很多？
