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
        startReduceHeightAnimation(imageView)
        
    }
    
    private class func startCycleViewAnimation(_ cycleView: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 3.0
        animation.duration = 0.5
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        cycleView.layer.add(animation, forKey: "scaleAnimation")
    }
    
    private class func startReduceHeightAnimation(_ imageView: UIImageView) {
        let coverView = UIView(frame: CGRect(x: 0, y: imageView.height, width: imageView.width, height: 0))
        coverView.backgroundColor = UIColor(hexString: "F0575F")
        imageView.addSubview(coverView)
        
        UIView.animate(withDuration: 0.5) { 
            
        }
        
        UIView.animate(withDuration: 0.5, animations: { 
            imageView.center = WSConfig.keywindow.center
            coverView.frame = CGRect(x: 0, y: imageView.height - 70, width: imageView.height, height: 70)
        }) { isCompleted in
            
            startTipsAnimation(coverView)
        }
    }
    
    private class func startTipsAnimation(_ coverView: UIView) {
        let tipsLabel = UILabel()
        tipsLabel.text = "即将开始抢票..."
        tipsLabel.textColor = .white
        tipsLabel.font = UIFont.systemFont(ofSize: 13)
        tipsLabel.alpha = 0.0
        coverView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
         startFlickerAnimation(tipsLabel)
    }
    
    private class func startFlickerAnimation(_ view: UIView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = view.alpha == 0 ? 0.7: 0.0
        }) { isCompleted in
            startFlickerAnimation(view)
        }
    }
}
