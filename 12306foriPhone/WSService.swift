//
//  WSService.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/23.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import SwiftyJSON


class WSService: SessionDelegate{
    
    static let shardInstance = WSService()
    
    private override init() {}
    
    static var manager: Alamofire.SessionManager = {
    
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
        let manager = Alamofire.SessionManager(
            configuration:configuration,
            serverTrustPolicyManager:ServerTrustPolicyManager(policies: serverTrustPolicies)
        )

        return manager
    }()

    
    func requestDynamicJs(_ jsName:String,referHeader:[String:String])->Promise<Void>{
        return Promise{ fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/dynamicJs/" + jsName
            WSService.manager.request(url, headers:referHeader).response(completionHandler:{ _ in
                fulfill()
            }) 
        }
    }

}



