//
//  WSService+Order.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/18.
//  Copyright © 2017年 WS. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

extension WSService {
    
    func getPassengerDTOs(isAuto: Bool = false, isSubmit: Bool = true) -> Promise<Void> {
        return Promise { fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/confirmPassenger/getPassengerDTOs"
            let params:[String:String]
            let headers:[String:String]
            if !isSubmit {
                params = ["_json_att":""]
                headers = ["refer": "https://kyfw.12306.cn/otn/leftTicket/init"]
            }else{
                if !isAuto {
                    params = ["_json_att":"","REPEAT_SUBMIT_TOKEN":WSUserModule.globalRepeatSubmitToken]
                    headers = ["refer": "https://kyfw.12306.cn/otn/confirmPassenger/initDc"]
                }
                else {
                    params = ["_json_att":""]
                    headers = ["refer": "https://kyfw.12306.cn/otn/leftTicket/init"]
                }
            }
            
            WSService.manager.request(url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    let json = JSON(data)["data"]
                    if json["normal_passengers"].count == 0 {
                        print("\(json)")
                        let error: NSError
                        if let errorMsg = json["exMsg"].string {
                            error = WSServiceError.errorWithCode(.getPassengerFailed, failureReason: errorMsg)
                        }else{
                            error = WSServiceError.errorWithCode(.getPassengerFailed)
                        }
                        reject(error)
                        return
                    }
                    var passengers = [WSPassengerDTO]()
                    for i in 0...json["normal_passengers"].count - 1 {
                        passengers.append(WSPassengerDTO(json: json["normal_passengers"][i]))
                    }
                    if !WSUserModule.isGetPassengersInfo {
                        WSUserModule.passengers = passengers
                        WSUserModule.isGetPassengersInfo = true
                    }
                    fulfill()
                }
            })
            
        }
    }
}
