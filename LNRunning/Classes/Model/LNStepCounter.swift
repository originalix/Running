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
    func didUpdateSteps(_ numberOfSteps: Int)
}

class LNStepCounter: NSObject {

    fileprivate var startTime: Date?
    fileprivate var endTime: Date!
    fileprivate var pedometer: CMPedometer!
    lazy fileprivate var numberOfSteps = 0
    fileprivate var getSetpTimer:Timer?
    @objc var delegate: StepCountingDelegate!
    fileprivate var shouldUpdateSteps = false
    
    @objc func startStepCounting() {
        numberOfSteps = 0
        startTime = Date()
        shouldUpdateSteps = true
        startUpdateSteps()
    }
    
    @objc func endStepCounting() {
        shouldUpdateSteps = false
        getSetpTimer?.invalidate()
    }
    
    @objc func pause() {
        shouldUpdateSteps = false
    }
    
    @objc func continueCounting() {
        shouldUpdateSteps = true
    }
    
    @objc func resetToStart() {
        shouldUpdateSteps = false
        numberOfSteps = 0
        getSetpTimer?.invalidate()
        startTime = nil
    }
    
    fileprivate func startUpdateSteps() {
        getSetpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LNStepCounter.getNumberOfSteps), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func getNumberOfSteps() {
        
        getPedonmeterData()
        
        if shouldUpdateSteps{
            delegate?.didUpdateSteps(numberOfSteps)
        }
    }
    
    fileprivate func getPedonmeterData() {
        endTime = Date()
        pedometer = CMPedometer()
        if CMPedometer.isStepCountingAvailable(){
            if startTime != nil{
                pedometer.startUpdates(from: startTime!, withHandler: { (data, error) in
                    if error != nil{
                        print("\(error?.localizedDescription)")
                    }else{
                        if data != nil{
                            DispatchQueue.main.async(execute: {
                                self.numberOfSteps = Int(truncating: data!.numberOfSteps)
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
            pedometer.queryPedometerData(from: TwentyFourHourAgo(), to: Date(), withHandler: { (data, error) in
                if error != nil{
                    print("\(error?.localizedDescription)")
                    self.showWarnning()
                } else {
                    if data != nil{
                        print("步数 = \(Int(truncating: data!.numberOfSteps))")
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
    fileprivate func TwentyFourHourAgo() -> Date {
        let nowInterval = Date().timeIntervalSinceNow
        let now: Int = Int(nowInterval)
        let queryTime = now - (60 * 60 * 24)
        let queryInterval = TimeInterval.init(NSNumber.init(value: queryTime as Int))
        let queryDate = Date().addingTimeInterval(queryInterval)
        return queryDate
    }
    
    /// 提醒用户去开启运动权限
    fileprivate func showWarnning() {
        LixAlertUtil.presentAlertView(withTitle: "提示", message: "检测到您未开启运动与健身权限，您的跑步有可能会被记录为异常数据，请打开运动与健身权限", cancelTitle: "知道了", defaultTitle: "去设置", distinct: true, cancel: {
            }, confirm: {
                UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        })
    }
}
