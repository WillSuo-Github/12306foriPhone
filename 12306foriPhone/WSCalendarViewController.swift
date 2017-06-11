//
//  WSCalendarViewController.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/24.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

protocol WSCalendarViewControllerDelegate: class {
    func WSCalendarViewControllerDidSelectDate(_ date: Date, calendarVc: WSCalendarViewController)
}

class WSCalendarViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    public weak var delegate: WSCalendarViewControllerDelegate?
    
    fileprivate var selectDate: Date?
    private var currentCalendar: Calendar?
    fileprivate var calendarHeaderView = WSCalendarHeaderView()
    private var calendarView: WSCalendarView!
    
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
        WSCalendarConfig.maxDayAfterStart = 70
        WSCalendarConfig.scrollBackgroundColor = UIColor(hexString: "212226")!
        WSCalendarConfig.itemBackgroundColor = UIColor(hexString: "2d3037")!
        WSCalendarConfig.itemNomalTextColor = .white
        WSCalendarConfig.itemSpacing = 1
        WSCalendarConfig.scrollEdgeInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        WSCalendarConfig.itemDefaultSelectBgColor = UIColor(hexString: "41303a")!
        WSCalendarConfig.itemDefaultSelectTextColor = UIColor(hexString: "c9acb1")!
        WSCalendarConfig.itemUnSelectableTextColor = UIColor(hexString: "777777")!
        WSCalendarConfig.itemSelectBgColor = UIColor(hexString: "8c2f41")!
        
        calendarView = WSCalendarView(frame: CGRect(x: 0, y: headerView.bottom, width: view.width, height: 100))
        calendarView.calendarDelegate = self
        view.addSubview(calendarView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.frame = CGRect(x: 0, y: headerView.bottom, width: view.width, height: 100)
    }

    
//MARK:- lazy
    
}

extension WSCalendarViewController: WSCalendarViewDelegate {
    func didShowMonth(currentMonth: Int) {
        calendarHeaderView.scrollToMonth(currentMonth, true)
    }
    
    func didSelectDate(calendarDate: WSCalendarDate) {
        selectDate = calendarDate.date
        if let delegate = delegate {
            delegate.WSCalendarViewControllerDidSelectDate(calendarDate.date, calendarVc: self)
        }
    }
}
