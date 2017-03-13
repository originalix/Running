//
//  UIImageView+LixCornerRadius.m
//  LixFoundation
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "UIImageView+LixCornerRadius.h"
#import <objc/runtime.h>

const char kProcessedImage;

@interface UIImageView ()

@property (assign, nonatomic) CGFloat lixRadius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) CGFloat lixBorderWidth;
@property (strong, nonatomic) UIColor *lixBorderColor;
@property (assign, nonatomic) BOOL lixHadAddObserver;
@property (assign, nonatomic) BOOL lixIsRounding;

@end

@implementation UIImageView (LixCornerRadius)

/**
 初始化一个圆形UIImageView 没有离屏渲染
 
 @return UIImageView
 */
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self lix_cornerRadiusRoundingRect];
    }
    return self;
}

/**
 初始化一个带圆角的UIImageView 没有离屏渲染
 
 @param cornerRadius 圆角
 @param rectCornerType 圆角位置类型
 @return UIImageView
 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self lix_cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

/**
 为UIImageView添加边框
 
 @param width 边框宽度
 @param color 边框颜色
 */
- (void)lix_attachBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.lixBorderWidth = width;
    self.lixBorderColor = color;
}

#pragma mark - Kernel Method
/**
 为UIImageView的image属性修剪圆角，必须在UIImageView设置Frame之前调用
 
 @param image 图片
 @param cornerRadius 圆角
 @param rectCornerType 圆角类型
 */
- (void)lix_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 为UIImageView的image属性修剪圆角，包含backgroundColor属性，必须在UIImageView设置Frame之前调用
 
 @param image 图片
 @param cornerRadius 圆角
 @param rectCornerType 圆角类型
 @param backgroundColor 背景颜色
 */
- (void)lix_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 为UIImageView设置圆角，避免离屏渲染
 
 @param cornerRadius 圆角
 @param rectCornerType 圆角类型
 */
- (void)lix_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.lixRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.lixIsRounding = NO;
    if (!self.lixHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.lixHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}


/**
 设置圆形UIImageView
 */
- (void)lix_cornerRadiusRoundingRect {
    self.lixIsRounding = YES;
    if (!self.lixHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.lixHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)drawBorder:(UIBezierPath *)path {
    if (0 != self.lixBorderWidth && nil != self.lixBorderColor) {
        [path setLineWidth:2 * self.lixBorderWidth];
        [self.lixBorderColor setStroke];
        [path stroke];
    }
}

- (void)lix_dealloc {
    if (self.lixHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self lix_dealloc];
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(lix_dealloc)];
    });
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(lix_LayoutSubviews)];
    });
}

- (void)lix_LayoutSubviews {
    [self lix_LayoutSubviews];
    if (self.lixIsRounding) {
        [self lix_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.lixRadius && 0 != self.roundingCorners && nil != self.image) {
        [self lix_cornerRadiusWithImage:self.image cornerRadius:self.lixRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.lixIsRounding) {
            [self lix_cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width / 2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.lixRadius && 0 != self.roundingCorners && nil != self.image) {
            [self lix_cornerRadiusWithImage:newImage cornerRadius:self.lixRadius rectCornerType:self.roundingCorners];
        }
    }
}

#pragma mark property
- (CGFloat)lixBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setLixBorderWidth:(CGFloat)lixBorderWidth {
    objc_setAssociatedObject(self, @selector(lixBorderWidth), @(lixBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)lixBorderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLixBorderColor:(UIColor *)lixBorderColor {
    objc_setAssociatedObject(self, @selector(lixBorderColor), lixBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lixHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLixHadAddObserver:(BOOL)lixHadAddObserver {
    objc_setAssociatedObject(self, @selector(lixHadAddObserver), @(lixHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lixIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLixIsRounding:(BOOL)lixIsRounding {
    objc_setAssociatedObject(self, @selector(lixIsRounding), @(lixIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lixRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setLixRadius:(CGFloat)lixRadius {
    objc_setAssociatedObject(self, @selector(lixRadius), @(lixRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
