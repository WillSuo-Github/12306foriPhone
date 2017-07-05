//
//  WSTrainSeatAlert.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainSeatAlert: UIView {
    
//MARK:- private property
    let tableView: UITableView = UITableView()
    let coverView: UIView = UIView()
    let tableViewHeight: CGFloat = 300.0
    var sourceDic: [String: SeatTypePair]!
    weak var onConotrller: UIViewController?

//MARK:- life cycle
    public class func showSeatAlert(_ onController: UIViewController, _ sourceDic: [String: SeatTypePair]) {
        
        WSRotationScaleAnimation.showAnimation(onController, 1)
        
        let alertView = WSTrainSeatAlert(frame: WSConfig.keywindow.bounds)
        alertView.onConotrller = onController
        alertView.sourceDic = sourceDic 
        WSConfig.keywindow.addSubview(alertView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//MARK:- layout
    private func configSubviews() {
        
        configCoverView()
        configTableView()
    }
    
    private func configTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = CGRect(x: 0, y: WSConfig.keywindow.height, width: WSConfig.keywindow.width, height: tableViewHeight)
        tableView.register(UINib(nibName: "WSTrainSeatCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        UIView.animate(withDuration: 0.5) { 
            self.tableView.frame = CGRect(x: 0, y: WSConfig.keywindow.height - self.tableViewHeight, width: WSConfig.keywindow.width, height: self.tableViewHeight)
        }
    }
    
    private func configCoverView() {
        
        coverView.frame = WSConfig.keywindow.bounds
        coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewDidChick))
        coverView.addGestureRecognizer(tap)
        self.addSubview(coverView)
        
        UIView.animate(withDuration: 0.5) { 
            self.coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
    }
    
    private func hideCoverView() {
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { _ in
            self.coverView.removeFromSuperview()
        }
    }
    
    private func hideTableView() {
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.tableView.frame = CGRect(x: 0, y: WSConfig.keywindow.height, width: WSConfig.keywindow.width, height: self.tableViewHeight)
        }) { _ in
            self.tableView.removeFromSuperview()
        }
    }
    
    
    
    fileprivate func hideAllView() {
        hideCoverView()
        hideTableView()
        
        if let controller = onConotrller {
            WSRotationScaleAnimation.hideAnimation(controller)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) { 
            self.removeFromSuperview()
        }
    }
    
//MARK:- tapped response
    func coverViewDidChick() {
        hideAllView()
    }
}

extension WSTrainSeatAlert: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceDic.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WSTrainSeatCell
        
        let allValues = [SeatTypePair](sourceDic.values)
        cell.seatInfo = allValues[indexPath.row]
        return cell
    }
}
