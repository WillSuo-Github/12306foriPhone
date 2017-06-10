//
//  WSCalendarCollectionCell.swift
//  WSCalendarDemo
//
//  Created by WS on 2017/5/31.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit


protocol WSCalendarItemDelegate: class {
    func calendarItemDidTapped(_ calendarItem: WSCalendarItem, viewId: String)
}

class WSCalendarItem: UIView {
    
    public var selectArr: [WSCalendarItem]?
    
    public var calendarDate: WSCalendarDate! {
        didSet {
            
            let timeStr = calendarDate.dateString as NSString
            titleButton.setTitle(timeStr.substring(from: 6), for: .normal)
            
            configTitleButton()
        }
    }
    
    open weak var itemDelegate: WSCalendarItemDelegate?

    private var titleButton: UIButton!
    private var isDefaultSelet: Bool = false
    
//MARK:- life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK:- layout
    private func configSubviews() {
        titleButton = UIButton(frame: self.bounds)
        titleButton.addTarget(self, action: #selector(titleButtonDidTapped(sender:)), for: .touchUpInside)
        titleButton.ws_setBackgroundColor(WSCalendarConfig.itemBackgroundColor, for: .highlighted)
        self.addSubview(titleButton)
        self.backgroundColor = WSCalendarConfig.itemBackgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleButton.frame = self.bounds
    }
    
    private func configTitleButton() {
        switch calendarDate.selectState {
        case .defaultSelect:
            isDefaultSelet = true
            titleButton.setTitleColor(WSCalendarConfig.itemDefaultSelectTextColor, for: .normal)
            titleButton.ws_setBackgroundColor(WSCalendarConfig.itemDefaultSelectBgColor, for: .normal)
        case .normal:
            changeToNormal()
        case .selected:
            changeToSelect()
        case .unSelect:
            changeToUnSelect()
        case .unSelectable:
            titleButton.setTitleColor(WSCalendarConfig.itemUnSelectableTextColor, for: .normal)
            titleButton.ws_setBackgroundColor(WSCalendarConfig.itemBackgroundColor, for: .normal)
        }
        
    }
    
    private func changeToSelect() {
        titleButton.ws_setBackgroundColor(WSCalendarConfig.itemSelectBgColor, for: .normal)
        titleButton.setTitleColor(WSCalendarConfig.itemSelectTextColor, for: .normal)
    }
    
    private func changeToUnSelect() {
        titleButton.ws_setBackgroundColor(WSCalendarConfig.itemBackgroundColor, for: .normal)
        titleButton.setTitleColor(WSCalendarConfig.itemNomalTextColor, for: .normal)
    }
    
    private func changeToNormal() {
        if isDefaultSelet {
            titleButton.ws_setBackgroundColor(WSCalendarConfig.itemDefaultSelectBgColor, for: .normal)
            titleButton.setTitleColor(WSCalendarConfig.itemDefaultSelectTextColor, for: .normal)
        }else {
            titleButton.setTitleColor(WSCalendarConfig.itemNomalTextColor, for: .normal)
            titleButton.ws_setBackgroundColor(WSCalendarConfig.itemBackgroundColor, for: .normal)
        }
    }
    
//MARK:- tapped response
    @objc private func titleButtonDidTapped(sender: UIButton) {
        if calendarDate.selectState == .unSelectable { return }
        
        calendarDate.selectState = .selected
        if let delegate = itemDelegate {
            delegate.calendarItemDidTapped(self, viewId: self.restorationIdentifier!)
        }
    }
    
}

extension UIButton {
    fileprivate func ws_setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        self.setBackgroundImage(ws_getImage(color), for: state)
    }
    
    private func ws_getImage(_ color: UIColor) -> UIImage {
        
        let rect = self.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.addArc(center: self.center, radius: self.bounds.size.width / 2 - 3, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: false)
        context?.fillPath()
        draw(self.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
