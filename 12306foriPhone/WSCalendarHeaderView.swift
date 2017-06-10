//
//  WSCalendarHeaderView.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/24.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSCalendarHeaderView: UIView {
    
    private var collectionView: UICollectionView!
    fileprivate var layout: WSCalendarHeaderLayout = WSCalendarHeaderLayout()
    
    
    /// (0...11)
    public var monthIndex: Int = 0
    var yearIndex: Int {
        get {
            return Int(yearLabel.text!)!
        }
    }
    
//MARK:- life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubViews()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM"
            let month = formatter.string(from: Date())
            self.scrollToMonth(Int(month)!, false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- layout
    
    private func configSubViews() {
        
        backgroundColor = UIColor(hexString: "2D3037")
        
        self.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(10)
        }
    
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WSCalendarHeaderCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemWidth = self.width / 2
        layout.itemSize = CGSize(width: itemWidth, height: self.height)
        collectionView.collectionViewLayout = layout
    }
    
    public func scrollToMonth(_ month: Int,_ animated: Bool = true) {
        
        if month > 12 {
            return
        }
        
        let position = CGPoint(x: (CGFloat(month) - 0.5) * layout.itemSize.width, y: collectionView.contentOffset.y)
        collectionView.setContentOffset(position, animated: animated)
    }
    
    
//MARK:- lazy
    fileprivate var sourceArr: Array = {
        return ["十二月", "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月", "一月"]
    }()
    
    fileprivate var yearLabel: UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: 15)
        tmp.textColor = UIColor(hexString: "bbbbbb")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        tmp.text = formatter.string(from: Date())
        return tmp
    }()
}

extension WSCalendarHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WSCalendarHeaderCell
        cell.titleText = sourceArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var nowYear = Int(yearLabel.text!)!
        if scrollView.contentSize.width < scrollView.contentOffset.x + scrollView.width {
            scrollView.contentOffset.x = 0
            nowYear += 1
            yearLabel.text = ("\(nowYear)")
        }
        
        if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = scrollView.contentSize.width - scrollView.width
            nowYear -= 1
            yearLabel.text = ("\(nowYear)")
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let itemIndex: Int = Int(scrollView.contentOffset.x / layout.itemSize.width)
//        scrollToMonth(itemIndex)
//    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let itemIndex: Int = Int(proposedContentOffset.x / layout.itemSize.width)
        return CGPoint(x: (CGFloat(itemIndex) + 0.5) * layout.itemSize.width, y: proposedContentOffset.y)
    }
}

