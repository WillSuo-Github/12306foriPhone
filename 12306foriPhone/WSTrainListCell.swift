//
//  WSTrainListCell.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/12.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainListCell: UITableViewCell {
    
    public var ticketInfo: WSQueryLeftNewDTO! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var trainNameLabel: UILabel!
    @IBOutlet weak var addressStationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ticketsLeftLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    
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
    
    private func updateUI() {
    
        trainNameLabel.text = ticketInfo.TrainCode!
        timeLabel.text = "\(ticketInfo.start_time!) - \(ticketInfo.arrive_time!)"
        ticketsLeftLabel.text = getSeatStates(ticketInfo)
        addressStationLabel.text = "\(ticketInfo.FromStationName!) - \(ticketInfo.ToStationName!)"
        detailView.isHidden = !ticketInfo.isShowDetail 
        
    }
    
    private func getSeatStates(_ ticket: WSQueryLeftNewDTO) -> String {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(ticket.classForCoder, &count)
        for i in 0..<count {
            let property = properties![Int(i)]
            let key = NSString(cString: property_getName(property), encoding: String.Encoding.utf8.rawValue)!
            if key.contains("Num") {
                let value = ticket.value(forKey: key as String) as! String
                
                if value != "" {
                    if value == "有" || (value != "无" && Int(value)! > 0){
                        ticketsLeftLabel.textColor = UIColor(hexString: "f7999e")
                        return "有票"
                    }
                }
            }
        }
        ticketsLeftLabel.textColor = UIColor(hexString: "AAAABC")
        return "无票"
    }
    
//MARK:- tapped response
    @IBAction func buyButtonDidTapped(_ sender: Any) {
        
    }
    
}
