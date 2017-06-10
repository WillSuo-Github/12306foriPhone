//
//  WSCalendarViewModule.swift
//  WSCalendarDemo
//
//  Created by WS on 2017/6/7.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

struct WSCalendarViewModule {
    var calendarDate: WSCalendarDate
    var frame: CGRect
    
    public static func getAllModules(scrollViewWidth: CGFloat) -> [[WSCalendarViewModule]] {
        
        
        var baseX: CGFloat = 0.0
        var baseY: CGFloat = 0.0
        let itemWH: CGFloat = ((scrollViewWidth - WSCalendarConfig.scrollEdgeInset.left - WSCalendarConfig.scrollEdgeInset.right) / 7).toTwoPoint()
        WSCalendarConfig.itemSize = CGSize(width: itemWH, height: itemWH)
        
        var itemX: CGFloat = 0.0
        var itemY: CGFloat = 0.0
        
        var allModuleArr = [[WSCalendarViewModule]]()
        
        let calendarTool: WSCalendarTool = WSCalendarTool()
        let calendarDateArr = calendarTool.getAllDate()
        for i in 0..<calendarDateArr.count {
            baseX = CGFloat(i) * scrollViewWidth + WSCalendarConfig.scrollEdgeInset.left
            baseY = WSCalendarConfig.scrollEdgeInset.top
            var moduleArr = [WSCalendarViewModule]()
            for j in 0..<calendarDateArr[i].count {
                
                itemX = baseX + CGFloat(j % 7) * (itemWH + WSCalendarConfig.itemSpacing)
                itemY = baseY + CGFloat(j / 7) * (itemWH + WSCalendarConfig.itemSpacing)
                let itemFrame = CGRect(x: itemX, y: itemY, width: itemWH, height: itemWH)
                let calendarModule = WSCalendarViewModule(calendarDate: calendarDateArr[i][j], frame:itemFrame)
                moduleArr.append(calendarModule)
            }
            allModuleArr.append(moduleArr)
        }
        return allModuleArr
    }
}


extension CGFloat {
    func toTwoPoint () -> CGFloat{
        let str = String(format: "%.2f", self)
        
        if let number = NumberFormatter().number(from: str) {
            return CGFloat(number)
        }else{
            return 0.0
        }
    }
}
