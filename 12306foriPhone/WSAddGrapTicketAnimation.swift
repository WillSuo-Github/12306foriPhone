//
//  WSAddGrapTicketAnimation.swift
//  12306foriPhone
//
//  Created by WS on 2017/7/14.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSAddGrapTicketAnimation {

    public class func startAddGrapAnimationInViewSnap(_ viewSnap: UIImage, _ fromFrame: CGRect) {
        print(fromFrame)
        
        configSubViews(viewSnap, fromFrame)
        
    }
    
    private class func configSubViews(_ viewSnap: UIImage, _ fromFrame: CGRect) {
        
        let imageView = UIImageView(image: viewSnap)
        imageView.frame = fromFrame
        WSConfig.keywindow.addSubview(imageView)
        
        let cycleView = UIView()
        cycleView.height = fromFrame.width
        cycleView.width = fromFrame.width
        cycleView.center = CGPoint(x: fromFrame.midX, y: fromFrame.midY)
        cycleView.layer.cornerRadius = fromFrame.width / 2
        cycleView.layer.masksToBounds = true
        cycleView.layer.backgroundColor = UIColor(hexString: "F0575F")?.cgColor
        WSConfig.keywindow.insertSubview(cycleView, belowSubview: imageView)
        
        startCycleViewAnimation(cycleView)
    }
    
    private class func startCycleViewAnimation(_ cycleView: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 5.0
        animation.duration = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        cycleView.layer.add(animation, forKey: "scaleAnimation")
    }
    
    
}
