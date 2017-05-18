//
//  WSServiceError.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/18.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

struct WSServiceError {
    static let Domain = "com.12306Service.error"
    
    enum Code: Int {
        case loginFailed           = -7000
        case queryTicketFailed     = -7001
        case getRandCodeFailed     = -7003
        case checkRandCodeFailed   = -7004
        case checkUserFailed       = -7005
        case submitOrderFailed     = -7006
        case checkOrderInfoFailed  = -7007
        case confirmSingleForQueueFailed  = -7008
        case cancelOrderFailed = -7009
        case zeroOrderFailed = -7010
        case queryTicketNoFailed     = -7011
        case queryTicketPriceFailed     = -7012
        case getPassengerFailed     = -7013
        case loginUserFailed   = -7014
        case autoSumbitOrderFailed   = -7015
        case queryOrderWaitTimeFailed   = -7016
        case getQueueCountFailed   = -7017
    }
    
    static let errorDic = [
        Code.loginFailed:"登录失败",
        Code.queryTicketFailed:"未能查到任何车次,请检查查询设置",
        Code.autoSumbitOrderFailed: "自动提交订单失败",
        Code.getRandCodeFailed: "获取验证码失败",
        Code.checkRandCodeFailed: "验证码错误",
        Code.checkUserFailed: "非登录状态，需要重新登录",
        Code.submitOrderFailed: "提交订单失败",
        Code.checkOrderInfoFailed: "订单信息错误",
        Code.confirmSingleForQueueFailed: "锁定订单失败",
        Code.getQueueCountFailed: "获取排队信息失败",
        Code.queryOrderWaitTimeFailed: "查询订单剩余时间失败",
        Code.cancelOrderFailed: "取消订单失败",
        Code.zeroOrderFailed:"您没有历史订单",
        Code.queryTicketNoFailed:"查询车次详细信息失败",
        Code.getPassengerFailed:"查询乘客信息失败",
        Code.queryTicketPriceFailed:"查询票价失败",
        Code.loginUserFailed:"登录用户失败"]
    
    static func errorWithCode(_ code:Code)->NSError{
        if errorDic.keys.contains(code) {
            return errorWithCode(code, failureReason: errorDic[code]!)
        }else{
            return errorWithCode(code, failureReason: "未知错误")
        }
    }
    
    static func errorWithCode(_ code:Code, failureReason: String) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        return NSError(domain: Domain, code: code.rawValue, userInfo: userInfo)
    }
}
