//
//  WSTrainPersonAlert.swift
//  12306foriPhone
//
//  Created by WS on 2017/7/6.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainPersonAlert: NSObject {

    //MARK:- private property
    let tableView: UITableView = UITableView()
    var sourceArr: [WSPassengerDTO]!
    var selectBlock: ((WSPassengerDTO) -> Void)?
    var tableViewHeight: CGFloat = 300.0
    weak var onConotrller: UIViewController?
    var alertView: WSBottomSelectAlert?
    
    static var personAlert: WSTrainPersonAlert?
    
    //MARK:- life cycle
    public class func showPersonAler(_ onController: UIViewController, _ sourceArr: [WSPassengerDTO], _ selectBlock: @escaping (WSPassengerDTO) -> Void){
        
        WSRotationScaleAnimation.showAnimation(onController, 1)
        personAlert = WSTrainPersonAlert(onController, sourceArr, selectBlock)
    }
    
    @discardableResult init(_ onController: UIViewController, _ sourceArr: [WSPassengerDTO], _ selectBlock: @escaping (WSPassengerDTO) -> Void) {
        super.init()
        
        self.onConotrller = onController
        self.sourceArr = sourceArr
        self.selectBlock = selectBlock
        configSubviews()
    }
    
    //MARK:- layout
    
    private func configSubviews() {
        
        configTableView()
    }
    
    private func configTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "WSTrainPersonCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        if sourceArr.count * 44 < 300 {
            tableViewHeight = CGFloat(sourceArr.count) * 44.0
        }
        self.alertView = WSBottomSelectAlert.showBottomAlert(self.onConotrller, self.tableView, self.tableViewHeight)
    }
    
}

extension WSTrainPersonAlert: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WSTrainPersonCell
    
        cell.passenger = sourceArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = selectBlock {
            block(sourceArr[indexPath.row])
        }
        
        if let alert = alertView {
            alert.hideAllView()
        }
    }
}
