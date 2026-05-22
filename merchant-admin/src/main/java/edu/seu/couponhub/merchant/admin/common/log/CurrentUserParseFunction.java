package edu.seu.couponhub.merchant.admin.common.log;

import com.mzt.logapi.service.IParseFunction;
import edu.seu.couponhub.merchant.admin.common.context.UserContext;
import org.springframework.stereotype.Component;

/**
 * 操作日志组件解析当前登录用户信息
 * <p>
 */
@Component
public class CurrentUserParseFunction implements IParseFunction {

    @Override
    public String functionName() {
        return "CURRENT_USER";
    }

    @Override
    public String apply(Object value) {
        return UserContext.getUsername();
    }
}
