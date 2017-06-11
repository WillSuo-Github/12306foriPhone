//
//  WSCalendarDate.swift
//  WSCalendarDemo
//
//  Created by WS on 2017/6/7.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

enum WSCalendarItemSelectState {
    case normal
    case selected
    case unSelect
    case defaultSelect
    case unSelectable
}

struct WSCalendarDate {
    //对应的日期
    var date: Date
    //日期的标题
    var dateString: String
    //选中的状态
    var selectState: WSCalendarItemSelectState
    
    
}
