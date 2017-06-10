//
//  WSCalendarView.swift
//  WSCalendarDemo
//
//  Created by WS on 2017/5/31.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit


protocol WSCalendarViewDelegate: class {
    func didSelectDate(calendarDate: WSCalendarDate)
    func didShowMonth(currentMonth: Int)
}

extension WSCalendarViewDelegate {
    func didSelectDate(calendarDate: WSCalendarDate) {}
    func didShowMonth(currentMonth: Int) {}
}

class WSCalendarView: UIView {
    
    fileprivate var sourceArr: [[WSCalendarViewModule]]!
    fileprivate var scrollView: UIScrollView!
    fileprivate var selectArr: [WSCalendarItem] = [WSCalendarItem]()
    
    open weak var calendarDelegate: WSCalendarViewDelegate?
    
//MARK:- life cycle
    public init(frame: CGRect, config: WSCalendarConfig) {
        super.init(frame: frame)
        
        configSourceArr()
        configSubViews()
        
        delay(0.2) { 
            self.scrollViewDidEndDecelerating(self.scrollView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK:- layout
    
    private func configSubViews() {
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = WSCalendarConfig.scrollBackgroundColor
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        self.addSubview(scrollView)
        
        configScrollViewCell()
    }

    private func configScrollViewCell() {
        for i in 0..<sourceArr.count {
            for j in 0..<sourceArr[i].count {
                let itemModule = sourceArr[i][j]
                let itemView = WSCalendarItem(frame: itemModule.frame)
                itemView.calendarDate = itemModule.calendarDate
                itemView.restorationIdentifier = "\(i),\(j)"
                itemView.selectArr = selectArr
                itemView.itemDelegate = self
                scrollView.addSubview(itemView)
            }
            
            if i == 0 {
                let itemRow = sourceArr[i].count / 7
                updateScrollViewFrame(itemRow)
            }
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * CGFloat(sourceArr.count), height: scrollView.bounds.size.height)
    }
    
    fileprivate func updateScrollViewFrame(_ width: CGFloat, _ height: CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: height)
        scrollView.frame = self.bounds
    }
    
    fileprivate func updateScrollViewFrame(_ itemRow: Int) {
        if let itemSize = WSCalendarConfig.itemSize {
            let height = CGFloat(itemRow) * itemSize.height + CGFloat(itemRow - 1) * WSCalendarConfig.itemSpacing + WSCalendarConfig.scrollEdgeInset.top + WSCalendarConfig.scrollEdgeInset.bottom
            let width = 7.0 * itemSize.width + 6.0 * WSCalendarConfig.itemSpacing + WSCalendarConfig.scrollEdgeInset.left + WSCalendarConfig.scrollEdgeInset.right
            updateScrollViewFrame(width, height)
        }
    }
    
    fileprivate func reloadData() {
        for subview in scrollView.subviews {
            if let str = subview.restorationIdentifier {
                let array = str.components(separatedBy: ",")
                let i = Int(array[0])!
                let j = Int(array[1])!
                let subV = subview as! WSCalendarItem
                subV.calendarDate = sourceArr[i][j].calendarDate
                subV.frame = sourceArr[i][j].frame
            }
        }
    }
    
//MARK:- other
    private func configSourceArr() {
        sourceArr = WSCalendarViewModule.getAllModules(scrollViewWidth: self.bounds.size.width)
    }
    
    fileprivate func getCurrentMonth() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return Int(dateFormatter.string(from: Date()))!
    }
    
    private func getAllRows() -> [Int] {
        var tmpArr: [Int] = [Int]()
        for i in 0..<sourceArr.count {
            tmpArr.append(sourceArr[i].count / 7)
        }
        return tmpArr
    }
    
    private func delay(_ second: Double,_ block: @escaping ()->Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + second) {
            block()
        }
    }
}


extension WSCalendarView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = lroundf(Float(scrollView.contentOffset.x / scrollView.bounds.size.width))
        let itemRow = sourceArr[index].count / 7
        updateScrollViewFrame(itemRow)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = lroundf(Float(scrollView.contentOffset.x / scrollView.bounds.size.width))
        var currentMonth = getCurrentMonth()
        currentMonth = currentMonth + index
        if let delegate = calendarDelegate {
            delegate.didShowMonth(currentMonth: currentMonth)
        }
    }
}

extension WSCalendarView: WSCalendarItemDelegate {
    
    func calendarItemDidTapped(_ calendarItem: WSCalendarItem, viewId: String) {

        for view in selectArr {
            let v = view as WSCalendarItem
            let array = v.restorationIdentifier!.components(separatedBy: ",")
            let i = Int(array[0])!
            let j = Int(array[1])!
            sourceArr[i][j].calendarDate.selectState = .normal
        }
        
        selectArr.removeAll()
        
        let array = viewId.components(separatedBy: ",")
        let i = Int(array[0])!
        let j = Int(array[1])!
        sourceArr[i][j].calendarDate.selectState = .selected
        selectArr.append(calendarItem)
        reloadData()
        
        if let delegate = calendarDelegate {
            delegate.didSelectDate(calendarDate: sourceArr[i][j].calendarDate)
        }
    }
    
}

