//
//  WSTrainSeatAlert.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainSeatAlert: NSObject {
    
//MARK:- private property
    let tableView: UITableView = UITableView()
    var sourceDic: [String: SeatTypePair]!
    var selectBlock: ((SeatTypePair) -> Void)?
    let tableViewHeight: CGFloat = 300.0
    weak var onConotrller: UIViewController?
    var alertView: WSBottomSelectAlert?
    

//MARK:- life cycle
    public class func showSeatAlert(_ onController: UIViewController, _ sourceDic: [String: SeatTypePair], _ selectBlock: @escaping (SeatTypePair) -> Void) {
        
        WSRotationScaleAnimation.showAnimation(onController, 1)
        WSTrainSeatAlert(onController, sourceDic, selectBlock)
    }
    
    @discardableResult init(_ onController: UIViewController, _ sourceDic: [String: SeatTypePair], _ selectBlock: @escaping (SeatTypePair) -> Void) {
        super.init()
        
        self.onConotrller = onController
        self.sourceDic = sourceDic
        self.selectBlock = selectBlock
        configSubviews()
    }
    
//MARK:- layout
    private func configSubviews() {
    
        configTableView()
    }
    
    private func configTableView() {
        
        alertView = WSBottomSelectAlert.showBottomAlert(onConotrller, tableView, tableViewHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "WSTrainSeatCell", bundle: nil), forCellReuseIdentifier: "cell")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allValues = [SeatTypePair](sourceDic.values)
        if let block = selectBlock {
            block(allValues[indexPath.row])
        }
        if let alert = alertView {
            alert.hideAllView()
        }
    }
}
