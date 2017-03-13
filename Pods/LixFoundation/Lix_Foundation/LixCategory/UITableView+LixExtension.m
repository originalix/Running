//
//  UITableView+LixExtension.m
//  LixFoundation
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "UITableView+LixExtension.h"
#import "LixFoundation.h"
@implementation UITableView (LixExtension)

+ (void)separateLineForCell:(UITableViewCell *)cell TableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath Color:(UIColor *)color {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.backgroundColor = color;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            addLine = NO;
        } else if (indexPath.row == 0) {
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            addLine = NO;
        } else {
            addLine = YES;
        }
        
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = [CalculateLayout lix_onePixel];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width + 10, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *cellView = [[UIView alloc] initWithFrame:bounds];
        [cellView.layer insertSublayer:layer atIndex:0];
        cellView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = cellView;
    }
}

@end
