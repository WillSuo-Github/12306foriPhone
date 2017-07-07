
//
//  WSTrainPersonCell.swift
//  12306foriPhone
//
//  Created by WS on 2017/7/7.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainPersonCell: UITableViewCell {
    
    var passenger: WSPassengerDTO? {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var personNameLabel: UILabel!

//MARK:- layout
    private func updateUI() {
        personNameLabel.text = passenger?.passenger_name
    }
}
