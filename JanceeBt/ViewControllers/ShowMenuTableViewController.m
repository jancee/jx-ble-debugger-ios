//
//  ShowMenuTableViewController.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/14.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "ShowMenuTableViewController.h"

@interface ShowMenuTableViewController ()

@property (strong, nonatomic) IBOutlet UIView *nameShowContentView;
@property (strong, nonatomic) IBOutlet UIView *rSSIShowContentView;
@property (strong, nonatomic) IBOutlet UIView *notifyShowContentView;

@property (strong, nonatomic) IBOutlet UIImageView *nameShowCheckImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rSSIShowCheckImageView;
@property (strong, nonatomic) IBOutlet UIImageView *notifyShowCheckImageView;



@property (strong, nonatomic) NSString *ss;
@property (strong, nonatomic) NSString *dd;

@end





@implementation ShowMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  @weakify(self);
  
  //sp更新视图
  //  [nameShowChannel subscribeNext:^(id x) {
  //    self.nameShowCheckImageView.hidden = [x boolValue];
  //  }];
  
  
  //点击对勾视图处理
  UITapGestureRecognizer *nameShowContentViewTap = [[UITapGestureRecognizer alloc] init];
  UITapGestureRecognizer *rSSIShowContentViewTap = [[UITapGestureRecognizer alloc] init];
  UITapGestureRecognizer *notifyShowContentViewTap = [[UITapGestureRecognizer alloc] init];
  [self.nameShowContentView   addGestureRecognizer:nameShowContentViewTap];
  [self.rSSIShowContentView   addGestureRecognizer:rSSIShowContentViewTap];
  [self.notifyShowContentView addGestureRecognizer:notifyShowContentViewTap];
  RAC(self.nameShowCheckImageView,hidden) = [[nameShowContentViewTap rac_gestureSignal] map:^id(id x) {
    @strongify(self);
    return @(![self.nameShowCheckImageView isHidden]);
  }];
  RAC(self.rSSIShowCheckImageView,hidden) = [[rSSIShowContentViewTap rac_gestureSignal] map:^id(id x) {
    @strongify(self);
    return @(![self.rSSIShowCheckImageView isHidden]);
  }];
  RAC(self.notifyShowCheckImageView,hidden) = [[notifyShowContentViewTap rac_gestureSignal] map:^id(id x) {
    @strongify(self);
    return @(![self.notifyShowCheckImageView isHidden]);
  }];
  
  
}

@end
