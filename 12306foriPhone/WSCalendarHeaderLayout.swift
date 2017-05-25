//
//  WSCalendarHeaderLayout.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/25.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSCalendarHeaderLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        minimumLineSpacing = 0
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex: Int = Int(proposedContentOffset.x / itemSize.width)
        return CGPoint(x: (CGFloat(itemIndex) + 0.5) * itemSize.width, y: proposedContentOffset.y)
    }
}
