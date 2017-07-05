//
//  WSTrainSeatCell.swift
//  12306foriPhone
//
//  Created by WS on 2017/7/5.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainSeatCell: UITableViewCell {

    var seatInfo: SeatTypePair? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var seatNameLabel: UILabel!
    @IBOutlet weak var seatNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    private func updateUI() {
        seatNameLabel.text = seatInfo?.seatName
        if seatInfo!.hasTicket {
            seatNumLabel.text = "有票"
            seatNumLabel.textColor = UIColor(hexString: "333333")
        }else{
            seatNumLabel.text = "无票"
            seatNumLabel.textColor = UIColor(hexString: "666666")
        }
    }
    
}
