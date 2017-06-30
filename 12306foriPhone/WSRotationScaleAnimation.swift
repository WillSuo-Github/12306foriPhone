//
//  WSRotationScaleAnimation.swift
//  12306foriPhonex
//
//  Created by WS on 2017/6/25.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSRotationScaleAnimation {

    public class func startAnimation(_ viewController: UIViewController) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 400.0
        
        transform = CATransform3DRotate(transform, CGFloat(-Double.pi / 8), 1, 0, 0)
        viewController.view.layer.anchorPoint = CGPoint.init(x: 0.1, y: 0);
//        viewController.view.frame.origin.y -= UIScreen.main.bounds.size.height / 2
        
        UIView.animate(withDuration: 1) {
            viewController.view.layer.transform = transform
        }
    }
}
