//
//  LixMarcoSwift.swift
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

import Foundation

//从以秒计时的时间里获得表示时间的字符串用于显示
func getTimeStringFromSecond(seconds: Int) -> String {
    
    let secondNumber = seconds % 60
    let minuteNumber = (seconds / 60) % 60
    let hourNumber = (seconds / (60*60)) % 24
    
    let secondText = secondNumber < 10 ? "0\(secondNumber)" : "\(secondNumber)"
    let minuteText = minuteNumber < 10 ? "0\(minuteNumber)" : "\(minuteNumber)"
    let hourText = hourNumber < 10 ? "0\(hourNumber)" : "\(hourNumber)"
    
    return "\(hourText):\(minuteText):\(secondText)"
}
