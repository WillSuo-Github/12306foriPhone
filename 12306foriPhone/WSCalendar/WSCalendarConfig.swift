//
//  WSCalendarConfig.swift
//  WSCalendarDemo
//
//  Created by WS on 2017/6/7.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

struct WSCalendarConfig {
    
    public static var startDate: Date = Date()
    public static var maxDayAfterStart: Int = 10

    public static var itemSpacing: CGFloat = 0.0
    public static var scrollEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10)
    public static var scrollBackgroundColor: UIColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    
    //不要修改这个是内部用的
    public static var itemSize: CGSize?
    
    public static var itemNomalTextColor: UIColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    public static var itemSelectTextColor: UIColor = .white
    public static var itemDefaultSelectTextColor: UIColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    public static var itemUnSelectableTextColor: UIColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)
    
    public static var itemBackgroundColor: UIColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    public static var itemDefaultSelectBgColor: UIColor = UIColor(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1)
    public static var itemSelectBgColor: UIColor = .red
}
