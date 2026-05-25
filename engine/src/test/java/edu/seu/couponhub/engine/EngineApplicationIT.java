package edu.seu.couponhub.engine;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.data.redis.core.StringRedisTemplate;

import javax.sql.DataSource;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class EngineApplicationIT extends BaseIntegrationIT {

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Test
    void shouldLoadSpringContextWithContainers() throws Exception {
        assertNotNull(applicationContext);
        try (var connection = dataSource.getConnection()) {
            assertTrue(connection.isValid(2));
        }

        stringRedisTemplate.opsForValue().set("engine:integration-test", "ok");
        assertEquals("ok", stringRedisTemplate.opsForValue().get("engine:integration-test"));
    }
}
