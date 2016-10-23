//
//  WSService.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/23.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
import Alamofire

class WSService: SessionDelegate{
    static var session: Alamofire.SessionManager = {
    
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["kyfw.12306.cn": ServerTrustPolicy.pinCertificates(
            certificates:ServerTrustPolicy.certificates(in: Bundle.main),
            validateCertificateChain: true,
            validateHost: true)]
        
        let configuration = URLSessionConfiguration.default
        
        configuration.httpCookieAcceptPolicy = .always
        configuration.httpAdditionalHeaders = [
            "refer": "https://kyfw.12306.cn/otn/leftTicket/init",
            "Host": "kyfw.12306.cn",
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:36.0) Gecko/20100101 Firefox/36.0",
            "Connection" : "keep-alive"
        ]
        configuration.timeoutIntervalForRequest = 5
        let manager = Alamofire.ServerTrustPolicyManager(policies: serverTrustPolicies)
        
        return Alamofire.SessionManager(configuration: configuration, delegate: WSService(), serverTrustPolicyManager: manager)
    }()

}



