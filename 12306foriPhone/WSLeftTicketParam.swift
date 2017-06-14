//
//  WSLeftTicketParam.swift
//  12306foriPhone
//
//  Created by WS on 2017/6/14.
//  Copyright © 2017年 WS. All rights reserved.
//

import Foundation

struct WSLeftTicketParam {
    
    var train_date = ""
    
    var from_stationCode = ""
    
    var to_stationCode = ""
    
    var purpose_codes = ""
    
    func ToGetParams() -> String {
        return "leftTicketDTO.train_date=\(train_date)&leftTicketDTO.from_station=\(from_stationCode)&leftTicketDTO.to_station=\(to_stationCode)&purpose_codes=\(purpose_codes)"
    }
}
