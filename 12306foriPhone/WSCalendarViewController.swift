//
//  WSCalendarViewController.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/24.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSCalendarViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    var currentCalendar: Calendar?
    var calendarHeaderView = WSCalendarHeaderView()
    var calendarView: WSCalendarView!
    
//MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        configSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
//MARK:- layout
    private func configSubViews() {
        
        configValue()
        configHeaderView()
        configCalendarView()
    }
    
    private func configValue() {
        let timeZoneBias = 480
        currentCalendar = Calendar.init(identifier: .gregorian)
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    private func configHeaderView() {
        headerView.addSubview(calendarHeaderView)
        calendarHeaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configCalendarView() {
        let config = WSCalendarConfig()
        calendarView = WSCalendarView(frame: CGRect(x: 0, y: headerView.bottom, width: view.width, height: 100), config: config)
        view.addSubview(calendarView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.frame = CGRect(x: 0, y: headerView.bottom, width: view.width, height: 100)
    }

    
//MARK:- lazy
    
}
