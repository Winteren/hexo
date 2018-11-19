---
title: Go 语言学习笔记
date: 2018-11-07 21:30:00
categories:
- 学习笔记
tags: 
- Go
description: 
- Go 语言学习笔记
---
# 初识 Go 语言
  Go （又称 Golang）是 Google 开发的一种静态强类型、编译型、并发型，并具有垃圾回收功能的编程语言。
# 背景
  - 2007 年 9 月开始设计，2009 年 11 月正式宣布推出，成为开源项目，并在 Linux 及 Mac OS X 平台上进行了实现，后来追加了 Windows 系统下的实现。
  - 2006 年，Go 被软件评价公司 TIOBE 选为 “TIOBE 2016 年最佳语言”。
  - 目前，Go 每半年发布一个二级版本（即从 a.x 升级到 a.y）
# 官网
  https://golang.google.cn/
# 安装
  下载地址：https://dl.google.com/go/go1.11.2.darwin-amd64.pkg
  双击安装即可，默认安装路径 **/usr/local**
# 配置环境变量
  ``` 
  ➜  ~ echo "export PATH=/usr/local/go/bin:$PATH" >> .bashrc
  ➜  ~ echo "export GOPATH=/Users/renxueni/go" >> .bashrc
  ➜  ~ echo "export GOBIN=$GOPATH/bin" >> .bashrc
  ➜  ~ source .bashrc
```
# 输出环境变量，验证是否生效
```
➜  ~ go env
GOARCH="amd64"
GOBIN="/bin"
GOCACHE="/Users/renxueni/Library/Caches/go-build"
GOEXE=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="darwin"
GOOS="darwin"
GOPATH="/Users/renxueni/go"
GOPROXY=""
GORACE=""
GOROOT="/usr/local/go"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/darwin_amd64"
GCCGO="gccgo"
CC="clang"
CXX="clang++"
CGO_ENABLED="1"
GOMOD=""
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fno-caret-diagnostics -Qunused-arguments -fmessage-length=0 -fdebug-prefix-map=/var/folders/yk/mrccz_t93_g4z75b19cbxbch0000gn/T/go-build525537248=/tmp/go-build -gno-record-gcc-switches -fno-common"
```
# 进入工作空间源码目录
```
➜  ~ cd /Users/renxueni/go/src
```
# 创建测试包目录
```
➜  src mkdir demo
➜  src cd demo
➜  demo 
```
# 创建测试源码
```
➜  demo cat > hello.go << end
heredoc> package main
heredoc> 
heredoc> func main(){ 
heredoc>        println("Hello World!")
heredoc> }
heredoc> end
```
# 测试
```
➜  demo go run hello.go
Hello World!
```
