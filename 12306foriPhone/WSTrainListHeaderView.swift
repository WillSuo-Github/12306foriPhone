//
//  WSTrainListHeaderView.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/12.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

struct WSTrainListHeaderData {
    var fromStation: WSStation
    var toStation: WSStation
    var departureDate: Date
}

class WSTrainListHeaderView: UIView {
    
    public var headerData: WSTrainListHeaderData? {
        didSet {
            fromName.setTitle(headerData!.fromStation.Name, for: .normal)
            toName.setTitle(headerData!.toStation.Name, for: .normal)
            departureDate.setTitle(transformDepartureDate(headerData!.departureDate), for: .normal)
        }
    }

    @IBOutlet weak var fromName: UIButton!
    @IBOutlet weak var toName: UIButton!
    @IBOutlet weak var departureDate: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    private var xibView: UIView?
    
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
        
        xibView = loadViewFromNib()
        if let v = xibView {
            v.frame = self.frame
            self.addSubview(v)
        }
        
        searchButton.layer.cornerRadius = 2
        searchButton.layer.masksToBounds = true
    }
    
    private func loadViewFromNib() -> UIView{
        return Bundle.main.loadNibNamed("WSTrainListHeaderView", owner: self, options: nil)?.first as! UIView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        xibView?.frame = self.frame
    }
    
//MARK:- tapped response
    
    @IBAction func theDayBeforeDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func theDayAfterDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func searchButtonDidTapped(_ sender: Any) {
        
    }
    
//MARK:- other 
    private func transformDepartureDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
