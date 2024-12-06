# RuoYi v3.8.8

## 基线

原始仓库: https://github.com/yangzongzhuan/RuoYi-Vue  
Oracle部分: https://github.com/yangzongzhuan/RuoYi-Oracle

- RuoYi-Vue基于Commit: 1810f30
- RuoYi-Oracle基于Commit: 210dfc7 (仅限数据库相关部分)

## 前端

[RuoYi-Vue3](https://github.com/XFY9326/RuoYi-Vue3)

## 修改内容

- 增加Oracle数据库支持
- 全部依赖升级
- 代码格式化以及部分修复
- 优化自动部署管理脚本
- 增加健康探活接口

## 默认用户

- 用户名：admin
- 密码：admin123

## 部署与运行

使用Maven的`package`命令可以打包整个项目，完整的打包文件为`ruoyi-admin/target/ruoyi-admin.jar`  
将`ry.sh`脚本和`ruoyi-admin.jar`放在同一目录即可使用脚本控制服务

```shell
# 启动服务
# 后端默认地址 http://localhost:8080
sh ry.sh start

# 停止服务
sh ry.sh stop

# 查看服务运行状态
sh ry.sh status

# 重启服务
sh ry.sh restart

# 备份服务为001
sh ry.sh backup 001

# 从001的备份回滚服务
sh ry.sh rollback 001
```

注意，由于Git会修改换行符号，执行shell脚本前建议强制将CRLF转为LF

```shell
sed -i "s/\r$//" ry.sh
```

## 数据库

### MySQL

使用`sql/mysql/*`下的sql脚本，并修改以下配置项

```yml
# ruoyi-admin  application.yml
mybatis:
  mapperLocations: classpath*:mapper/mysql/**/*Mapper.xml
  configLocation: classpath:mybatis/mysql/mybatis-config.xml

pagehelper:
  helperDialect: mysql

# ruoyi-admin  application-druid.yml
spring:
  datasource:
    driverClassName: com.mysql.cj.jdbc.Driver
    druid:
      master:
        url: jdbc:mysql://localhost:3306/ry-vue?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
        username: root
        password: 123456

# ruoyi-generator generator.yml
gen:
  dbType: mysql
```

在`ruoyi-admin`的`pom.xml`中启用相应的数据库驱动

```xml
<!--Mysql驱动 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

### Oracle

使用`sql/oracle/*`下的sql脚本，并修改以下配置项

```yml
# ruoyi-admin  application.yml
mybatis:
  mapperLocations: classpath*:mapper/oracle/**/*Mapper.xml
  configLocation: classpath:mybatis/oracle/mybatis-config.xml

pagehelper:
  helperDialect: oracle

# ruoyi-admin  application-druid.yml
spring:
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driverClassName: oracle.jdbc.OracleDriver
    druid:
      master:
        url: jdbc:oracle:thin:@127.0.0.1:1521/orcl
        username: orcl
        password: 123456

# ruoyi-generator generator.yml
gen:
  dbType: oracle
```

在`ruoyi-admin`的`pom.xml`中启用相应的数据库驱动

```xml
<!--oracle驱动-->
<dependency>
    <groupId>com.oracle</groupId>
    <artifactId>ojdbc14</artifactId>
    <version>${oracle.version}</version>
</dependency>
```

## Swagger

由于使用SpringDoc需要反向代理支持，所有Swagger相关的Url都被定位到`/api-docs`路径下

## Jwt

**使用前请务必修改`application.yml`中的`token.secrect`值为自定义的值**
