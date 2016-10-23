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
    
    func requestLoginCode(successBlock: @escaping (UIImage) -> (), failBlock: @escaping (Error) -> ()) {
        
        let random = CGFloat(Float(arc4random()) / Float(UINT32_MAX))//0~1
        let url = "https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=login&rand=sjrand&" + random.description
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
    
}
