//
//  WSLogin.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/22.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

let KLogin_status = "WSLogin_status"

class WSLogin: NSObject {
    
    static var isLogin: Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: KLogin_status)
        }
        get{
            if let status = UserDefaults.standard.value(forKey: KLogin_status) as? Bool {
                return status
            }else{
                return false
            }
        }
    }

    static func checkLogin() -> Bool {
        if WSLogin.isLogin {
            return true
        }else{
            UIApplication.shared.keyWindow?.rootViewController?.present(WSLoginController(), animated: true, completion: nil)
            return false
        }
    }
}
