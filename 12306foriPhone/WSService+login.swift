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
import SwiftyJSON
import JavaScriptCore

extension WSService {
    
//MARK:- Request Flow
    
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
    
    func loginFlow(user: String, passWord: String, randCodeStr: String, success: () -> Void, failure: (NSError)->Void) {
        after(interval: 2).then {
            self.verifyRandomCodeForLogin(randCodeStr)
        }.then { () -> Promise<Void> in
            return self.loginUserWith(user, passWord: passWord, randCodeStr: randCodeStr)
        }
    }
    
    
//MARK:- Chainable Request
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
    
    
    func verifyRandomCodeForLogin(_ randomCodeStr:String) -> Promise<Void> {
        return Promise{ fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/passcodeNew/checkRandCodeAnsyn"
            let params = ["randCode":randomCodeStr,"rand":"sjrand"]
            let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
            WSService.manager.request(url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    if  let msg = JSON(data)["data"]["msg"].string, msg == "TRUE" {
                        fulfill()
                    }else{
                        let error = WSServiceError.errorWithCode(.checkRandCodeFailed)
                        reject(error)
                    }
                }
            })
        }
    }
    
    func loginUserWith(_ user: String, passWord: String, randCodeStr: String) -> Promise<Void> {
        return Promise { fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/login/loginAysnSuggest"
            let params = ["loginUserDTO.user_name":user,"userDTO.password":passWord,"randCode":randCodeStr]
            let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
            WSService.manager.request(url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    if let loginCheck = JSON(data)["data"]["loginCheck"].string, loginCheck == "Y" {
                        WSUserModule.userName =  user
                        fulfill()
                    }else{
                        let error: NSError
                        if let errorStr = JSON(data)["messages"][0].string{
                            error = WSServiceError.errorWithCode(.loginUserFailed, failureReason: errorStr)
                        }else{
                            error = WSServiceError.errorWithCode(.loginUserFailed)
                        }
                        reject(error)
                    }
                }
            })
        }
    }
    
    func initMy12306() -> Promise<Void> {
        return Promise { fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/index/initMy12306"
            let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
            WSService.manager.request(url, method: .post, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    if let matches = Regex("(var user_name='[^']+')").getMatches(data as! String) {
                        let context = JSContext()!
                        context.evaluateScript(matches[0][0])
                        WSUserModule.realName = context.objectForKeyedSubscript("user_name").toString()
                    }else{
                        print("can't get user_name")
                    }
                    fulfill()
                }
            })
        }
    }
    
}
