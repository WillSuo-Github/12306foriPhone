//
//  WSPassCoverView.swift
//  cutImage
//
//  Created by ws on 2016/10/26.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

class WSPassCoverView: UIView {
    
    var touchBlock: ()->()?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .clear
        layer.cornerRadius = 2
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2
        layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(WSPassCoverView.didTouchSelf))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didTouchSelf() {
        removeFromSuperview()
        touchBlock()
        
    }
}
