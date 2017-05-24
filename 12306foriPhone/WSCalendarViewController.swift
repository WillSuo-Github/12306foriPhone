//
//  WSCalendarViewController.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/24.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit
import JTAppleCalendar

class WSCalendarViewController: UIViewController {

    var calendarView: JTAppleCalendarView!
    @IBOutlet weak var headerView: UIView!
    
//MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        configSubViews()
    }
    
    
//MARK:- layout
    private func configSubViews() {
        
        let calendarHeaderView = WSCalendarHeaderView()
        headerView.addSubview(calendarHeaderView)
        calendarHeaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
