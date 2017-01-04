---
title: Tomcat JDBC Pool 多数据源配置
date: 2017-1-4 21:30:00
categories:
- Java 编程
tags: 
- JDBC 
description: 
---
## 前言
多数据源配置示例

<!-- more -->

```xml
<!-- 数据库配置信息 -->
	<context:property-placeholder location="classpath:conf/db.properties" ignore-unresolvable="true" />

	<!-- ================================Tomcat JDBC Pool数据源配置（写）================================================= -->
	<bean id="dataSourceW" class="org.apache.tomcat.jdbc.pool.DataSource" destroy-method="close">
		<property name="poolProperties">
			<bean class="org.apache.tomcat.jdbc.pool.PoolProperties">
				<property name="driverClassName" value="${db_w.driverClassName}" />
				<property name="url" value="${db_w.url}" />
				<property name="username" value="${db_w.username}" />
				<property name="password" value="${db_w.password}" />
				<property name="jmxEnabled" value="${db_w.jmxEnabled}" />
				<property name="testOnBorrow" value="${db_w.testOnBorrow}" />
				<property name="testWhileIdle" value="${db_w.testWhileIdle}" />
				<property name="testOnReturn" value="${db_w.testOnReturn}" />
				<property name="validationInterval" value="${db_w.validationInterval}" />
				<property name="validationQuery" value="${db_w.validationQuery}" />
				<property name="timeBetweenEvictionRunsMillis" value="${db_w.timeBetweenEvictionRunsMillis}" />
				<property name="initialSize" value="${db_w.initialSize}" />
				<property name="maxActive" value="${db_w.maxActive}" />
				<property name="maxIdle" value="${db_w.maxIdle}" />
				<property name="minIdle" value="${db_w.minIdle}" />
				<property name="maxWait" value="${db_w.maxWait}" />
				<property name="minEvictableIdleTimeMillis" value="${db_w.minEvictableIdleTimeMillis}" />
				<property name="logAbandoned" value="${db_w.logAbandoned}" />
				<property name="removeAbandoned" value="${db_w.removeAbandoned}" />
				<property name="removeAbandonedTimeout" value="${db_w.removeAbandonedTimeout}" />
				<property name="jdbcInterceptors" value="${db_w.jdbcInterceptors}" />
			</bean>
		</property>
	</bean>
	<!-- ================================Tomcat JDBC Pool数据源配置（读）================================================= -->
	<bean id="dataSourceR" class="org.apache.tomcat.jdbc.pool.DataSource" destroy-method="close">
		<property name="poolProperties">
			<bean class="org.apache.tomcat.jdbc.pool.PoolProperties">
				<property name="driverClassName" value="${db_r.driverClassName}" />
				<property name="url" value="${db_r.url}" />
				<property name="username" value="${db_r.username}" />
				<property name="password" value="${db_r.password}" />
				<property name="jmxEnabled" value="${db_r.jmxEnabled}" />
				<property name="testOnBorrow" value="${db_r.testOnBorrow}" />
				<property name="testWhileIdle" value="${db_r.testWhileIdle}" />
				<property name="testOnReturn" value="${db_r.testOnReturn}" />
				<property name="validationInterval" value="${db_r.validationInterval}" />
				<property name="validationQuery" value="${db_r.validationQuery}" />
				<property name="timeBetweenEvictionRunsMillis" value="${db_r.timeBetweenEvictionRunsMillis}" />
				<property name="initialSize" value="${db_r.initialSize}" />
				<property name="maxActive" value="${db_r.maxActive}" />
				<property name="maxIdle" value="${db_r.maxIdle}" />
				<property name="minIdle" value="${db_r.minIdle}" />
				<property name="maxWait" value="${db_r.maxWait}" />
				<property name="minEvictableIdleTimeMillis" value="${db_r.minEvictableIdleTimeMillis}" />
				<property name="logAbandoned" value="${db_r.logAbandoned}" />
				<property name="removeAbandoned" value="${db_r.removeAbandoned}" />
				<property name="removeAbandonedTimeout" value="${db_r.removeAbandonedTimeout}" />
				<property name="jdbcInterceptors" value="${db_r.jdbcInterceptors}" />
			</bean>
		</property>
	</bean>

	<!-- Mybatis链接工厂 -->
	<bean id="sqlSessionFactoryW" class="org.mybatis.spring.SqlSessionFactoryBean" p:dataSource-ref="dataSourceW" p:configLocation="classpath:mybatis/configuration.xml" />
	<bean id="sqlSessionFactoryR" class="org.mybatis.spring.SqlSessionFactoryBean" p:dataSource-ref="dataSourceR" p:configLocation="classpath:mybatis/configuration.xml" />
	<bean id="sqlSessionTemplateW" class="org.mybatis.spring.SqlSessionTemplate" c:sqlSessionFactory-ref="sqlSessionFactoryW" scope="prototype" />
	<bean id="sqlSessionTemplateR" class="org.mybatis.spring.SqlSessionTemplate" c:sqlSessionFactory-ref="sqlSessionFactoryR" scope="prototype" />
```




随着
