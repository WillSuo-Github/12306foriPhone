//
//  WSDateTool.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/14.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

extension Date {
    func getDateString(_ formatterString: String) -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatterString
        return dateformatter.string(from: self)
    }
}
