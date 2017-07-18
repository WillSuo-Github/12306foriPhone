//
//  WSAddGrapTicketAnimation.swift
//  12306foriPhone
//
//  Created by WS on 2017/7/14.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSAddGrapTicketAnimation: NSObject {

    public class func startAddGrapAnimationInViewSnap(_ viewSnap: UIImage, _ fromFrame: CGRect) {
        
        _ = WSAddGrapTicketAnimation(viewSnap, fromFrame)
    }
//MARK:- private property
    let viewSnap: UIImage!
    let fromFrame: CGRect!
    
    var imageView: UIImageView!
    var cycleView: UIView!
    var tipsLabel: UILabel!
    
//MARK:- life cycle
    init(_ viewSnap: UIImage, _ fromFrame: CGRect) {
        self.viewSnap = viewSnap
        self.fromFrame = fromFrame
        super.init()
        configSubViews()
    }
 
//MARK:- layout
    private func configSubViews() {
        
        imageView = UIImageView(image: viewSnap)
        imageView.frame = fromFrame
        WSConfig.keywindow.addSubview(imageView)
        
        cycleView = UIView()
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
    
//MARK:- animations
    private func startCycleViewAnimation(_ cycleView: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 3.0
        animation.duration = 0.5
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        cycleView.layer.add(animation, forKey: "scaleAnimation")
    }
    
    private func startReduceHeightAnimation(_ imageView: UIImageView) {
        let coverView = UIView(frame: CGRect(x: 0, y: imageView.height, width: imageView.width, height: 0))
        coverView.backgroundColor = UIColor(hexString: "F0575F")
        imageView.addSubview(coverView)
        
        UIView.animate(withDuration: 0.5) { 
            
        }
        
        UIView.animate(withDuration: 0.5, animations: { 
            imageView.center = WSConfig.keywindow.center
            coverView.frame = CGRect(x: 0, y: imageView.height - 70, width: imageView.height, height: 70)
        }) { isCompleted in
            
            self.startTipsAnimation(coverView)
        }
    }
    
    private func startTipsAnimation(_ coverView: UIView) {
        tipsLabel = UILabel()
        tipsLabel.text = "即将开始抢票..."
        tipsLabel.textColor = .white
        tipsLabel.font = UIFont.systemFont(ofSize: 13)
        tipsLabel.alpha = 0.0
        coverView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        startFlickerAnimation(tipsLabel)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.startReduceAnimation()
        }
    }
    
    private func startFlickerAnimation(_ view: UIView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = view.alpha == 0 ? 0.7: 0.0
        }) { isCompleted in
            self.startFlickerAnimation(view)
        }
    }
    
    private func startReduceAnimation() {
        let cycleWH: CGFloat = 5.0
        
        imageView.removeFromSuperview()
        UIView.animate(withDuration: 0.5) { 
            self.cycleView.width = cycleWH
            self.cycleView.height = cycleWH
            self.cycleView.center = WSConfig.keywindow.center
            self.cycleView.layer.cornerRadius = cycleWH / 2
        }
    }
}
