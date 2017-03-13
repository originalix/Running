//
//  LNPolyLine.m
//  LNTS
//
//  Created by Lix on 16/12/15.
//  Copyright © 2016年 济南欧迅体育科技发展有限公司. All rights reserved.
//

#import "LNPolyLine.h"

@implementation LNPolyLine

+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count color:(UIColor *)color {
    
    LNPolyLine *polyline = [self polylineWithCoordinates:coords count:count];
    
    polyline.color = color;
    
    return polyline;
}

@end
