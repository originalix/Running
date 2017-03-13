//
//  LNStepCounter.swift
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

import UIKit
import CoreMotion

@objc protocol StepCountingDelegate {
    func didUpdateSteps(numberOfSteps: Int)
}

class LNStepCounter: NSObject {

    private var startTime: NSDate?
    private var endTime: NSDate!
    private var pedometer: CMPedometer!
    lazy private var numberOfSteps = 0
    private var getSetpTimer:NSTimer?
    var delegate: StepCountingDelegate!
    private var shouldUpdateSteps = false
    
    func startStepCounting() {
        numberOfSteps = 0
        startTime = NSDate()
        shouldUpdateSteps = true
        startUpdateSteps()
    }
    
    func endStepCounting() {
        shouldUpdateSteps = false
        getSetpTimer?.invalidate()
    }
    
    func pause() {
        shouldUpdateSteps = false
    }
    
    func continueCounting() {
        shouldUpdateSteps = true
    }
    
    func resetToStart() {
        shouldUpdateSteps = false
        numberOfSteps = 0
        getSetpTimer?.invalidate()
        startTime = nil
    }
    
    private func startUpdateSteps() {
        getSetpTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LNStepCounter.getNumberOfSteps), userInfo: nil, repeats: true)
    }
    
    @objc private func getNumberOfSteps() {
        
        getPedonmeterData()
        
        if shouldUpdateSteps{
            delegate?.didUpdateSteps(numberOfSteps)
        }
    }
    
    private func getPedonmeterData() {
        endTime = NSDate()
        pedometer = CMPedometer()
        if CMPedometer.isStepCountingAvailable(){
            if startTime != nil{
                pedometer.startPedometerUpdatesFromDate(startTime!, withHandler: { (data, error) in
                    if error != nil{
                        print("\(error?.localizedDescription)")
                    }else{
                        if data != nil{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.numberOfSteps = Int(data!.numberOfSteps)
                            })
                        }
                    }
                })
            }
        }
    }
}

//MARK: - 检测运动与健康权限
extension LNStepCounter {
    /// 检测是否开启运动权限
    func checkStepFunction() {
        pedometer = CMPedometer()
        if CMPedometer.isStepCountingAvailable() {
            pedometer.queryPedometerDataFromDate(TwentyFourHourAgo(), toDate: NSDate(), withHandler: { (data, error) in
                if error != nil{
                    print("\(error?.localizedDescription)")
                    self.showWarnning()
                } else {
                    if data != nil{
                        print("步数 = \(Int(data!.numberOfSteps))")
                        let step: Int = Int(data!.numberOfSteps)
                        if step <= 0 {
                            self.showWarnning()
                        }
                    }
                }
            })
        }
    }
    
    /// 获取当前24小时以前的时间点
    ///
    /// - Returns: 24小时之前的时间点
    private func TwentyFourHourAgo() -> NSDate {
        let nowInterval = NSDate().timeIntervalSinceNow
        let now: Int = Int(nowInterval)
        let queryTime = now - (60 * 60 * 24)
        let queryInterval = NSTimeInterval.init(NSNumber.init(integer: queryTime))
        let queryDate = NSDate().dateByAddingTimeInterval(queryInterval)
        return queryDate
    }
    
    /// 提醒用户去开启运动权限
    private func showWarnning() {
        LixAlertUtil.presentAlertViewWithTitle("提示", message: "检测到您未开启运动与健身权限，您的跑步有可能会被记录为异常数据，请打开运动与健身权限", cancelTitle: "知道了", defaultTitle: "去设置", distinct: true, cancel: {
            }, confirm: {
                UIApplication.sharedApplication().openURL(NSURL.init(string: UIApplicationOpenSettingsURLString)!)
        })
    }
}
