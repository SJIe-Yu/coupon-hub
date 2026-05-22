package edu.seu.couponhub.distribution.service;

import edu.seu.couponhub.distribution.dto.req.MessageSendReqDTO;
import edu.seu.couponhub.distribution.dto.resp.MessageSendRespDTO;

/**
 * 消息发送接口
 * 正常来说这应该有个独立消息服务，因为消息通知不在优惠券系统核心范畴，所以仅展示流程
 * <p>
 */
public interface MessageSendService {

    /**
     * 消息发送接口
     *
     * @param requestParam 消息发送请求参数
     * @return 消息发送结果
     */
    MessageSendRespDTO sendMessage(MessageSendReqDTO requestParam);
}
