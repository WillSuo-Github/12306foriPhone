//
//  WSService+QueryTicket.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/14.
//  Copyright © 2017年 WS. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

extension WSService {
    
    func queryTicketFlowWith(_ params: WSLeftTicketParam, success:@escaping ([WSQueryLeftNewDTO]) -> Void, failure:@escaping (Error) -> Void) {
        
        var queryLog = false
        var queryUrl = ""
        
        self.queryTicketInit().then { (isQueryLog, leftUrl, jsName) -> Promise<Void> in
            queryLog = isQueryLog
            queryUrl = leftUrl
            return self.requestDynamicJs(jsName, referHeader: ["refer": "https://kyfw.12306.cn/otn/leftTicket/init"])
        }.then{ () -> Promise<Void> in
            return self.queryTicketLogWith(params, isQueryLog: queryLog)
        }.then { _ -> Promise<[WSQueryLeftNewDTO]> in
            return self.queryTicketWith(params, queryUrl: queryUrl)
        }.then { tickets in
            success(tickets)
        }.catch { error in
            failure(error)
        }
    }
    
//MARK:- Chainable Request
    func queryTicketInit() -> Promise<(Bool, String, String)> {
        return Promise{ fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/leftTicket/init"
            WSService.manager.request(url).responseString(completionHandler: { response in
                switch response.result {
                case .success(let content):
                    var cLeftTicketUrl: String = "leftTicket/queryT"
                    if let matches = Regex("var CLeftTicketUrl = '([^']+)'").getMatches(content) {
                        cLeftTicketUrl = matches[0][0]
                    }else {
                        print("fail to get CLeftTicketUrl:\(content)")
                    }
                    
                    var isSaveQueryLog = true
                    if let matches = Regex("var isSaveQueryLog='([^']+)'").getMatches(content) {
                        let isSaveQueryLogStr = matches[0][0]
                        if isSaveQueryLogStr == "Y" {
                            isSaveQueryLog = true
                        }else {
                            isSaveQueryLog = false
                        }
                    }else {
                        print("fail to get isSaveQueryLog:\(content)")
                    }
                    
                    var dynamicJs = ""
                    if let matches = Regex("src=\"/otn/dynamicJs/([^\"]+)\"").getMatches(content) {
                        dynamicJs = matches[0][0]
                    }else {
                        print("fail to get dynamicJs:\(content)")
                    }
                    
                    let isQueryLog = isSaveQueryLog
                    let leftUrl = cLeftTicketUrl
                    let jsName = dynamicJs
                    fulfill(isQueryLog, leftUrl, jsName)

                    
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    func queryTicketLogWith(_ params: WSLeftTicketParam, isQueryLog:Bool) -> Promise<Void> {
        return Promise{ fulfill, reject in
            let headers = ["refer": "https://kyfw.12306.cn/otn/leftTicket/init",
                           "If-Modified-Since":"0",
                           "Cache-Control":"no-cache"]
            if isQueryLog {
                let url = "https://kyfw.12306.cn/otn/leftTicket/log?" + params.ToGetParams()
                WSService.manager.request(url, headers:headers).responseString(completionHandler: { response in
                    
                })
            }
            fulfill()
        }
    }
    
    func queryTicketWith(_ params: WSLeftTicketParam, queryUrl: String) -> Promise<[WSQueryLeftNewDTO]> {
        return Promise{ fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/" + queryUrl + "?" + params.ToGetParams()
            let headers = ["refer": "https://kyfw.12306.cn/otn/leftTicket/init",
                           "If-Modified-Since":"0",
                           "Cache-Control":"no-cache"]
            
            WSService.manager.request(url, headers: headers).responseData(completionHandler: { data in
                let str = JSON(data.data)
                print(str)
            })
            
            WSService.manager.request(url, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)["data"]
                    let flag = json["flag"].intValue
                    if flag == 1 {
                        var tickets = [WSQueryLeftNewDTO]()
                        let res = json["result"]
                        let map = json["map"]
                        for json in res.arrayValue {
                            let leftTicket = WSQueryLeftNewDTO(json: json, map: map, dateStr: params.train_date)
                            tickets.append(leftTicket)
                        }
                        fulfill(tickets)
                    }else {
                        let error: Error
                        let jsonMessage = JSON(data)["message"]
                        if jsonMessage.count != 0 {
                            if let errorMessage = jsonMessage[0].string {
                                error = WSServiceError.errorWithCode(.queryTicketFailed, failureReason: errorMessage)
                            }else {
                                error = WSServiceError.errorWithCode(.queryTicketFailed)
                            }
                        }else {
                            error = WSServiceError.errorWithCode(.queryTicketFailed)
                        }
                        reject(error)
                    }
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
}
