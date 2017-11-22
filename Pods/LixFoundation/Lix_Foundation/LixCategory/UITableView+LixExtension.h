//
//  UITableView+LixExtension.h
//  LixFoundation
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LixExtension)

/**
 *   为TableViewCell绘制分隔线
 
 @param cell      单元格
 @param tableView 表视图
 @param indexPath 单元格坐标
 */
+ (void)separateLineForCell:(UITableViewCell *)cell TableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath Color:(UIColor *)color;

@end
