//
//  WSRotationScaleAnimation.swift
//  12306foriPhonex
//
//  Created by WS on 2017/6/25.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSRotationScaleAnimation {
    
    static var animtionDuration: CGFloat = 0.0

    public class func showAnimation(_ viewController: UIViewController, _ duration: CGFloat) {
        animtionDuration = duration
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 900.0
        transform = CATransform3DScale(transform, 0.95, 0.95, 1);
        transform = CATransform3DRotate(transform, CGFloat(12 * Double.pi / 180.0), 1, 0, 0)
        UIView.animate(withDuration: TimeInterval(animtionDuration / 2), animations: {
            viewController.view.layer.transform = transform
        }) { isCompleted in
            startRotateSecondAnimation(viewController)
        }
    }
    
    public class func hideAnimation(_ viewController: UIViewController) {
        UIView.animate(withDuration: TimeInterval(animtionDuration / 2), animations: {
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 900.0
            transform = CATransform3DScale(transform, 1, 1, 1)
            transform = CATransform3DRotate(transform, CGFloat(12 * Double.pi / 180.0), 1, 0, 0)
            viewController.view.layer.transform = transform
        }) { isCompleted in
            endRotateSecondAnimation(viewController)
        }
    }
    
    
    private class func startRotateSecondAnimation(_ viewController: UIViewController) {
        
        UIView.animate(withDuration: TimeInterval(animtionDuration / 2), animations: {
            viewController.view.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1)
        })
    }
    
    private class func endRotateSecondAnimation(_ viewController: UIViewController) {
        
        UIView.animate(withDuration: TimeInterval(animtionDuration / 2), animations: {
            viewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
}
