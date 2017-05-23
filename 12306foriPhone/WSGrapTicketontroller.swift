//
//  WSGrapTicketontroller.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSGrapTicketontroller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "抢票"
        view.backgroundColor = .brown
        
        setUpNavItem()
    }

//MARK:- layout
    private func setUpNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tab_grap"), landscapeImagePhone: UIImage(named: "tab_grap"), style: .plain, target: self, action: #selector(WSGrapTicketontroller.startGrapTicket))
    }

//MARK:- tapped response
    @IBAction func fromStationDidTapped(_ sender: UIButton) {
        navigationController?.hidesBottomBarWhenPushed = true;
        let stationController = WSStationController()
        navigationController?.pushViewController(stationController, animated: true)
        stationController.selectBlock = { station in
            sender.setTitle(station.Name, for: .normal)
        }
    }
    
    @IBAction func toStationDidTapped(_ sender: UIButton) {
        navigationController?.hidesBottomBarWhenPushed = true;
        let stationController = WSStationController()
        navigationController?.pushViewController(stationController, animated: true)
        stationController.selectBlock = { station in
            sender.setTitle(station.Name, for: .normal)
        }
    }
    
    func startGrapTicket() {
        
        if !WSLogin.checkLogin() {return}
        print(11111)
    }
    
}





