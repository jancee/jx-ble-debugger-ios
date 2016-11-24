//
//  OrderMenuTableViewController.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/14.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "OrderMenuTableViewController.h"

@interface OrderMenuTableViewController ()

@property (strong, nonatomic) IBOutlet UIView *orderBySearchContentView;
@property (strong, nonatomic) IBOutlet UIView *orderByRSSIContentView;
@property (strong, nonatomic) IBOutlet UIView *orderByNameContentView;

@property (strong, nonatomic) IBOutlet UIImageView *orderBySearchCheckImageView;
@property (strong, nonatomic) IBOutlet UIImageView *orderByRSSICheckImageView;
@property (strong, nonatomic) IBOutlet UIImageView *orderByNameCheckImageView;

@property (strong ,nonatomic) NSMutableArray *array;

@end




@implementation OrderMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  self.array = [[NSMutableArray alloc] init];
  
  //点击对勾视图处理
  UITapGestureRecognizer *orderBySearchContentViewTap = [[UITapGestureRecognizer alloc] init];
  UITapGestureRecognizer *orderByRSSIContentViewTap = [[UITapGestureRecognizer alloc] init];
  UITapGestureRecognizer *orderByNameContentViewTap = [[UITapGestureRecognizer alloc] init];
  [self.orderBySearchContentView addGestureRecognizer:orderBySearchContentViewTap];
  [self.orderByRSSIContentView   addGestureRecognizer:orderByRSSIContentViewTap];
  [self.orderByNameContentView   addGestureRecognizer:orderByNameContentViewTap];
  RAC(self.orderBySearchCheckImageView,hidden) = [[orderBySearchContentViewTap rac_gestureSignal] map:^id(id x) {
    return @(![self.orderBySearchCheckImageView isHidden]);
  }];
  RAC(self.orderByRSSICheckImageView,hidden) = [[orderByRSSIContentViewTap rac_gestureSignal] map:^id(id x) {
    return @(![self.orderByRSSICheckImageView isHidden]);
  }];
  RAC(self.orderByNameCheckImageView,hidden) = [[orderByNameContentViewTap rac_gestureSignal] map:^id(id x) {
    return @(![self.orderByNameCheckImageView isHidden]);
  }];
  
  
}

@end
