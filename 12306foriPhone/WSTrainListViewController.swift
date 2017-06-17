//
//  WSTrainListViewController.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/12.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSTrainListViewController: UIViewController {
    
    public var headerData: WSTrainListHeaderData? {
        didSet {
            tableHeaderView.headerData = self.headerData
        }
    }
    
    private var ticketType: WSTicketType = .Normal
    fileprivate var ticketQueryResult = [WSQueryLeftNewDTO]()
    private var tableView: UITableView?
    fileprivate var tableHeaderView: WSTrainListHeaderView = WSTrainListHeaderView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 200.0))

//MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        requestTrainList()
    }

//MARK:- layout
    private func configTableView() {
        
        tableView = UITableView(frame: self.view.bounds)
        view.addSubview(tableView!)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: "WSTrainListCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor(hexString: "f6fcfe")
        tableView?.tableHeaderView = tableHeaderView
        tableView?.tableFooterView = UIView()
        tableView?.separatorStyle = .none
        
        tableHeaderView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView?.frame = view.frame
    }
    
    fileprivate func refreshData() {
        requestTrainList()
    }
    
    fileprivate func reloadCellWith(_ indexPathes: [IndexPath]) {
        for indexPath in indexPathes {
            tableView?.reloadRow(at: indexPath, with: .bottom)
        }
    }

//MARK:- network
    private func requestTrainList() {
        
        if let headerData = headerData {
            
            self.tableView?.showLoading()
            
            let fromStationCode = WSStationNameJs.sharedInstance.allStationMap[headerData.fromStation.Name]!.Code
            let toStationCode = WSStationNameJs.sharedInstance.allStationMap[headerData.toStation.Name]!.Code
            
            let successHanlder = { (tickets:[WSQueryLeftNewDTO]) in
                
                self.tableView?.hideHub()
                self.ticketQueryResult = tickets
                self.tableView?.reloadData()
            }
            let failureHanlder = { (error: Error) in
                self.tableView?.showMessage("网络请求失败")
                print(error)
            }
            
            var params = WSLeftTicketParam()
            params.from_stationCode = fromStationCode
            params.to_stationCode = toStationCode
            params.train_date = headerData.departureDate.getDateString("yyyy-MM-dd")
            params.purpose_codes = ticketType.rawValue
            WSService.shardInstance.queryTicketFlowWith(params, success: successHanlder, failure: failureHanlder)
        }
    }
}

extension WSTrainListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketQueryResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WSTrainListCell
        cell.ticketInfo = ticketQueryResult[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ticketQueryResult[indexPath.row].isShowDetail {
            return 550
        }else {
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        var index: Int?
        for (i, result) in ticketQueryResult.enumerated() {
            if i == indexPath.row { continue }
            if result.isShowDetail {
                result.isShowDetail = false
                index = i
            }
        }
        
        ticketQueryResult[indexPath.row].isShowDetail = !ticketQueryResult[indexPath.row].isShowDetail
        var tmpIndexPath: IndexPath?
        if let index = index {
            tmpIndexPath = IndexPath(item: index, section: indexPath.section)
        }
        
        if let tmpIndexPath = tmpIndexPath {
            reloadCellWith([tmpIndexPath, indexPath])
        }else {
            reloadCellWith([indexPath])
        }
    }

}

extension WSTrainListViewController: WSTrainListHeaderViewDelegate {
    func WSTrainListHeaderViewDidChickRefresh(headerView: WSTrainListHeaderView) {
        refreshData()
    }
}
