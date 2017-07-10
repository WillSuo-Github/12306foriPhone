//
//  WSUserModule.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/18.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSUserModule {
    static var userName = ""
    static var realName = ""
    static var apptk = ""
    
    static var passengers = [WSPassengerDTO]()
    static var selectPassengers = [WSPassengerDTO]()
    static var isGetPassengersInfo = false
    
    static var globalRepeatSubmitToken: String = ""
}
