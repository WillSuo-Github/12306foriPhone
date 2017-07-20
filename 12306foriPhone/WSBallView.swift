//
//  WSBallView.swift
//  12306foriPhone
//
//  Created by WS on 2017/7/12.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit


private let sharedInstance = WSBallView()
class WSBallView: UIView {
    
    private static let ballWH: CGFloat = 40.0
    public class var shared: WSBallView {
        return sharedInstance;
    }
    
    public class func showBall() {
    
        WSConfig.keywindow.addSubview(sharedInstance)
        sharedInstance.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-150)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(ballWH)
        }
    }
    
//MARK:- life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- layout
    private func configSubViews() {

        configCycleButton()
    }
    
    private func configCycleButton() {
        let cycleButton = UIButton(type: .custom)
        self.addSubview(cycleButton)
        let cycleButtonWH = WSBallView.ballWH / 4.0 * 3.0
        cycleButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(cycleButtonWH)
        }
        cycleButton.backgroundColor = UIColor(hexString: "F0575F")
        cycleButton.layer.cornerRadius = cycleButtonWH / 2
        cycleButton.layer.shadowOpacity = 0.3;
        cycleButton.layer.shadowColor = cycleButton.backgroundColor?.cgColor
        cycleButton.layer.shadowOffset = CGSize(width: 0, height: 0);
        layer.masksToBounds = true
    }
}
