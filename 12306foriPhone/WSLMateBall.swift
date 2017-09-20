//
//  WSLMateBall.swift
//  WSLMateBall
//
//  Created by WS on 2017/7/27.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit
struct WSLCustomConfig {
    var smallWH: CGFloat = 8.0
    var smallColor: UIColor = .purple
    var mainBallColor: UIColor = .red
}

private let sharedInstance = WSLMateBall()
class WSLMateBall: UIView {
    public class var shared: WSLMateBall {
        return sharedInstance
    }
    
    public class func showBall(_ customConfig: WSLCustomConfig = WSLCustomConfig()) {
        
        sharedInstance.config = customConfig
        WSConfig.keywindow.addSubview(sharedInstance)
        sharedInstance.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-150)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(ballWH)
        }
    }
    
//MARK:- private property
    private static let ballWH: CGFloat = 40.0
    private var mainBall: CAShapeLayer = CAShapeLayer()
    private var smallBalls: [UIView] = [UIView]()
    private var config: WSLCustomConfig!
    
    var displayLink: CADisplayLink?
    
//MARK:- cycle life
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- layout
    override func layoutSubviews() {
        super.layoutSubviews()
        mainBall.path = getMainNoramlPath()
    }
    
    private func configSubviews() {
        mainBall.path = getMainNoramlPath()
        mainBall.fillColor = config.mainBallColor.cgColor
        self.layer.addSublayer(mainBall)
    }
    
    private func addSmallBall() -> (UIView, UIView) {
        let view = UIView()
        let layerWH: CGFloat = config.smallWH
        view.frame = CGRect(x: self.bounds.size.width / 2 - layerWH / 2, y: self.bounds.size.height / 2 - layerWH / 2, width: layerWH, height: layerWH)
        view.backgroundColor = config.smallColor
        view.layer.cornerRadius = layerWH / 2
        view.layer.masksToBounds = true
        let superView = UIView()
        self.insertSubview(superView, at: 0)
        superView.frame = self.bounds
        superView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.addSubview(superView)
        superView.addSubview(view)
        smallBalls.append(view)
        return (superView, view)
    }
    
    private func getMainNoramlPath() -> CGPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2), radius: self.bounds.size.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
    }
    
    private func getMainLargePath() -> CGPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2), radius: self.bounds.size.width / 2 + 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
    }
    
//MARK:- action response
    @objc private func displayAction(_ disp: CADisplayLink) {
        if let layer = smallBalls.last {
            print(layer.frame)
        }
    }

//MARK:- start bubble
    public func addBubble() {
        animationLarger()
    }
    
    public func reduceBubble() {
        smallBalls.last?.removeFromSuperview()
        smallBalls.removeLast()
    }
    
    private func animationLarger() {
        let duration: TimeInterval = 0.1
        mainBallDoAnimation(duration: duration, fromPath: getMainNoramlPath(), toPath: getMainLargePath())
        
        delay(duration) {
            self.animationSmall()
        }
    }
    
    private func animationSmall() {
        let duration: TimeInterval = 0.2
        mainBallDoAnimation(duration: duration, fromPath: nil, toPath: getMainNoramlPath())
        
        delay(duration) { 
            self.animationSmallBall()
        }
    }
    
    private func animationSmallBall() {
        let (superView, smallBall) = addSmallBall()

        let duration = 1.0
        
        UIView.animate(withDuration: duration, animations: { 
            smallBall.transform = CGAffineTransform(translationX: 0, y: -self.bounds.size.height / 2 - 6)
        }) { (isComplete) in
            self.animationRotation(superView)
        }
    }
    
    private func animationRotation(_ view: UIView) {
        let rotateTimeFunction = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        
        var rotateValues = [NSNumber(value: 0)]
        let value = rotateValues.last!.floatValue + Float.pi * 2
        rotateValues.append(NSNumber(value: value))

        let rotateAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnim.keyTimes = [0.0, 1.0]
        rotateAnim.duration = 1
        rotateAnim.repeatCount = HUGE;
        rotateAnim.isRemovedOnCompletion = false;
        rotateAnim.fillMode = kCAFillModeForwards;
        rotateAnim.values = rotateValues
        rotateAnim.timingFunctions = rotateTimeFunction
        
        view.layer.add(rotateAnim, forKey: "rotate")
    }
    
    
    private func mainBallDoAnimation(duration: TimeInterval, fromPath: CGPath?, toPath: CGPath) {
        let animation = CASpringAnimation(keyPath: "path")
        if let from = fromPath {
            animation.fromValue = from
        }
        animation.toValue = toPath
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        mainBall.add(animation, forKey: "animation")
    }
    
//MARK:- other 
    private func delay(_ time: TimeInterval, execute:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { 
            execute()
        }
    }
}

