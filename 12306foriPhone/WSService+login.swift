//
//  WSService+login.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/23.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
import Alamofire

extension WSService {

    func requestLoginCode(randomCode: String, successBlock: @escaping (UIImage) -> (), failBlock: @escaping (Error) -> ()) {
        
        let url = "https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=login&rand=sjrand&" + randomCode
        let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
    
        WSService.session.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            
            switch (response.result) {
            case .success(let data):
                
                let image = UIImage(data: data)
                successBlock(image!)
                
            case .failure(let error) :
                
                failBlock(error)
            }
        }
    }
    
    func requestLogin(randomCode: String, successBlock: @escaping (UIImage) -> (), failBlock: @escaping (Error) -> ()) {
        let url = "https://kyfw.12306.cn/otn/passcodeNew/checkRandCodeAnsyn"
        let params = ["randCode":randomCode,"rand":"sjrand"]
        let headers = ["refer": "https://kyfw.12306.cn/otn/login/init"]
        WSService.session.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch (response.result){
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
