//
//  WSConfig.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSConfig: NSObject {
    
    public static let WSPlaceHolderColor: UIColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    
    public static let SizeScale: CGFloat = UIScreen.main.bounds.size.width / 414.0
    public static let keywindow = UIApplication.shared.keyWindow!
    
    public static func getViewController(inView: UIView) -> UIViewController? {
        
        var view: UIView? = inView
        
        while view != nil {
            let nextResponder = view?.next
            if let next = nextResponder {
                if next.isKind(of: UIViewController.self) {
                    return next as! UIViewController
                }else{
                    view = (next as! UIView).superview!
                }
            }else{
                return nil
            }
        }
        
        return nil
    }
}

