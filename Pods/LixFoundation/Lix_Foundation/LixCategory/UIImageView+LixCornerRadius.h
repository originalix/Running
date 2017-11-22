//
//  UIImageView+LixCornerRadius.h
//  LixFoundation
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LixCornerRadius)

/**
 初始化一个带圆角的UIImageView 没有离屏渲染
 
 @param cornerRadius 圆角
 @param rectCornerType 圆角位置类型
 @return UIImageView
 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

/**
 为UIImageView设置圆角，避免离屏渲染
 
 @param cornerRadius 圆角∫
 @param rectCornerType 圆角类型
 */
- (void)lix_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

/**
 初始化一个圆形UIImageView 没有离屏渲染
 
 @return UIImageView
 */
- (instancetype)initWithRoundingRectImageView;

/**
 设置圆形UIImageView
 */
- (void)lix_cornerRadiusRoundingRect;

/**
 为UIImageView添加边框
 
 @param width 边框宽度
 @param color 边框颜色
 */
- (void)lix_attachBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
