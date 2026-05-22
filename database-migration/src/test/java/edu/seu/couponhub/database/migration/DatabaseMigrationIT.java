package edu.seu.couponhub.database.migration;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static org.junit.jupiter.api.Assertions.assertTrue;

@Testcontainers
class DatabaseMigrationIT {

    static {
        System.setProperty("ryuk.disabled", "true");
        System.setProperty("testcontainers.ryuk.disabled", "true");
    }

    @Container
    private static final MySQLContainer<?> MYSQL = new MySQLContainer<>(DockerImageName.parse("mysql:8.0"))
            .withDatabaseName("bootstrap")
            .withUsername("coupon_hub")
            .withPassword("coupon_hub");

    @Test
    void shouldMigrateAllServiceDatabases() throws Exception {
        String baseUrl = MYSQL.getJdbcUrl().replace("/bootstrap", "");
        String user = "root";
        String pass = MYSQL.getPassword();
        String dbParams = "?allowMultiQueries=true&useSSL=false&allowPublicKeyRetrieval=true";

        // Create databases (equivalent to antrun:run@create-databases)
        try (Connection conn = DriverManager.getConnection(baseUrl + "/mysql" + dbParams, user, pass)) {
            String[] dbs = {
                "coupon_hub_merchant_0", "coupon_hub_merchant_1",
                "coupon_hub_engine_0", "coupon_hub_engine_1",
                "coupon_hub_settlement_0", "coupon_hub_settlement_1"
            };
            for (String db : dbs) {
                conn.createStatement().execute(
                    "CREATE DATABASE IF NOT EXISTS " + db
                    + " DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            }
        }

        // Run Flyway for each service
        Flyway.configure()
                .dataSource(baseUrl + "/coupon_hub_merchant_0" + dbParams, user, pass)
                .locations("classpath:db/migration/merchant-admin")
                .baselineOnMigrate(true)
                .load()
                .migrate();

        Flyway.configure()
                .dataSource(baseUrl + "/coupon_hub_engine_0" + dbParams, user, pass)
                .locations("classpath:db/migration/engine")
                .baselineOnMigrate(true)
                .load()
                .migrate();

        Flyway.configure()
                .dataSource(baseUrl + "/coupon_hub_settlement_0" + dbParams, user, pass)
                .locations("classpath:db/migration/settlement")
                .baselineOnMigrate(true)
                .load()
                .migrate();

        // Verify
        try (Connection conn = DriverManager.getConnection(baseUrl + "/mysql" + dbParams, user, pass)) {
            assertTrue(schemaExists(conn, "coupon_hub_merchant_0"));
            assertTrue(schemaExists(conn, "coupon_hub_merchant_1"));
            assertTrue(schemaExists(conn, "coupon_hub_engine_0"));
            assertTrue(schemaExists(conn, "coupon_hub_engine_1"));
            assertTrue(schemaExists(conn, "coupon_hub_settlement_0"));
            assertTrue(schemaExists(conn, "coupon_hub_settlement_1"));
            assertTrue(tableExists(conn, "coupon_hub_merchant_0", "t_coupon_template_0"));
            assertTrue(tableExists(conn, "coupon_hub_engine_1", "t_user_coupon_31"));
            assertTrue(tableExists(conn, "coupon_hub_settlement_1", "t_coupon_settlement_15"));
        }
    }

    private boolean schemaExists(Connection connection, String schemaName) throws Exception {
        String sql = "select count(*) from information_schema.schemata where schema_name = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, schemaName);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1) == 1;
            }
        }
    }

    private boolean tableExists(Connection connection, String schemaName, String tableName) throws Exception {
        String sql = "select count(*) from information_schema.tables where table_schema = ? and table_name = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, schemaName);
            statement.setString(2, tableName);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1) == 1;
            }
        }
    }
}
