//
//  WSStation.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

struct WSStation {
    //首字母拼音 比如 bj
    var FirstLetter:String
    //车站名
    var Name:String
    //电报码
    var Code:String
    //全拼
    var Spell:String
}

class StationNameJs {
    fileprivate static let sharedManager = StationNameJs()
    class var sharedInstance: StationNameJs {
        return sharedManager
    }
    
    var allStation: [WSStation]
    
    var allStationMap: [String: WSStation]
    
    fileprivate init() {
        allStation = [WSStation]()
        allStationMap = [String: WSStation]()
        
        let path = Bundle.main.path(forResource: "station_name", ofType: "js")
        let stationInfo = try! NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) as String
        
        if let matches = Regex("@[a-z]+\\|([^\\|]+)\\|([a-z]+)\\|([a-z]+)\\|([a-z]+)\\|").getMatches(stationInfo) {
            for match in matches {
                let oneStation = WSStation(FirstLetter: match[3], Name: match[0], Code: match[1], Spell: match[2])
                self.allStation.append(oneStation)
                self.allStationMap[oneStation.Name] = oneStation
            }
        }
    }
}
