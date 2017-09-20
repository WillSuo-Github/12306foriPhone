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
                return self.getPassCodeForLogin()
            }.then { image in
                success(image)
            }.catch { error in
                failure(error as NSError)
        }
    }
    
    func loginFlow(user: String, passWord: String, randCodeStr: String, success: @escaping () -> Void, failure: @escaping (NSError)->Void) {
        after(interval: 2).then {
            self.verifyRandomCodeForLogin(randCodeStr)
        }.then { () -> Promise<Void> in
            return self.loginUserWith(user, passWord: passWord, randCodeStr: randCodeStr)
        }.then { () -> Promise<Void> in
            return self.authorUserLogin()
        }.then { () -> Promise<Void> in
            return self.initRealName()
        }.then { () -> Promise<Void> in
            return self.getPassengerDTOs(isSubmit: false)
        }.then { _ in
            success()
        }.catch { error in
            failure(error as NSError)
        }
    }
    
    
//MARK:- Chainable Request
    func getPassCodeForLogin() -> Promise<UIImage>{
        return Promise{ fulfill, reject in
            
            let randomCode = CGFloat(Float(arc4random()) / Float(UINT32_MAX))//0~1
            let url = "https://kyfw.12306.cn/passport/captcha/captcha-image?login_site=E&module=login&rand=sjrand&" + randomCode.description
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
            let url = "https://kyfw.12306.cn/passport/captcha/captcha-check"
            let params = ["answer":randomCodeStr, "rand":"sjrand", "login_site":"E"]
            let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
            WSService.manager.request(url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    if  let code = JSON(data)["result_code"].string, code == "4" {
                        fulfill()
                    }else{
                        let error = WSServiceError.errorWithCode(.checkRandCodeFailed)
                        reject(error)
                    }
                }
            })
        }
    }
    
    func authorUserLogin() -> Promise<Void> {
        return Promise{ fulfill, reject in
            let url = "https://kyfw.12306.cn/passport/web/auth/uamtk"
            let params = ["appid":"otn"]
            WSService.manager.request(url, method: .post, parameters: params).responseJSON(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    if let code = JSON(data)["result_code"].int, code == 0 {
                        if let apptk = JSON(data)["newapptk"].string {
                            WSUserModule.apptk = apptk
                        }else{
                            print("can't get the apptk")
                        }
                        fulfill()
                    }else{
                        let error = WSServiceError.errorWithCode(.loginUserFailed)
                        reject(error)
                    }
                }
            })
        
        }
    }
    
    func loginUserWith(_ user: String, passWord: String, randCodeStr: String) -> Promise<Void> {
        return Promise { fulfill, reject in
            let url = "https://kyfw.12306.cn/passport/web/login"
            let params = ["username":user,"password":passWord,"appid":"otn"]
            let headers = ["refer": "https://kyfw.12306.cn/otn/login/init",
                           "Accept": "application/json"]
            WSService.manager.request(url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: { response in

                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    if  let code = JSON(data)["result_code"].int, code == 0 {
                        fulfill()
                    }else{
                        let error = WSServiceError.errorWithCode(.loginFailed)
                        reject(error)
                    }
                }
            })
        }
    }
    
    func initRealName() -> Promise<Void> {
        return Promise { fulfill, reject in
            let url = "https://kyfw.12306.cn/otn/uamauthclient"
            let params = ["tk": WSUserModule.apptk]
            WSService.manager.request(url, method: .post, parameters: params).responseJSON(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    reject(error)
                case .success(let data):
                    if let userName = JSON(data)["username"].string {
                        WSUserModule.realName = userName
                    }else{
                        print("can't get user_name")
                    }
                    fulfill()
                }
            })
        }
    }
    
    

}
