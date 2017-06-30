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

    fileprivate var leaveDate = Date()
    fileprivate var fromStation: WSStation?
    fileprivate var toStation: WSStation?
    
    @IBOutlet weak var fromStationButton: UIButton!
    @IBOutlet weak var toStationButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    private let calendarVc = WSCalendarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "抢票"
        view.backgroundColor = .brown
        
        configSubViews()
        configNavItem()
        configDefaultSatation()
    }

//MARK:- layout
    private func configSubViews() {
        
            configDate(leaveDate)
    }
    
    fileprivate func configDate(_ date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEEE"
        weekLabel.text = dateFormatter.string(from: date)
    }
    
    private func configNavItem() {
        
        hidesBottomBarWhenPushed = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tab_grap"), landscapeImagePhone: UIImage(named: "tab_grap"), style: .plain, target: self, action: #selector(WSGrapTicketontroller.startGrapTicket))
    }
    
    private func configDefaultSatation() {
        self.fromStation = WSStation(Initials: "B", FirstLetter: "bj", Name: "北京", Code: "BJP", Spell: "beijing")
        self.toStation = WSStation(Initials: "S", FirstLetter: "shhq", Name: "上海虹桥", Code: "AOH", Spell: "shanghaihongqiao")
        self.fromStationButton.setTitle(self.fromStation?.Name, for: .normal)
        self.toStationButton.setTitle(self.toStation?.Name, for: .normal)
    }

//MARK:- tapped response
    @IBAction func fromStationDidTapped(_ sender: UIButton) {

        let stationController = WSStationController()
        navigationController?.pushViewController(stationController, animated: true)
        stationController.selectBlock = { station in
            self.fromStation = station
            sender.setTitle(station.Name, for: .normal)
        }
    }
    
    @IBAction func toStationDidTapped(_ sender: UIButton) {
        
        let stationController = WSStationController()
        navigationController?.pushViewController(stationController, animated: true)
        stationController.selectBlock = { station in
            self.toStation = station
            sender.setTitle(station.Name, for: .normal)
        }
    }
    
    @IBAction func calendarDidTapped(_ sender: Any) {
        calendarVc.delegate = self
        navigationController?.pushViewController(calendarVc, animated: true)
    }
    
    func startGrapTicket() {
        
        if !WSLogin.checkLogin() {return}
        print(11111)
    }
    

    @IBAction func searchButtonDidTapped(_ sender: Any) {
        
        if let from = fromStation, let to = toStation {
            let trainListVc = WSTrainListViewController()
            trainListVc.headerData = WSTrainListHeaderData(fromStation: from, toStation: to, departureDate: leaveDate)
            navigationController?.pushViewController(trainListVc, animated: true)
        }else{
            self.view.showMessage("请选择出发和到达城市")
        }
        
    }
}

extension WSGrapTicketontroller: WSCalendarViewControllerDelegate {
    func WSCalendarViewControllerDidSelectDate(_ date: Date, calendarVc: WSCalendarViewController) {
        leaveDate = date
        configDate(date)
    }
}





