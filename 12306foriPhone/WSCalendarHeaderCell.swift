//
//  WSCalendarHeaderCell.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/24.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSCalendarHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var titleText: String? {
        didSet {
            monthLabel.text = titleText
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
