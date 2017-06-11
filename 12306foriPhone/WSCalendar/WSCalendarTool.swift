//
//  WSCalendarTool.swift
//  WSCalendarDemo
//
//  Created by WS on 2017/6/1.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSCalendarTool {

//MARK:- public property
    public let disableScrollingBeforeDate: Date = WSCalendarConfig.startDate
    public var lastSelectableDate: Date = Date()
    
//MARK:- private property
    private let calendar: Calendar = Calendar(identifier: .gregorian)
    let dateFormatter = DateFormatter()

//MARK:- public func
    public func getAllDate() -> [[WSCalendarDate]] {
        let monthNum = getMonthNum(disableScrollingBeforeDate, lastSelectableDate)
        var allDateArr: [[WSCalendarDate]] = [[WSCalendarDate]]()
        for i in 0...monthNum {
            let monthFirstDate = getMonthFirstDate(disableScrollingBeforeDate, i)
            allDateArr.append(getDaysInMonth(monthFirstDate))
        }
        return allDateArr
    }
    
    init() {
        lastSelectableDate = getDate(WSCalendarConfig.startDate, WSCalendarConfig.maxDayAfterStart)
    }

//MARK:- private func
    private func getNumberOfDaysInMonth(_ date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        
        if let range = range {
            return range.count
        }else{
            return 0
        }
    }
    
    private func getDaysInMonth(_ date: Date) -> [WSCalendarDate] {
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
        dateFormatter.dateFormat = "yyyyMM"
        let dateBaseStr = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyyMMdd"
        let beforeDateStr = dateFormatter.string(from: disableScrollingBeforeDate)
        
        var tmpArr: [WSCalendarDate] = [WSCalendarDate]()
        
//        let maxSelectableDays = getDayNum(disableScrollingBeforeDate, lastSelectableDate)
        let currentMonthDays = getNumberOfDaysInMonth(date)
        //当月的第一天和最后一天
        var firstDate: WSCalendarDate! ,lastDate: WSCalendarDate!
        
        
        for i in 1...currentMonthDays {
            let str = dateBaseStr.appending(String(format: "%02d", i))
            let tmpDate = dateFormatter.date(from: str)!
            var calendarDate: WSCalendarDate = WSCalendarDate(date: tmpDate, dateString: str, selectState: .normal)
            
            //特殊的日子判断
            if (str == beforeDateStr) {
                calendarDate.selectState = .defaultSelect
            }else if(str < beforeDateStr) {
                calendarDate.selectState = .unSelectable
            }
            
            //超出的日期
            if lastSelectableDate.compare(tmpDate) == .orderedAscending {
                calendarDate.selectState = .unSelectable
            }
            
            //收尾的天数
            if i == 1 {
                firstDate = calendarDate
            }else if i == currentMonthDays {
                lastDate = calendarDate
            }
            
            tmpArr.append(calendarDate)
        }
        
        return insertDaysAtBothEnds(firstDate, lastDate, tmpArr)
    }
    
    private func getDayNum(_ date: Date,_ betweenDate: Date) -> Int {
        
        let result = calendar.dateComponents([.day], from: date, to: betweenDate)
        return result.day ?? 0
    }
    
    private func getMonthNum(_ date: Date,_ betweenDate: Date) -> Int {
        
        let result = calendar.dateComponents([.month], from: date, to: betweenDate)
        return result.month ?? 0
    }
    
    private func getMonthFirstDate(_ date: Date,_ offset: Int) -> Date {
        
        dateFormatter.dateFormat = "MM"
        let dateMonthStr = dateFormatter.string(from: date)
        var dateMonth = Int(dateMonthStr)!
        dateMonth += offset
        let offsetMonth = String(format: "%02d", dateMonth)
        dateFormatter.dateFormat = "yyyyMMdd"
        var allDateMonthStr = dateFormatter.string(from: date)
        allDateMonthStr.replaceSubrange(allDateMonthStr.range(of: dateMonthStr)!, with: offsetMonth)
        return dateFormatter.date(from: allDateMonthStr)!
    }
    
    private func insertDaysAtBothEnds(_ fromDate:WSCalendarDate,_ toDate:WSCalendarDate, _ dataArr:[WSCalendarDate]) -> [WSCalendarDate]{
        
        let fromWeekIndex = calendar.dateComponents([.weekday], from: fromDate.date).weekday
        let toWeekIndex = calendar.dateComponents([.weekday], from: toDate.date).weekday
        
        var headerArr: [WSCalendarDate] = [WSCalendarDate]()
        if let fromIndex = fromWeekIndex {
            for i in 1..<fromIndex {
                let date = getDate(fromDate.date, i - fromIndex)
                let calendarDate = WSCalendarDate(date:date , dateString: getDateStr(date), selectState: .unSelectable)
                headerArr.append(calendarDate)
            }
        }
        
        var footerArr: [WSCalendarDate] = [WSCalendarDate]()
        if let toIndex = toWeekIndex {
            for i in toIndex..<7 {
                let date = getDate(toDate.date, 7 - i)
                let calendarDate = WSCalendarDate(date: date, dateString: getDateStr(date), selectState: .unSelectable)
                footerArr.insert(calendarDate, at: 0)
            }
        }
        
        var allArr = dataArr
        allArr.insert(contentsOf: headerArr, at: 0)
        allArr.insert(contentsOf: footerArr, at: allArr.count)
        return allArr
    }
    
    private func getDate(_ date: Date,_ offset:Int) -> Date{
        var dayComponents = DateComponents()
        dayComponents.day = offset
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: date) {
            return lastDate
        } else {
            return Date()
        }
    }
    
    private func getDateStr(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
}
