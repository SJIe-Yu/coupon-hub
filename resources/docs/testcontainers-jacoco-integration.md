# Testcontainers 集成测试 + JaCoCo 覆盖率方案

本文档描述 coupon-hub 项目如何在现有 Testcontainers 基础上扩展业务服务的集成测试，并引入 JaCoCo 实现多模块覆盖率检测和聚合报告。

## 现状分析

当前项目的测试现状：

| 维度           | 现状                                                       |
| -------------- | ---------------------------------------------------------- |
| 单元测试       | 各模块有 `spring-boot-starter-test` 依赖，但无实际测试用例 |
| 集成测试       | 仅 `database-migration` 模块有 `DatabaseMigrationIT`       |
| 覆盖率         | 未引入 JaCoCo                                              |
| Testcontainers | 仅用于 Flyway 迁移验证（MySQL），未用于业务服务测试        |
| CI             | 已有 unit test 和 integration test job，使用 `-P it` profile |

目标：

1. 各业务服务（merchant-admin、engine、settlement、search）编写基于 Testcontainers 的集成测试。
2. 测试启动 MySQL + Redis 容器，加载 Spring Boot 上下文，验证 API / Service / DAO 层。
3. JaCoCo 收集单元测试 + 集成测试的覆盖率，生成聚合报告。
4. CI 中自动生成覆盖率报告并上传。

---

## 整体架构

```text
┌────────────────────────────────────────────────────────────────────┐
│  Maven Build Lifecycle                                             │
│                                                                    │
│  ┌──────────────┐   ┌──────────────────┐   ┌───────────────────┐  │
│  │  test phase   │   │  verify phase     │   │  report phase     │  │
│  │  (Surefire)   │   │  (Failsafe)       │   │  (JaCoCo)         │  │
│  │              │   │                  │   │                   │  │
│  │  *Test.java  │   │  *IT.java         │   │  聚合报告         │  │
│  │  单元测试     │   │  集成测试          │   │  HTML + XML       │  │
│  └──────┬───────┘   └──────┬───────────┘   └───────────────────┘  │
│         │                  │                                       │
│         ▼                  ▼                                       │
│  ┌──────────────────────────────────────┐                         │
│  │           JaCoCo Agent               │                         │
│  │  jacoco.exec (UT) + jacoco-it.exec   │                         │
│  └──────────────────────────────────────┘                         │
│                    │                                               │
│                    ▼                                               │
│  ┌──────────────────────────────────────┐                         │
│  │  Testcontainers (集成测试运行时)      │                         │
│  │                                      │                         │
│  │  ┌──────────┐  ┌──────────┐          │                         │
│  │  │ MySQL 8.0│  │ Redis 7.2│          │                         │
│  │  └──────────┘  └──────────┘          │                         │
│  └──────────────────────────────────────┘                         │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## 第一步：Maven 依赖与插件配置

### 1.1 根 pom.xml 添加版本属性

在根 `pom.xml` 的 `<properties>` 中添加：

```xml
<jacoco-maven-plugin.version>0.8.12</jacoco-maven-plugin.version>
```

### 1.2 根 pom.xml 添加 JaCoCo 插件管理

在根 `pom.xml` 的 `<build><pluginManagement><plugins>` 中添加：

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>${jacoco-maven-plugin.version}</version>
</plugin>
```

### 1.3 根 pom.xml 全局启用 JaCoCo Agent

在根 `pom.xml` 的 `<build><plugins>` 中添加（与现有 `maven-compiler-plugin` 并列）：

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>${jacoco-maven-plugin.version}</version>
    <executions>
        <!-- 在单元测试前 prepare-agent，输出到 jacoco.exec -->
        <execution>
            <id>prepare-agent</id>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
            <configuration>
                <destFile>${project.build.directory}/jacoco.exec</destFile>
            </configuration>
        </execution>
        <!-- 在集成测试前 prepare-agent-integration，输出到 jacoco-it.exec -->
        <execution>
            <id>prepare-agent-integration</id>
            <goals>
                <goal>prepare-agent-integration</goal>
            </goals>
            <configuration>
                <destFile>${project.build.directory}/jacoco-it.exec</destFile>
            </configuration>
        </execution>
        <!-- 单元测试后生成报告 -->
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
            <configuration>
                <dataFile>${project.build.directory}/jacoco.exec</dataFile>
                <outputDirectory>${project.reporting.outputDirectory}/jacoco-ut</outputDirectory>
            </configuration>
        </execution>
        <!-- 集成测试后生成报告 -->
        <execution>
            <id>report-integration</id>
            <phase>verify</phase>
            <goals>
                <goal>report-integration</goal>
            </goals>
            <configuration>
                <dataFile>${project.build.directory}/jacoco-it.exec</dataFile>
                <outputDirectory>${project.reporting.outputDirectory}/jacoco-it</outputDirectory>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### 1.4 修改 `-P it` Profile 确保 Failsafe 传递 JaCoCo Agent

现有根 `pom.xml` 的 `<profile id="it">` 中已配置 `maven-failsafe-plugin`。需要确认 Failsafe 使用 JaCoCo Agent。JaCoCo 的 `prepare-agent-integration` 会自动设置 `argLine` 属性，Failsafe 默认会使用该属性，无需额外配置。

如果 Failsafe 中手动设置了 `<argLine>`，需要追加 `@{argLine}`：

```xml
<configuration>
    <argLine>@{argLine}</argLine>
    <includes>
        <include>**/*IT.java</include>
    </includes>
</configuration>
```

### 1.5 根 pom.xml 的 dependencyManagement 添加 Testcontainers Redis

当前已有 `testcontainers-bom`，额外需要添加的 Testcontainers 模块无需单独管理，BOM 已覆盖。

各业务模块按需添加 test scope 依赖即可。

---

## 第二步：Testcontainers 测试基类设计

为各业务服务创建统一的集成测试基类，避免每个测试类重复配置容器。

### 2.1 在 framework 模块添加测试依赖

在 `framework/pom.xml` 中添加 test scope 的 Testcontainers 依赖：

```xml
<!-- Testcontainers 核心 -->
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>junit-jupiter</artifactId>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>mysql</artifactId>
    <scope>test</scope>
</dependency>
```

> 注意：test scope 的依赖**不会**传递给子模块。基类只放在各服务模块内。

### 2.2 各业务模块添加测试依赖

以 `merchant-admin` 为例，在 `merchant-admin/pom.xml` 中添加：

```xml
<!-- Testcontainers -->
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>junit-jupiter</artifactId>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>mysql</artifactId>
    <scope>test</scope>
</dependency>

<!-- Redis Testcontainers (使用通用 GenericContainer) -->
<!-- 如果不需要 Redis 集成测试，可以不加 -->
```

`engine`、`settlement`、`search` 模块同理。

### 2.3 测试基类

在各业务模块的 `src/test/java` 下创建基类。以 `merchant-admin` 为例：

```text
merchant-admin/src/test/java/edu/seu/couponhub/distribution/BaseIntegrationIT.java
```

```java
package edu.seu.couponhub.distribution;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

/**
 * 集成测试基类。
 * <p>
 * 启动 MySQL 8.0 和 Redis 7.2 容器，通过 DynamicPropertySource 将连接信息
 * 注入 Spring Boot 测试上下文。子类只需继承即可获得完整的外部依赖环境。
 * </p>
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
@Testcontainers
public abstract class BaseIntegrationIT {

    static {
        // CI 环境下禁用 Ryuk（与现有 database-migration 保持一致）
        System.setProperty("testcontainers.ryuk.disabled", "true");
    }

    @Container
    protected static final MySQLContainer<?> MYSQL = new MySQLContainer<>(
            DockerImageName.parse("mysql:8.0"))
            .withDatabaseName("coupon_hub_merchant_0")
            .withUsername("root")
            .withPassword("test123456")
            .withCommand(
                    "--character-set-server=utf8mb4",
                    "--collation-server=utf8mb4_unicode_ci"
            )
            // 通过 init script 创建分片库和分片表
            .withInitScript("db/init-test-schema.sql");

    @SuppressWarnings("resource")
    @Container
    protected static final GenericContainer<?> REDIS = new GenericContainer<>(
            DockerImageName.parse("redis:7.2-alpine"))
            .withExposedPorts(6379)
            .withCommand("redis-server", "--requirepass", "test123456");

    /**
     * 动态注入 Spring 数据源和 Redis 连接配置。
     * 使用 DynamicPropertySource 避免在 application-test.yaml 中硬编码端口。
     */
    @DynamicPropertySource
    static void overrideProperties(DynamicPropertyRegistry registry) {
        // MySQL
        String jdbcUrl = MYSQL.getJdbcUrl()
                + "?useUnicode=true&characterEncoding=utf8"
                + "&serverTimezone=Asia/Shanghai&useSSL=false"
                + "&allowPublicKeyRetrieval=true";
        registry.add("spring.datasource.url", () -> jdbcUrl);
        registry.add("spring.datasource.username", MYSQL::getUsername);
        registry.add("spring.datasource.password", MYSQL::getPassword);
        registry.add("spring.datasource.driver-class-name",
                () -> "com.mysql.cj.jdbc.Driver");

        // Redis
        registry.add("spring.data.redis.host", REDIS::getHost);
        registry.add("spring.data.redis.port",
                () -> REDIS.getMappedPort(6379));
        registry.add("spring.data.redis.password", () -> "test123456");
    }
}
```

### 2.4 测试 profile 配置

在各业务模块中创建 `src/test/resources/application-test.yaml`，用于禁用不需要的外部依赖（如 Nacos、RocketMQ）：

```yaml
# application-test.yaml
# 集成测试 profile，禁用不需要的外部服务

spring:
  cloud:
    nacos:
      discovery:
        enabled: false
      config:
        enabled: false
        import-check:
          enabled: false
    # 禁用服务发现
    discovery:
      enabled: false

  # 禁用 ShardingSphere（集成测试使用单库）
  # 如果业务逻辑强依赖分片，则保留 ShardingSphere 并配置 Testcontainers 的连接
  autoconfigure:
    exclude:
      - org.apache.shardingsphere.spring.boot.ShardingSphereAutoConfiguration
      - com.alibaba.cloud.nacos.NacosConfigAutoConfiguration
      - com.alibaba.cloud.nacos.NacosDiscoveryAutoConfiguration

# RocketMQ 禁用
rocketmq:
  name-server: localhost:9876
  producer:
    group: test-group
    send-message-timeout: 1000

# 日志简化
logging:
  level:
    root: WARN
    edu.seu.couponhub: INFO
```

> **关于 ShardingSphere**：如果业务代码强依赖 ShardingSphere 分片路由（如 merchant-admin 的分库分表），可以选择：
>
> 1. **方案 A**：排除 ShardingSphere 自动配置，使用普通数据源，只测试单库逻辑。
> 2. **方案 B**：在 `init-test-schema.sql` 中创建全部分片库，配置 ShardingSphere 连接 Testcontainers 的 MySQL。

### 2.5 数据库初始化脚本

在 `src/test/resources/db/init-test-schema.sql` 中编写建库建表脚本。可以从 `resources/database` 目录下复用现有 SQL：

```sql
-- init-test-schema.sql
-- 创建测试所需的分片库（如果使用方案B）
-- CREATE DATABASE IF NOT EXISTS coupon_hub_merchant_1;

-- 在默认库（coupon_hub_merchant_0）中建表
-- 从 resources/database/merchant-admin 中提取关键表 DDL

CREATE TABLE IF NOT EXISTS t_coupon_template_0 (
    id BIGINT NOT NULL AUTO_INCREMENT,
    shop_number VARCHAR(64),
    name VARCHAR(256),
    source TINYINT,
    target VARCHAR(512),
    type INT,
    valid_start_time DATETIME,
    valid_end_time DATETIME,
    stock INT,
    receive_rule JSON,
    consume_rule JSON,
    status TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    del_flag TINYINT DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 添加其他测试需要的表...
```

> 更好的做法是直接复用 Flyway 迁移。参见"第六步：复用 Flyway 迁移初始化测试库"。

---

## 第三步：编写集成测试用例

### 3.1 merchant-admin 集成测试示例

```text
merchant-admin/src/test/java/edu/seu/couponhub/distribution/service/CouponTemplateServiceIT.java
```

```java
package edu.seu.couponhub.distribution.service;

import edu.seu.couponhub.distribution.BaseIntegrationIT;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 优惠券模板 Service 集成测试。
 * 启动完整 Spring Boot 上下文，连接 Testcontainers 中的 MySQL 和 Redis。
 */
class CouponTemplateServiceIT extends BaseIntegrationIT {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void contextLoads() {
        // 验证 Spring 上下文能正常启动
        assertNotNull(restTemplate);
    }

    @Test
    void shouldReturnHealthyStatus() {
        // 如果配置了 actuator
        // ResponseEntity<String> response = restTemplate.getForEntity(
        //     "/actuator/health", String.class);
        // assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    // 更多业务测试用例...
}
```

### 3.2 DAO 层集成测试示例

```text
merchant-admin/src/test/java/edu/seu/couponhub/distribution/dao/CouponTemplateMapperIT.java
```

```java
package edu.seu.couponhub.distribution.dao;

import edu.seu.couponhub.distribution.BaseIntegrationIT;
import edu.seu.couponhub.distribution.dao.mapper.CouponTemplateMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.jupiter.api.Assertions.*;

/**
 * MyBatis-Plus Mapper 集成测试。
 */
class CouponTemplateMapperIT extends BaseIntegrationIT {

    @Autowired
    private CouponTemplateMapper couponTemplateMapper;

    @Test
    void shouldInjectMapper() {
        assertNotNull(couponTemplateMapper,
                "CouponTemplateMapper should be injected");
    }

    @Test
    void shouldQueryEmptyTable() {
        // 测试空表查询不抛异常
        var result = couponTemplateMapper.selectList(null);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}
```

### 3.3 REST API 集成测试示例

```java
package edu.seu.couponhub.distribution.controller;

import edu.seu.couponhub.distribution.BaseIntegrationIT;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * REST API 集成测试。使用 TestRestTemplate 发送真实 HTTP 请求。
 */
class CouponTemplateControllerIT extends BaseIntegrationIT {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void shouldCreateCouponTemplate() {
        String requestBody = """
                {
                    "shopNumber": "SHOP001",
                    "name": "测试优惠券",
                    "source": 1,
                    "type": 1,
                    "stock": 100
                }
                """;

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

        ResponseEntity<String> response = restTemplate.postForEntity(
                "/api/coupon-template/create", entity, String.class);

        // 根据实际 API 响应结构调整断言
        assertNotNull(response);
        // assertEquals(HttpStatus.OK, response.getStatusCode());
    }
}
```

---

## 第四步：JaCoCo 聚合报告

### 4.1 创建聚合报告模块（推荐方式）

在多模块项目中，需要一个专门的模块来聚合所有子模块的覆盖率数据。

#### 4.1.1 创建 `coverage-report` 模块

在根目录下创建 `coverage-report/pom.xml`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>edu.seu.couponhub</groupId>
        <artifactId>coupon-hub-all</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>

    <artifactId>coupon-hub-coverage-report</artifactId>
    <name>coupon-hub-coverage-report</name>
    <description>JaCoCo 聚合覆盖率报告</description>

    <!--
        需要依赖所有要纳入覆盖率统计的模块，
        JaCoCo report-aggregate 才能找到它们的 class 文件和 exec 文件。
    -->
    <dependencies>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-framework</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-api</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-merchant-admin</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-engine</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-settlement</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-search</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-gateway</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>coupon-hub-database-migration</artifactId>
            <version>${project.version}</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>${jacoco-maven-plugin.version}</version>
                <executions>
                    <execution>
                        <id>report-aggregate</id>
                        <phase>verify</phase>
                        <goals>
                            <goal>report-aggregate</goal>
                        </goals>
                        <configuration>
                            <title>Coupon Hub - 覆盖率聚合报告</title>
                            <outputDirectory>
                                ${project.reporting.outputDirectory}/jacoco-aggregate
                            </outputDirectory>
                            <dataFileIncludes>
                                <dataFileInclude>**/jacoco.exec</dataFileInclude>
                                <dataFileInclude>**/jacoco-it.exec</dataFileInclude>
                            </dataFileIncludes>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

#### 4.1.2 在根 pom.xml 注册模块

在根 `pom.xml` 的 `<modules>` 中追加：

```xml
<!-- 覆盖率聚合报告模块：合并所有子模块的 JaCoCo 数据 -->
<module>coverage-report</module>
```

### 4.2 不创建聚合模块的替代方案

如果不想新增模块，可以在根 pom.xml 中使用 JaCoCo 的 `merge` + `report` goal：

```xml
<!-- 在根 pom.xml 的 build/plugins 中追加 -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>${jacoco-maven-plugin.version}</version>
    <executions>
        <!-- ... 现有 execution 保持不变 ... -->

        <!-- 合并所有模块的 exec 文件 -->
        <execution>
            <id>merge-results</id>
            <phase>verify</phase>
            <goals>
                <goal>merge</goal>
            </goals>
            <configuration>
                <fileSets>
                    <fileSet>
                        <directory>${project.basedir}</directory>
                        <includes>
                            <include>**/target/jacoco.exec</include>
                            <include>**/target/jacoco-it.exec</include>
                        </includes>
                    </fileSet>
                </fileSets>
                <destFile>${project.build.directory}/jacoco-merged.exec</destFile>
            </configuration>
        </execution>
    </executions>
</plugin>
```

> 推荐使用 4.1 的聚合模块方式，更清晰。

---

## 第五步：覆盖率阈值检查（可选）

可以在 JaCoCo 中配置覆盖率阈值，构建不达标时自动失败：

```xml
<!-- 在根 pom.xml 的 jacoco-maven-plugin executions 中追加 -->
<execution>
    <id>check</id>
    <phase>verify</phase>
    <goals>
        <goal>check</goal>
    </goals>
    <configuration>
        <dataFile>${project.build.directory}/jacoco.exec</dataFile>
        <rules>
            <rule>
                <element>BUNDLE</element>
                <limits>
                    <!-- 行覆盖率最低要求 -->
                    <limit>
                        <counter>LINE</counter>
                        <value>COVEREDRATIO</value>
                        <minimum>0.30</minimum>
                    </limit>
                    <!-- 分支覆盖率最低要求 -->
                    <limit>
                        <counter>BRANCH</counter>
                        <value>COVEREDRATIO</value>
                        <minimum>0.20</minimum>
                    </limit>
                </limits>
            </rule>
        </rules>
        <!-- 排除不需要统计覆盖率的类 -->
        <excludes>
            <exclude>**/dto/**</exclude>
            <exclude>**/entity/**</exclude>
            <exclude>**/enums/**</exclude>
            <exclude>**/constant/**</exclude>
            <exclude>**/config/**</exclude>
            <exclude>**/*Application.class</exclude>
        </excludes>
    </configuration>
</execution>
```

> 建议初期阈值设低（如 LINE 30%、BRANCH 20%），随着测试用例增加逐步提高。

---

## 第六步：复用 Flyway 迁移初始化测试库

在集成测试中，可以复用 `database-migration` 模块中的 Flyway 迁移脚本来初始化测试数据库，而不是手写 `init-test-schema.sql`。

### 6.1 修改 BaseIntegrationIT 使用 Flyway

```java
package edu.seu.couponhub.distribution;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.BeforeAll;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import java.sql.Connection;
import java.sql.DriverManager;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
@Testcontainers
public abstract class BaseIntegrationIT {

    static {
        System.setProperty("testcontainers.ryuk.disabled", "true");
    }

    @Container
    protected static final MySQLContainer<?> MYSQL = new MySQLContainer<>(
            DockerImageName.parse("mysql:8.0"))
            .withDatabaseName("bootstrap")
            .withUsername("root")
            .withPassword("test123456")
            .withCommand(
                    "--character-set-server=utf8mb4",
                    "--collation-server=utf8mb4_unicode_ci"
            );

    @SuppressWarnings("resource")
    @Container
    protected static final GenericContainer<?> REDIS = new GenericContainer<>(
            DockerImageName.parse("redis:7.2-alpine"))
            .withExposedPorts(6379)
            .withCommand("redis-server", "--requirepass", "test123456");

    @BeforeAll
    static void initDatabase() throws Exception {
        String baseUrl = MYSQL.getJdbcUrl().replace("/bootstrap", "");
        String user = "root";
        String pass = MYSQL.getPassword();
        String dbParams = "?allowMultiQueries=true&useSSL=false&allowPublicKeyRetrieval=true";

        // 创建分片库
        try (Connection conn = DriverManager.getConnection(
                baseUrl + "/mysql" + dbParams, user, pass)) {
            for (String db : new String[]{
                    "coupon_hub_merchant_0", "coupon_hub_merchant_1"}) {
                conn.createStatement().execute(
                        "CREATE DATABASE IF NOT EXISTS " + db
                        + " DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            }
        }

        // 用 Flyway 迁移初始化表结构
        Flyway.configure()
                .dataSource(baseUrl + "/coupon_hub_merchant_0" + dbParams, user, pass)
                .locations("classpath:db/migration/merchant-admin")
                .baselineOnMigrate(true)
                .load()
                .migrate();
    }

    @DynamicPropertySource
    static void overrideProperties(DynamicPropertyRegistry registry) {
        String baseUrl = MYSQL.getJdbcUrl().replace("/bootstrap", "");
        String jdbcUrl = baseUrl + "/coupon_hub_merchant_0"
                + "?useUnicode=true&characterEncoding=utf8"
                + "&serverTimezone=Asia/Shanghai&useSSL=false"
                + "&allowPublicKeyRetrieval=true";
        registry.add("spring.datasource.url", () -> jdbcUrl);
        registry.add("spring.datasource.username", MYSQL::getUsername);
        registry.add("spring.datasource.password", MYSQL::getPassword);
        registry.add("spring.datasource.driver-class-name",
                () -> "com.mysql.cj.jdbc.Driver");

        registry.add("spring.data.redis.host", REDIS::getHost);
        registry.add("spring.data.redis.port",
                () -> REDIS.getMappedPort(6379));
        registry.add("spring.data.redis.password", () -> "test123456");
    }
}
```

### 6.2 复用 Flyway 迁移脚本的依赖

如果 Flyway 迁移脚本放在 `database-migration` 模块的 classpath 中，业务模块的 test scope 需要添加对 `database-migration` 的 test 依赖：

```xml
<!-- 在 merchant-admin/pom.xml 中添加 -->
<dependency>
    <groupId>${project.groupId}</groupId>
    <artifactId>coupon-hub-database-migration</artifactId>
    <version>${project.version}</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-mysql</artifactId>
    <scope>test</scope>
</dependency>
```

---

## 第七步：CI 集成

### 7.1 修改 ci.yml

在现有 `ci.yml` 的基础上修改。

#### 7.1.1 修改 build-and-unit-test job

```yaml
build-and-unit-test:
  runs-on: ubuntu-latest
  needs: changes
  steps:
    - uses: actions/checkout@v5
    - uses: actions/setup-java@v5
      with:
        distribution: temurin
        java-version: '17'
        cache: maven

    - name: Compile all modules
      run: ./mvnw -T 1C -DskipTests compile

    - name: Run unit tests with JaCoCo
      run: ./mvnw -T 1C test

    # 上传 JaCoCo exec 文件供后续 job 使用
    - name: Upload JaCoCo unit test data
      uses: actions/upload-artifact@v7
      with:
        name: jacoco-ut-exec
        path: '**/target/jacoco.exec'
        if-no-files-found: ignore

    # 上传单元测试报告
    - name: Upload unit test reports
      if: always()
      uses: actions/upload-artifact@v7
      with:
        name: unit-test-reports
        path: '**/target/surefire-reports/'
        if-no-files-found: ignore
```

#### 7.1.2 修改 integration-test job

```yaml
integration-test:
  runs-on: ubuntu-latest
  needs: [changes, build-and-unit-test]
  if: |
    needs.changes.outputs.common == 'true' ||
    needs.changes.outputs.database == 'true' ||
    needs.changes.outputs.merchant_admin == 'true' ||
    needs.changes.outputs.engine == 'true' ||
    needs.changes.outputs.settlement == 'true' ||
    needs.changes.outputs.search == 'true' ||
    needs.changes.outputs.gateway == 'true'
  steps:
    - uses: actions/checkout@v5
    - uses: actions/setup-java@v5
      with:
        distribution: temurin
        java-version: '17'
        cache: maven

    - name: Determine integration test scope
      id: scope
      run: |
        if [[ "${{ needs.changes.outputs.common }}" == "true" || \
              "${{ needs.changes.outputs.database }}" == "true" ]]; then
          echo "mvn_args=-P it verify" >> $GITHUB_OUTPUT
        elif [[ "${{ needs.changes.outputs.merchant_admin }}" == "true" ]]; then
          echo "mvn_args=-pl merchant-admin,database-migration -am -P it verify" >> $GITHUB_OUTPUT
        elif [[ "${{ needs.changes.outputs.engine }}" == "true" ]]; then
          echo "mvn_args=-pl engine,database-migration -am -P it verify" >> $GITHUB_OUTPUT
        elif [[ "${{ needs.changes.outputs.settlement }}" == "true" ]]; then
          echo "mvn_args=-pl settlement,database-migration -am -P it verify" >> $GITHUB_OUTPUT
        elif [[ "${{ needs.changes.outputs.search }}" == "true" ]]; then
          echo "mvn_args=-pl search,database-migration -am -P it verify" >> $GITHUB_OUTPUT
        elif [[ "${{ needs.changes.outputs.gateway }}" == "true" ]]; then
          echo "mvn_args=-pl gateway,database-migration -am -P it verify" >> $GITHUB_OUTPUT
        else
          echo "mvn_args=-P it verify" >> $GITHUB_OUTPUT
        fi

    - name: Run integration tests
      env:
        TESTCONTAINERS_RYUK_DISABLED: true
      run: ./mvnw -T 1C ${{ steps.scope.outputs.mvn_args }}

    # 上传 JaCoCo 集成测试数据
    - name: Upload JaCoCo integration test data
      uses: actions/upload-artifact@v7
      with:
        name: jacoco-it-exec
        path: '**/target/jacoco-it.exec'
        if-no-files-found: ignore

    # 上传集成测试报告
    - name: Upload integration test reports
      if: always()
      uses: actions/upload-artifact@v7
      with:
        name: integration-test-reports
        path: '**/target/failsafe-reports/'
        if-no-files-found: ignore
```

#### 7.1.3 新增覆盖率报告 job

```yaml
coverage-report:
  runs-on: ubuntu-latest
  needs: [build-and-unit-test, integration-test]
  if: always() && needs.build-and-unit-test.result == 'success'
  steps:
    - uses: actions/checkout@v5
    - uses: actions/setup-java@v5
      with:
        distribution: temurin
        java-version: '17'
        cache: maven

    # 下载之前 job 生成的 JaCoCo exec 文件
    - name: Download JaCoCo UT data
      uses: actions/download-artifact@v7
      with:
        name: jacoco-ut-exec
        path: .

    - name: Download JaCoCo IT data
      if: needs.integration-test.result == 'success'
      uses: actions/download-artifact@v7
      with:
        name: jacoco-it-exec
        path: .

    # 编译（需要 class 文件来生成报告）
    - name: Compile for coverage report
      run: ./mvnw -T 1C -DskipTests compile

    # 生成聚合报告
    - name: Generate aggregate coverage report
      run: ./mvnw -pl coverage-report jacoco:report-aggregate

    # 上传 HTML 覆盖率报告
    - name: Upload coverage report
      uses: actions/upload-artifact@v7
      with:
        name: jacoco-coverage-report
        path: coverage-report/target/site/jacoco-aggregate/
        if-no-files-found: warn

    # 可选：在 PR 上添加覆盖率评论
    - name: Add coverage comment to PR
      if: github.event_name == 'pull_request'
      uses: madrapps/jacoco-report@v1.7.1
      with:
        paths: coverage-report/target/site/jacoco-aggregate/jacoco.xml
        token: ${{ secrets.GITHUB_TOKEN }}
        min-coverage-overall: 30
        min-coverage-changed-files: 50
        title: '📊 代码覆盖率报告'
        update-comment: true
```

---

## 第八步：本地执行命令

### 8.1 运行单元测试 + 覆盖率

```bash
./mvnw clean test
```

查看各模块覆盖率报告：

```bash
open merchant-admin/target/site/jacoco-ut/index.html
open engine/target/site/jacoco-ut/index.html
```

### 8.2 运行集成测试 + 覆盖率

```bash
./mvnw clean verify -P it
```

查看集成测试覆盖率报告：

```bash
open merchant-admin/target/site/jacoco-it/index.html
```

### 8.3 生成聚合报告

```bash
# 先运行所有测试
./mvnw clean verify -P it

# 再生成聚合报告
./mvnw -pl coverage-report jacoco:report-aggregate

# 打开聚合报告
open coverage-report/target/site/jacoco-aggregate/index.html
```

### 8.4 仅运行某个模块的集成测试

```bash
./mvnw -pl merchant-admin -am -P it verify
```

---

## 第九步：测试命名与组织规范

### 9.1 文件命名约定

| 类型       | 命名规则             | 由谁执行       | 说明                     |
| ---------- | -------------------- | -------------- | ------------------------ |
| 单元测试   | `*Test.java`         | Surefire       | `test` phase             |
| 集成测试   | `*IT.java`           | Failsafe       | `verify` phase, `-P it`  |

### 9.2 目录结构

```text
merchant-admin/
├── src/
│   ├── main/java/
│   │   └── edu/seu/couponhub/distribution/
│   │       ├── controller/
│   │       ├── service/
│   │       ├── dao/
│   │       └── ...
│   └── test/
│       ├── java/
│       │   └── edu/seu/couponhub/distribution/
│       │       ├── BaseIntegrationIT.java          ← 集成测试基类
│       │       ├── controller/
│       │       │   └── CouponTemplateControllerIT.java
│       │       ├── service/
│       │       │   ├── CouponTemplateServiceTest.java   ← 单元测试
│       │       │   └── CouponTemplateServiceIT.java     ← 集成测试
│       │       └── dao/
│       │           └── CouponTemplateMapperIT.java
│       └── resources/
│           ├── application-test.yaml               ← 测试 profile
│           └── db/
│               └── init-test-schema.sql            ← 数据库初始化（如不用 Flyway）
```

### 9.3 单元测试 vs 集成测试

| 维度         | 单元测试 (`*Test`)           | 集成测试 (`*IT`)                       |
| ------------ | ---------------------------- | -------------------------------------- |
| 外部依赖     | 全部 Mock                   | 真实 MySQL + Redis (Testcontainers)    |
| Spring 上下文 | 不启动 / `@WebMvcTest`      | `@SpringBootTest` 完整启动             |
| 运行速度     | 毫秒级                      | 秒级（首次启动容器较慢）               |
| 适用场景     | 纯业务逻辑、工具类、校验逻辑 | API 端到端、DAO 查询、跨层集成         |
| CI 阶段      | `test` phase（必跑）        | `verify` phase（`-P it`，按需触发）    |

---

## 第十步：JaCoCo 排除配置

### 10.1 不需要统计覆盖率的类

在每个模块的 JaCoCo 配置中排除以下类型：

```xml
<configuration>
    <excludes>
        <!-- DTO / Entity / Enum 等无逻辑的类 -->
        <exclude>**/dto/**</exclude>
        <exclude>**/entity/**</exclude>
        <exclude>**/enums/**</exclude>
        <exclude>**/constant/**</exclude>
        <exclude>**/config/**</exclude>
        <!-- DO 类 -->
        <exclude>**/dao/entity/**</exclude>
        <!-- Mapper 接口（MyBatis 动态代理） -->
        <exclude>**/dao/mapper/**</exclude>
        <!-- 启动类 -->
        <exclude>**/*Application.class</exclude>
        <!-- MQ 事件对象 -->
        <exclude>**/mq/event/**</exclude>
        <exclude>**/mq/base/**</exclude>
    </excludes>
</configuration>
```

### 10.2 通过 Lombok 排除

在根目录 `lombok.config` 中添加（已存在该文件）：

```properties
# 让 Lombok 生成的方法被 JaCoCo 忽略
lombok.addLombokGeneratedAnnotation = true
```

当前 `lombok.config` 已包含这个配置项就不需要重复添加。查看现有内容确认：

```bash
cat lombok.config
```

如果没有 `lombok.addLombokGeneratedAnnotation = true`，需要追加。JaCoCo 0.8.2+ 自动识别 `@lombok.Generated` 注解并排除这些方法。

---

## 文件变更清单

| 文件                                                | 操作  | 说明                                  |
| --------------------------------------------------- | ----- | ------------------------------------- |
| `pom.xml`                                           | 修改  | 添加 JaCoCo 版本属性、插件管理、全局插件、coverage-report 模块注册 |
| `coverage-report/pom.xml`                           | 新增  | JaCoCo 聚合报告模块                   |
| `merchant-admin/pom.xml`                            | 修改  | 添加 Testcontainers / Flyway test 依赖|
| `engine/pom.xml`                                    | 修改  | 同上                                  |
| `settlement/pom.xml`                                | 修改  | 同上                                  |
| `search/pom.xml`                                    | 修改  | 同上                                  |
| `merchant-admin/src/test/java/.../BaseIntegrationIT.java` | 新增 | 集成测试基类                          |
| `merchant-admin/src/test/resources/application-test.yaml` | 新增 | 测试 profile 配置                     |
| `engine/src/test/java/.../BaseIntegrationIT.java`   | 新增  | 同上（调整为 engine 的包名和库名）     |
| `settlement/src/test/java/.../BaseIntegrationIT.java`| 新增 | 同上                                  |
| `search/src/test/java/.../BaseIntegrationIT.java`   | 新增  | 同上                                  |
| `.github/workflows/ci.yml`                          | 修改  | 添加 JaCoCo artifact 上传和覆盖率 job  |
| `lombok.config`                                     | 可能修改 | 确保 `addLombokGeneratedAnnotation = true` |

---

## 常见问题

### Q: Testcontainers 启动慢怎么办？

A: 使用 `@Container` 注解的 static 容器在同一测试类内共享。配合 `@BeforeAll` 只初始化一次。
也可以使用 [Testcontainers 单例模式](https://java.testcontainers.org/test_framework_integration/manual_lifecycle_control/#singleton-containers) 在所有 IT 之间共享容器：

```java
public abstract class BaseIntegrationIT {
    // 不用 @Container，手动管理生命周期
    protected static final MySQLContainer<?> MYSQL;
    protected static final GenericContainer<?> REDIS;

    static {
        MYSQL = new MySQLContainer<>(DockerImageName.parse("mysql:8.0"))
                .withDatabaseName("bootstrap");
        MYSQL.start(); // 全局只启动一次

        REDIS = new GenericContainer<>(DockerImageName.parse("redis:7.2-alpine"))
                .withExposedPorts(6379);
        REDIS.start();
    }
}
```

### Q: ShardingSphere 分片路由在测试中报错？

A: 集成测试有两种策略：
1. **排除 ShardingSphere**：在 `application-test.yaml` 中 exclude 其自动配置，使用普通单数据源。适合不测分片逻辑的场景。
2. **保留 ShardingSphere**：在 `init-test-schema.sql` 或 Flyway 迁移中创建全部分片库（0 和 1），并在 `application-test.yaml` 中配置对应的 ShardingSphere 规则指向 Testcontainers MySQL。

### Q: CI 中 Docker 不可用？

A: GitHub-hosted runner (ubuntu-latest) 自带 Docker，Testcontainers 可以直接使用。确保设置 `TESTCONTAINERS_RYUK_DISABLED=true` 环境变量。

### Q: 如何查看覆盖率趋势？

A: 可以接入以下工具：
- **Codecov**: 在 CI 中上传 `jacoco.xml`，提供历史趋势图和 PR 评论。
- **SonarQube / SonarCloud**: 集成 JaCoCo 报告，提供代码质量 + 覆盖率的完整视图。
