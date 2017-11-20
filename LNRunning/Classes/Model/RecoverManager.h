//
//  RecoverManager.h
//  LNRunning
//
//  Created by Lix on 2017/11/20.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 处理非正常结束跑步之后的恢复逻辑类
 */
@interface RecoverManager : NSObject

- (void)checkNeedRecoverRun;

@end
