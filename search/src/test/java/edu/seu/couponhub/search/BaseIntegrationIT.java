package edu.seu.couponhub.search;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

@SpringBootTest(
        classes = SearchApplication.class,
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT
)
@ActiveProfiles("test")
@Testcontainers
public abstract class BaseIntegrationIT {

    private static final String DATABASE_NAME = "coupon_hub_search";
    private static final String MYSQL_USERNAME = "coupon_hub";
    private static final String MYSQL_PASSWORD = "coupon_hub";
    private static final String REDIS_PASSWORD = "coupon_hub";

    static {
        System.setProperty("ryuk.disabled", "true");
        System.setProperty("testcontainers.ryuk.disabled", "true");
    }

    @Container
    protected static final MySQLContainer<?> MYSQL = new MySQLContainer<>(DockerImageName.parse("mysql:8.0"))
            .withDatabaseName(DATABASE_NAME)
            .withUsername(MYSQL_USERNAME)
            .withPassword(MYSQL_PASSWORD)
            .withCommand(
                    "--character-set-server=utf8mb4",
                    "--collation-server=utf8mb4_unicode_ci"
            );

    @SuppressWarnings("resource")
    @Container
    protected static final GenericContainer<?> REDIS = new GenericContainer<>(DockerImageName.parse("redis:7.2-alpine"))
            .withExposedPorts(6379)
            .withCommand("redis-server", "--requirepass", REDIS_PASSWORD);

    @MockBean
    protected ElasticsearchTemplate elasticsearchTemplate;

    @DynamicPropertySource
    static void overrideProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", BaseIntegrationIT::jdbcUrl);
        registry.add("spring.datasource.username", () -> MYSQL_USERNAME);
        registry.add("spring.datasource.password", () -> MYSQL_PASSWORD);
        registry.add("spring.datasource.driver-class-name", () -> "com.mysql.cj.jdbc.Driver");

        registry.add("spring.data.redis.host", REDIS::getHost);
        registry.add("spring.data.redis.port", () -> REDIS.getMappedPort(6379));
        registry.add("spring.data.redis.password", () -> REDIS_PASSWORD);
        registry.add("spring.redis.host", REDIS::getHost);
        registry.add("spring.redis.port", () -> REDIS.getMappedPort(6379));
        registry.add("spring.redis.password", () -> REDIS_PASSWORD);
    }

    private static String jdbcUrl() {
        String jdbcUrl = MYSQL.getJdbcUrl();
        String separator = jdbcUrl.contains("?") ? "&" : "?";
        return jdbcUrl + separator
                + "useUnicode=true&characterEncoding=utf8"
                + "&serverTimezone=Asia/Shanghai"
                + "&rewriteBatchedStatements=true"
                + "&allowMultiQueries=true";
    }
}
