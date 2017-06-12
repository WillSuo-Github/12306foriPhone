//
//  WSTrainListCell.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/12.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainListCell: UITableViewCell {
    
    @IBOutlet weak var trainNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ticketsLeftLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
  
//MARK:- life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configSubviews()
    }

//MARK:- layout
    private func configSubviews() {
        buyButton.layer.cornerRadius = 15
        buyButton.layer.masksToBounds = true
    }
    
//MARK:- tapped response
    @IBAction func buyButtonDidTapped(_ sender: Any) {
        
    }
    
}
