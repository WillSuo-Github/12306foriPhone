//
//  WSGrapTicketontroller.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit
import RxSwift

class WSGrapTicketontroller: UIViewController {

    var leaveDate = Date()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    private let calendarVc = WSCalendarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "抢票"
        view.backgroundColor = .brown
        
        configSubViews()
        configNavItem()
    }

//MARK:- layout
    private func configSubViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeLabel.text = dateFormatter.string(from: leaveDate)
        dateFormatter.dateFormat = "EEEE"
        weekLabel.text = dateFormatter.string(from: leaveDate)
        
        
    }
    
    private func configNavItem() {
        
        hidesBottomBarWhenPushed = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tab_grap"), landscapeImagePhone: UIImage(named: "tab_grap"), style: .plain, target: self, action: #selector(WSGrapTicketontroller.startGrapTicket))
    }

//MARK:- tapped response
    @IBAction func fromStationDidTapped(_ sender: UIButton) {

        let stationController = WSStationController()
        navigationController?.pushViewController(stationController, animated: true)
        stationController.selectBlock = { station in
            sender.setTitle(station.Name, for: .normal)
        }
    }
    
    @IBAction func toStationDidTapped(_ sender: UIButton) {
        
        let stationController = WSStationController()
        navigationController?.pushViewController(stationController, animated: true)
        stationController.selectBlock = { station in
            sender.setTitle(station.Name, for: .normal)
        }
    }
    
    @IBAction func calendarDidTapped(_ sender: Any) {
    
        navigationController?.pushViewController(calendarVc, animated: true)
    }
    
    func startGrapTicket() {
        
        if !WSLogin.checkLogin() {return}
        print(11111)
    }
    
}





