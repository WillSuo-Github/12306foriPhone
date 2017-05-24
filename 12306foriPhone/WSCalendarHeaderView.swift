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
    private var layout: UICollectionViewFlowLayout!

//MARK:- life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- layout
    private func configSubViews() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WSCalendarHeaderCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemWidth = (self.width - 50) / 2
        layout.itemSize = CGSize(width: itemWidth, height: self.height)
        collectionView.collectionViewLayout = layout
    }
    
//MARK:- lazy
    var sourceArr: Array = {
        return ["十二月", "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月", "一月"]
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
        
        if scrollView.contentSize.width < scrollView.contentOffset.x + scrollView.width {
            scrollView.contentOffset.x = 0
        }
        
        if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = scrollView.contentSize.width - scrollView.width
        }
    }
}

