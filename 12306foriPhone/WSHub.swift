//
//  WSHub.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/19.
//  Copyright © 2017年 WS. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class WSHub {
    

}

extension UIView {
    
    public func showLoading() {
        
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    
    public func showHub() {
        let hub = MBProgressHUD.showAdded(to: self, animated: true)
        hub.bezelView.color = .clear
        hub.bezelView.style = .solidColor
    }
    
    
    public func showMessage(_ message: String) {
        
        self.hideHub()
        self.hideLoading()
        let hub = MBProgressHUD.showAdded(to: self, animated: true)
        hub.mode = .text
        hub.label.text = message
        hub.label.textColor = .red
        hub.hide(animated: true, afterDelay: 1.2)
    }
    
    
    public func hideLoading() {
        
        MBProgressHUD.hide(for: self, animated: true)
    }
    
    public func hideHub() {
        
        MBProgressHUD.hide(for: self, animated: true)
    }
    
}
