//
//  UITableView+HideTableFooterSeperator.m
//  balanceCar
//
//  Created by jancee wang on 16/8/18.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "UITableView+HideTableFooterSeperator.h"

@implementation UITableView (HideTableFooterSeperator)
- (void)hideTableFooterSeperator {
  UIView *view          = [[UIView alloc] init];
  view.backgroundColor  = [UIColor whiteColor];
  
  [self setTableFooterView:view];
}
@end
