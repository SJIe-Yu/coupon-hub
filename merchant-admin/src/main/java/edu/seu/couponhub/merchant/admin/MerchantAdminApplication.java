package edu.seu.couponhub.merchant.admin;

import com.mzt.logapi.starter.annotation.EnableLogRecord;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.FullyQualifiedAnnotationBeanNameGenerator;

/**
 * 商家后管服务｜创建优惠券、店家查看以及管理优惠券、创建优惠券发放批次及执行分发等
 * <p>
 */
@SpringBootApplication(scanBasePackages = {
        "edu.seu.couponhub.merchant.admin",
        "edu.seu.couponhub.distribution"
})
@EnableDiscoveryClient
@EnableFeignClients(basePackages = "edu.seu.couponhub.api")
@EnableLogRecord(tenant = "MerchantAdmin")
@MapperScan(
        value = {
                "edu.seu.couponhub.merchant.admin.dao.mapper",
                "edu.seu.couponhub.distribution.dao.mapper"
        },
        nameGenerator = FullyQualifiedAnnotationBeanNameGenerator.class
)
public class MerchantAdminApplication {

    public static void main(String[] args) {
        SpringApplication.run(MerchantAdminApplication.class, args);
    }
}
