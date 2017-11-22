//
//  TinyObject.swift
//  LNRunning
//
//  Created by Lix on 2017/11/17.
//  Copyright © 2017年 Lix. All rights reserved.
//

import UIKit
import TinyConsole

class TinyObject: NSObject {
    @objc class func createMainVC(vc: UIViewController) -> UIViewController {
        return TinyConsoleController.init(rootViewController: vc)
    }
    
    @objc class func greenLog(string: String) {
        TinyConsole.print(string, color: UIColor.green, global: true)
    }
    
    @objc class func redLog(string: String) {
        TinyConsole.print(string, color: UIColor.red, global: true)
    }

    @objc class func yellowLog(string: String) {
        TinyConsole.print(string, color: UIColor.yellow, global: true)
    }
    
    @objc class func addMarker() {
        TinyConsole.addMarker()
    }
}
