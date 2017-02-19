//
//  WSService+login.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/23.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

extension WSService {

    func requestLoginCode(randomCode: String, successBlock: @escaping (UIImage) -> (), failBlock: @escaping (Error) -> ()) {
        
        
    }
    
    func getPassCodeForLogin() -> Promise<UIImage>{
        return Promise{ fulfill, reject in
            
            let randomCode = CGFloat(Float(arc4random()) / Float(UINT32_MAX))//0~1
            let url = "https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=login&rand=sjrand&" + randomCode.description
            let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
            
            WSService.manager.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { (response) in
                
                switch (response.result) {
                case .success(let data):
                    
                    if let image = UIImage(data: data) {
                        fulfill(image)
                    }else{
                        reject(NSError(domain: "获取图片失败", code: 1, userInfo: nil))
                    }
                case .failure(let error) :
                    
                    reject(error)
                }
            }
        }
    }
    
    func requestLogin(randomCode: String, successBlock: @escaping (UIImage) -> (), failBlock: @escaping (Error) -> ()) {
        let url = "https://kyfw.12306.cn/otn/passcodeNew/checkRandCodeAnsyn"
        let params = ["randCode":randomCode,"rand":"sjrand"]
        let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
        WSService.manager.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch (response.result){
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func preLoginFlow(success:@escaping (UIImage)->Void, failure:@escaping (NSError)->Void) {
        loginInit().then {dynamicJS -> Promise<Void> in
            return self.requestDynamicJs(dynamicJS, referHeader: ["refer": "https://kyfw.12306.cn/otn/login/init"])
        }.then { (_) -> Promise<UIImage> in
            return self .getPassCodeForLogin()
        }.then { image in
            success(image)
        }.catch { error in
            failure(error as NSError)
        }
    }
    
    func loginInit() -> Promise<String> {
        return Promise{ fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/login/init"
            let headers = ["refer": "https://kyfw.12306.cn/otn/leftTicket/init"]
            
            WSService.manager.request(url, headers: headers).responseString(completionHandler: { response in
                switch (response.result) {
                case .failure(let error):
                    reject(error)
                case .success(let content):
                    var dynamemicJS = ""
                    if let matches = Regex("src=\"/otn/dynamicJs/([^\"]+)\"").getMatches(content){
                        dynamemicJS = matches[0][0]
                    }else{
                        print("faile to get dynamemicjs:\(content)")
                    }
                    fulfill(dynamemicJS)
                }
            })
        }
    }
    
}
