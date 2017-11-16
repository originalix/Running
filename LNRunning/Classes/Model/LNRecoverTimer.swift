//
//  LNRecoverTimer.swift
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

import UIKit

/* 测试重启App恢复定时器*/

class LNRecoverTimer: NSObject {
    //MARK: var property
    fileprivate var timeLabel: UILabel!
    fileprivate var timer: Timer?
    //开始和结束时间列表
    lazy fileprivate var startTimes = [Date]()
    lazy fileprivate var endTimes = [Date]()
    
    @objc internal var timeNumber = 0 {
        didSet {
            timeString = NSString.timeFormatted(timeNumber)
        }
    }
    
    internal fileprivate(set) var timeString = "00:00:00" {
        didSet {
            timeLabel.text = timeString
        }
    }
    
    //MARK: - 初始化
    @objc init(timeLabel: UILabel) {
        self.timeLabel = timeLabel
        timeLabel.text = timeString
    }
    
    //MARK: - 计时器
    @objc fileprivate func timeCount(){
        if startTimes.count == 1 {
            let currentTime = Date()
            timeNumber = Int(CFDateGetTimeIntervalSinceDate(currentTime as CFDate!, startTimes[0] as CFDate!))
        }else{
            if startTimes.count - endTimes.count == 1 {
                endTimes.append(Date())
            }
            let index = startTimes.count - 1
            endTimes[index] = Date()
            var timeCount = 0
            for startTime in startTimes{
                timeCount += Int(CFDateGetTimeIntervalSinceDate(endTimes[startTimes.index(of: startTime)!] as CFDate!,startTime as CFDate!))
            }
            timeNumber = timeCount
        }
    }
    
    @objc fileprivate func count(){
        timeCount()
    }
    
    //计时开始
    @objc func timingStart(){
        startTimes.append(Date())
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.count), userInfo: nil, repeats: true)
    }
    
    //暂停计时
    @objc func timingPause(){
        endTimes.append(Date())
        timer?.invalidate()
    }
    
    //暂停后继续计时
    @objc func timingContinue(){
        timingStart()
    }
    
    //重置Timer
    @objc func resetToStart() {
        startTimes = []
        endTimes = []
        timer?.invalidate()
        timeNumber = 0
    }
    
    //获得当前运动时间
    @objc func getCurrentRunningTime() -> Int {
        return timeNumber
    }
}
