//
//  WSSearchStationController.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/23.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSSearchStationController: UIViewController {
    
    var selectBlock: ((WSStation)->())?
    var tableView: UITableView!
    
    var filteredStation: [WSStation]? {
        didSet {
            self.tableView.reloadData()
        }
    }

//MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        configSubViews()
    }

//MARK:- layout
    private func configSubViews() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         view.frame.origin.y = -40
    }
}


extension WSSearchStationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredStation = filteredStation {
            return filteredStation.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = filteredStation![indexPath.row].Name
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = selectBlock {   
            block(filteredStation![indexPath.row])
        }
    }
}
