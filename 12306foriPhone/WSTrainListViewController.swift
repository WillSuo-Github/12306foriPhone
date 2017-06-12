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
    
    private var tableView: UITableView?
    fileprivate var tableHeaderView: WSTrainListHeaderView = WSTrainListHeaderView(frame: CGRect.zero)

//MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
    }

//MARK:- layout
    private func configTableView() {
        tableView = UITableView(frame: self.view.bounds)
        view.addSubview(tableView!)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: "WSTrainListCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor(hexString: "f6fcfe")
        tableView?.allowsSelection = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView?.frame = view.frame
    }
}

extension WSTrainListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

}
