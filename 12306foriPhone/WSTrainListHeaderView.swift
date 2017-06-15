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

protocol WSTrainListHeaderViewDelegate: class {
    func WSTrainListHeaderViewDidChickRefresh(headerView: WSTrainListHeaderView)
}

class WSTrainListHeaderView: UIView {
    
    public var headerData: WSTrainListHeaderData? {
        didSet {
            fromName.setTitle(headerData!.fromStation.Name, for: .normal)
            toName.setTitle(headerData!.toStation.Name, for: .normal)
            departureDate.setTitle(transformDepartureDate(headerData!.departureDate), for: .normal)
        }
    }
    
    public weak var delegate: WSTrainListHeaderViewDelegate?

    @IBOutlet weak var fromName: UIButton!
    @IBOutlet weak var toName: UIButton!
    @IBOutlet weak var departureDate: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    private var xibView: UIView?
    private var gradientLayer = CAGradientLayer()
    
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
        
        configXibView()
        configBottomView()
        configSearchButton()
        
    }
    
    private func configXibView() {
        xibView = loadViewFromNib()
        if let v = xibView {
            v.frame = self.frame
            self.addSubview(v)
        }
    }
    
    private func configBottomView() {
        
        gradientLayer.colors = [UIColor(hexString: "eeeeee")!.cgColor, UIColor(hexString: "f6fcfe")!.cgColor]
        gradientLayer.locations = [0.1, 0.4]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        bottomView.layer.addSublayer(gradientLayer)
    }
    
    private func configSearchButton() {
        refreshButton.layer.cornerRadius = 2
        refreshButton.layer.masksToBounds = true
    }
    
    private func loadViewFromNib() -> UIView{
        return Bundle.main.loadNibNamed("WSTrainListHeaderView", owner: self, options: nil)?.first as! UIView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        xibView?.frame = self.frame
        gradientLayer.frame = bottomView.bounds
    }
    
//MARK:- tapped response
    
    @IBAction func theDayBeforeDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func theDayAfterDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func refreshButtonDidTapped(_ sender: Any) {
        if let delegate = delegate {
            delegate.WSTrainListHeaderViewDidChickRefresh(headerView: self)
        }
    }
    
//MARK:- other 
    private func transformDepartureDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
