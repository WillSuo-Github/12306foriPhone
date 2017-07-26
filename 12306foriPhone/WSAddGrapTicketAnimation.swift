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
    private let viewSnap: UIImage!
    private let fromFrame: CGRect!
    
    private var imageView: UIImageView!
    private var cycleView: UIView!
    private var tipsLabel: UILabel!
    private var coverView: UIView!
    private var smallBallView: UIImageView!
    private let animator = UIDynamicAnimator(referenceView: WSConfig.keywindow)
    
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
        animation.toValue = 5
        animation.duration = 0.5
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        cycleView.layer.add(animation, forKey: "scaleAnimation")
    }
    
    private func startReduceHeightAnimation(_ imageView: UIImageView) {
        coverView = UIView(frame: CGRect(x: 0, y: imageView.height, width: imageView.width, height: 0))
        coverView.backgroundColor = UIColor(hexString: "F0575F")
        imageView.addSubview(coverView)
        
        UIView.animate(withDuration: 0.5, animations: { 
            imageView.center = WSConfig.keywindow.center
            self.coverView.frame = CGRect(x: 0, y: imageView.height - 70, width: imageView.height, height: 70)
        }) { isCompleted in
            
            self.startTipsAnimation(self.coverView)
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
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
        let cycleWH: CGFloat = 10.0
        let cycleCenterWH: CGFloat = 1.5;
        let duration: TimeInterval =  0.5

//        coverView.removeFromSuperview()
    
        let animationGroup = CAAnimationGroup()
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 3
        scaleAnimation.toValue = 0.01
        scaleAnimation.duration = duration
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.toValue = NSValue(cgPoint: WSConfig.keywindow.center)
        positionAnimation.duration = duration
        
        animationGroup.duration = duration
        animationGroup.animations = [scaleAnimation, positionAnimation]
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        cycleView.layer.add(animationGroup, forKey: "animationGroup")
        
        UIView.animate(withDuration: duration) {
            self.imageView.width = cycleCenterWH
            self.imageView.height = cycleCenterWH
            self.imageView.center = WSConfig.keywindow.center
            self.imageView.layer.cornerRadius = cycleCenterWH / 2
            self.imageView.layer.masksToBounds = true;
        }
        
        smallBallView = UIImageView(image: UIImage(named: "smallBall"))
        smallBallView.width = 0
        smallBallView.height = 0
        smallBallView.center = WSConfig.keywindow.center
        WSConfig.keywindow.insertSubview(smallBallView, belowSubview: WSBallView.shared)
        
        UIView.animate(withDuration: 0.2, delay: duration, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            self.smallBallView.width = cycleWH
            self.smallBallView.height = cycleWH
            self.smallBallView.center = WSConfig.keywindow.center
        }) { isCompleted in
            self.imageView.removeFromSuperview()
            self.cycleView.removeFromSuperview()
            self.tipsLabel.removeFromSuperview()
            self.coverView.removeFromSuperview()
            
            self.startGetIntoBall()
        }
    }
    
    private func startGetIntoBall() {

        let gravity = UIGravityBehavior(items: [smallBallView])
        animator.addBehavior(gravity)
        
        let duration: CFTimeInterval = CFTimeInterval(sqrt((WSBallView.shared.centerY - smallBallView.centerY) * 2.0 / 1000))
        
        let horizontalAnimation = CABasicAnimation(keyPath: "position.x")
        horizontalAnimation.toValue = WSBallView.shared.centerX
        horizontalAnimation.fillMode = kCAFillModeForwards
        horizontalAnimation.isRemovedOnCompletion = false
        horizontalAnimation.duration = duration
        smallBallView.layer.add(horizontalAnimation, forKey: "horizontalAnimation")
    }
}

