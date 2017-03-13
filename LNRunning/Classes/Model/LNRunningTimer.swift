//
//  LNRunningTimer.swift
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

import UIKit

class LNRunningTimer: NSObject {
    //MARK: var property
    private var timeLabel: UILabel!
    private var timer: NSTimer?
    //开始和结束时间列表
    lazy private var startTimes = [NSDate]()
    lazy private var endTimes = [NSDate]()
    
    internal var timeNumber = 0 {
        didSet {
            timeString = NSString.timeFormatted(timeNumber)
        }
    }
    
    internal private(set) var timeString = "00:00:00" {
        didSet {
            timeLabel.text = timeString
        }
    }
    
    //MARK: - 初始化
    init(timeLabel: UILabel) {
        self.timeLabel = timeLabel
        timeLabel.text = timeString
    }
    
    //MARK: - 计时器
    private func timeCount(){
        if startTimes.count == 1 {
            let currentTime = NSDate()
            timeNumber = Int(CFDateGetTimeIntervalSinceDate(currentTime, startTimes[0]))
        }else{
            if startTimes.count - endTimes.count == 1 {
                endTimes.append(NSDate())
            }
            let index = startTimes.count - 1
            endTimes[index] = NSDate()
            var timeCount = 0
            for startTime in startTimes{
                timeCount += Int(CFDateGetTimeIntervalSinceDate(endTimes[startTimes.indexOf(startTime)!],startTime))
            }
            timeNumber = timeCount
        }
    }
    
    @objc private func count(){
        timeCount()
    }
    
    //计时开始
    func timingStart(){
        startTimes.append(NSDate())
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.count), userInfo: nil, repeats: true)
    }
    
    //暂停计时
    func timingPause(){
        endTimes.append(NSDate())
        timer?.invalidate()
    }
    
    //暂停后继续计时
    func timingContinue(){
        timingStart()
    }
    
    //重置Timer
    func resetToStart() {
        startTimes = []
        endTimes = []
        timer?.invalidate()
        timeNumber = 0
    }
    
    //获得当前运动时间
    func getCurrentRunningTime() -> Int {
        return timeNumber
    }
}
