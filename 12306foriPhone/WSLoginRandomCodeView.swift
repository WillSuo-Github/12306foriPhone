//
//  WSLoginRandomCodeView.swift
//  12306foriPhone
//
//  Created by ws on 2016/10/30.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
private struct imageLocation {
    var rowIndex: Int
    var colIndex: Int
}

class WSLoginRandomCodeView: UIView {

    var randomCode =  CGFloat(Float(arc4random()) / Float(UINT32_MAX))//0~1
    var selectCode: String {
        get{
            if self.myImageV.subviews.count == 0 {
                return ""
            }else{
                var tmpStr = ""
//                for (index, view) in self.myImageV.subviews.enumerated() {
//                    if index == 1 {
//                        tmpStr.append("\(view.frame.origin.x + 40.0),\(view.frame.origin.y)")
//                    }else{
//                        tmpStr.append(",\(view.frame.origin.x + 40.0),\(view.frame.origin.y)")
//                    }
//                }
                
                return tmpStr
            }
        }
    }
    
    public var myImage: UIImage{
        set{
            self.myImageV.image = newValue
        }
        get{
            return self.myImage
        }
    }
    
    private var myImageV: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpSubViews() {
        
        myImageV = UIImageView(frame: self.frame)
        myImageV.isUserInteractionEnabled = true
        myImageV.contentMode = .scaleToFill
        addSubview(myImageV)
        myImageV.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(WSLoginRandomCodeView.imageDidTouch(_:)))
        myImageV.addGestureRecognizer(tap)
    }
    
    func imageDidTouch(_ gesture: UIGestureRecognizer) {
        
        let point = transformTouchLocation(locationPoint: gesture.location(in: myImageV))
        print(point as Any)
        if point != nil {
            let coverView = WSPassCoverView(frame: CGRect(x: point!.x, y: point!.y, width: 67.3, height: 67.3))
            myImageV.addSubview(coverView)
        }
        
    }
    
    
    //转换点击的区域
    private func transformTouchLocation(locationPoint: CGPoint) ->CGPoint?{
        
        let imageWH = 67.5
        let imageLocation = getTouchIndex(locationPoint: locationPoint)
        if imageLocation.rowIndex != 0 && imageLocation.colIndex != 0 {
            if imageLocation.rowIndex == 1 {
                return CGPoint(x: Double(imageLocation.colIndex - 1) * (imageWH + 5) + 5.6, y: 42.0)
            }else{
                return CGPoint(x: Double(imageLocation.colIndex - 1) * (imageWH + 5) + 5.6, y: 114.0)
            }
        }else{
            return nil
        }
    }
    
    //获取点击的行列
    private func getTouchIndex(locationPoint: CGPoint) -> imageLocation {
        var imageL = imageLocation(rowIndex: 0, colIndex: 0)
        
        if locationPoint.y > 42.0 && locationPoint.y < 108.6 {//第一行
            imageL.rowIndex = 1
        }else if locationPoint.y > 114.0 && locationPoint.y < 180.6{//第二行
            imageL.rowIndex = 2
        }
        
        if locationPoint.x > 5.6 && locationPoint.x < 72.3{//第一列
            imageL.colIndex = 1
        }else if locationPoint.x > 77.3 && locationPoint.x < 144.6 {//第二列
            imageL.colIndex = 2
        }else if locationPoint.x > 149.6 && locationPoint.x < 216.3 {//第三列
            imageL.colIndex = 3
        }else if locationPoint.x > 220.9 && locationPoint.x < 288.6 {//第四列
            imageL.colIndex = 4
        }
        
        return imageL
    }
    
    private func convertSectionToRandCode(imageL:imageLocation)->(Int,Int){
        var randX = 0
        var randY = 0
        if imageL.rowIndex == 1 {
            randY = 110
        }
        else if(imageL.rowIndex == 2){
            randY = 40
        }
        
        if imageL.colIndex == 1{
            randX = 40
        }
        else if imageL.colIndex == 2{
            randX = 110
        }
        else if imageL.colIndex == 3{
            randX = 180
        }
        else if imageL.colIndex == 4{
            randX = 255
        }
        return (randX,randY)
    }
}
