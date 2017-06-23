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

//MARK:- life cycle
    public class func showSeatAlert() {
        
        let view = WSTrainSeatAlert()
        
        WSConfig.keywindow.addSubview(view)
        view.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(WSConfig.keywindow)
            make.height.equalTo(300)
        }
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
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func configCoverView() {
        
        coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewDidChick))
        coverView.addGestureRecognizer(tap)
        WSConfig.keywindow.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func hideAllView() {
        coverView.removeFromSuperview()
        tableView.removeFromSuperview()
    }
    
//MARK:- tapped response
    func coverViewDidChick() {
        hideAllView()
    }
}

extension WSTrainSeatAlert: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
