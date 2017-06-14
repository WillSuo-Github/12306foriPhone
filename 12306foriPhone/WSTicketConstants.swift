//
//  WSTicketConstants.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/14.
//  Copyright © 2017年 WS. All rights reserved.
//

import Foundation

//动车
let D_SEAT_TYPE_NAME_DIC = ["高级软卧":"A","商务座": "9", "特等座": "P", "一等座": "M", "二等座": "O","软卧": "F", "无座": "O"]
let D_SEAT_TYPE_KEYPATH_DIC = ["高级软卧": "Gr_Num","商务座": "Swz_Num", "特等座": "Tz_Num", "一等座": "Zy_Num", "二等座": "Ze_Num","软卧": "Rw_Num", "无座": "Wz_Num"]

//普通车
let K_SEAT_TYPE_NAME_DIC = ["高级软卧": "6","软卧": "4", "硬卧": "3", "软座": "2", "硬座": "1", "无座": "1"]
let K_SEAT_TYPE_KEYPATH_DIC = ["高级软卧": "Gr_Num","软卧": "Rw_Num", "硬卧": "Yw_Num", "软座": "Rz_Num", "硬座": "Yz_Num", "无座": "Wz_Num"]

func G_QuerySeatTypeNameDicBy(_ trainCode: String) -> [String: String] {
    if trainCode.contains("G") || trainCode.contains("D") || trainCode.contains("C") {
        return D_SEAT_TYPE_NAME_DIC
    }else {
        return K_SEAT_TYPE_NAME_DIC
    }
}

func G_QuerySeatTypeKeyPathDicBy(_ trainCode:String)->[String:String] {
    if (trainCode.contains("G"))||(trainCode.contains("D")||(trainCode.contains("C"))) {
        return D_SEAT_TYPE_KEYPATH_DIC;
    }
    else {
        return K_SEAT_TYPE_KEYPATH_DIC;
    }
}
