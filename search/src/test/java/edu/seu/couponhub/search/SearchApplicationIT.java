package edu.seu.couponhub.search;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;

import javax.sql.DataSource;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SearchApplicationIT extends BaseIntegrationIT {

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;

    @Test
    void shouldLoadSpringContextWithContainers() throws Exception {
        assertNotNull(applicationContext);
        assertNotNull(elasticsearchTemplate);
        try (var connection = dataSource.getConnection()) {
            assertTrue(connection.isValid(2));
        }

        stringRedisTemplate.opsForValue().set("search:integration-test", "ok");
        assertEquals("ok", stringRedisTemplate.opsForValue().get("search:integration-test"));
    }
}
