//
//  LNPolyLine.h
//  LNTS
//
//  Created by Lix on 16/12/15.
//  Copyright © 2016年 济南欧迅体育科技发展有限公司. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface LNPolyLine : MAPolyline

//构造方法
+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count color:(UIColor *)color;

//折线颜色
@property (nonatomic, strong) UIColor *color;

@end
