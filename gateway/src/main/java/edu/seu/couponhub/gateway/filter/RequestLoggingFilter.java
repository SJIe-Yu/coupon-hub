package edu.seu.couponhub.gateway.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpMethod;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
public class RequestLoggingFilter implements GlobalFilter, Ordered {

    private static final Logger LOG = LoggerFactory.getLogger(RequestLoggingFilter.class);

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        HttpMethod method = request.getMethod();

        long startTime = System.currentTimeMillis();

        // TODO: 接入统一认证后，在网关解析登录态并透传用户上下文请求头，替代下游服务本地固定用户。
        LOG.info("请求URI: {}", request.getURI());
        LOG.info("请求类型: {}", method);
        LOG.info("请求头: {}", request.getHeaders());

        if (method == HttpMethod.GET) {
            LOG.info("请求参数: {}", request.getQueryParams());
        }

        return chain.filter(exchange).then(Mono.fromRunnable(() -> {
            long duration = System.currentTimeMillis() - startTime;
            LOG.info("响应时间：{} ms", duration);
        }));
    }

    @Override
    public int getOrder() {
        return -1;
    }
}
