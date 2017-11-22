//
//  LNRunViewControllerProtocol.h
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LNRunViewControllerProtocol <NSObject>

@optional

- (void)ln_setupViews;
- (void)ln_addSubviews;
- (void)ln_updateConstraints;
- (void)ln_layoutNavigation;
- (void)ln_dealloc;
- (void)ln_bindRunData;
- (void)ln_bindStepData;

@end
