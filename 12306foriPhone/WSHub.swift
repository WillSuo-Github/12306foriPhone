//
//  WSHub.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/19.
//  Copyright © 2017年 WS. All rights reserved.
//

import Foundation
import UIKit

class WSHub {
    
    public static let sharedInstance = WSHub()
    private let restorationIdentifier = "NVActivityIndicatorViewContainer"
    
}

private var activityViewKey: UInt8 = 0
private var coverViewKey: UInt8 = 1
extension UIView {

    var ex_activityView: NVActivityIndicatorView {
        get {
            return associatedObject(base: self, key: &activityViewKey)
            {
                let tmpView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScalePulseOutRapid, color: .red, padding: 5)
                return tmpView
            }
        }
        set { associateObject(base: self, key: &activityViewKey, value: newValue) }
    }
    
    var ex_coverView: UIView {
        get {
            return associatedObject(base: self, key: &coverViewKey, initialiser: {
                let coverView = UIView()
                coverView.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
                return coverView
            })
        }
        
        set { associateObject(base: self, key: &coverViewKey, value: newValue)}
    }
    
    
    
    public func showHub() {
        ex_coverView.isHidden = false;
        self.addSubview(ex_coverView)
        self.addSubview(ex_activityView)
        
        ex_coverView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        ex_activityView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        ex_activityView.padding = 40
        ex_activityView.startAnimating()
    }
    
    
    
    public func hideHub() {
        
        ex_coverView.isHidden = true;
        ex_coverView.removeFromSuperview()
        ex_activityView.stopAnimating()
    }
    
    
    private func associatedObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> ValueType)
        -> ValueType {
            if let associated = objc_getAssociatedObject(base, key)
                as? ValueType { return associated }
            let associated = initialiser()
            objc_setAssociatedObject(base, key, associated,
                                     .OBJC_ASSOCIATION_RETAIN)
            return associated
    }
    
    private func associateObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
    
}
