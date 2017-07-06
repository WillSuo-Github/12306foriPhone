//
//  WSBottomSelectAlert.swift
//  12306foriPhone
//
//  Created by WS on 2017/7/6.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSBottomSelectAlert: UIView {
//MARK:- private property
    let coverView: UIView = UIView()
    let bottomView: UIView = UIView()
    var bottomHeight: CGFloat = 0.0
    var bottomSubView: UIView!
    weak var onConotrller: UIViewController?
    
//MARK:- life cycle
    public class func showBottomAlert(_ onController: UIViewController!,_ bottomSubView: UIView! , _ bottomHeight: CGFloat!) -> WSBottomSelectAlert {
        
        WSRotationScaleAnimation.showAnimation(onController, 1)
        
        let alertView = WSBottomSelectAlert(frame:WSConfig.keywindow.bounds, onController, bottomSubView, bottomHeight)
        WSConfig.keywindow.addSubview(alertView)
        
        return alertView
    }
    
    init(frame: CGRect,_ onController: UIViewController!,_ bottomSubView: UIView! , _ bottomHeight: CGFloat!) {
        super.init(frame: frame)
        
        self.onConotrller = onController
        self.bottomHeight = bottomHeight
        self.bottomSubView = bottomSubView
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//MARK:- layout
    private func configSubviews() {
        
        configCoverView()
        configBottomView()
    }
    
    private func configBottomView() {
        
        
        bottomView.frame = CGRect(x: 0, y: WSConfig.keywindow.height - 300, width: WSConfig.keywindow.width, height: bottomHeight)
        self.addSubview(bottomView)
        
        bottomSubView.frame = bottomView.bounds
        bottomView.addSubview(bottomSubView)
        
//        if bottomSubView.is {
//            <#code#>
//        }
        
        UIView.animate(withDuration: 0.5) {
            self.bottomView.frame = CGRect(x: 0, y: WSConfig.keywindow.height - self.bottomHeight, width: WSConfig.keywindow.width, height: self.bottomHeight)
        }
    }
    
    private func configCoverView() {
        
        coverView.frame = WSConfig.keywindow.bounds
        coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewDidChick))
        coverView.addGestureRecognizer(tap)
        self.addSubview(coverView)
        
        UIView.animate(withDuration: 0.5) {
            self.coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
    }
    
    private func hideCoverView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { _ in
            self.coverView.removeFromSuperview()
        }
    }
    
    private func hideTableView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame = CGRect(x: 0, y: WSConfig.keywindow.height, width: WSConfig.keywindow.width, height: self.bottomHeight)
        }) { _ in
            self.bottomView.removeFromSuperview()
        }
    }
    
    
    
    func hideAllView() {
        hideCoverView()
        hideTableView()
        
        if let controller = onConotrller {
            WSRotationScaleAnimation.hideAnimation(controller)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.removeFromSuperview()
        }
    }
    
//MARK:- tapped response
    func coverViewDidChick() {
        hideAllView()
    }

}
