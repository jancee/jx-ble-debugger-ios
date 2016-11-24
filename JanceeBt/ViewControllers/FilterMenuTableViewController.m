//
//  FilterMenuTableViewController.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/14.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "FilterMenuTableViewController.h"

@interface FilterMenuTableViewController ()

@property (strong, nonatomic) IBOutlet UIView *rSSIMinContentView;
@property (strong, nonatomic) IBOutlet UIImageView *rSSIMinCheckImageView;
@property (strong, nonatomic) IBOutlet UITextField *rSSIMinTextField;

@property (strong, nonatomic) IBOutlet UIView *rSSIMaxContentView;
@property (strong, nonatomic) IBOutlet UIImageView *rSSIMaxCheckImageView;
@property (strong, nonatomic) IBOutlet UITextField *rSSIMaxTextField;

@property (strong, nonatomic) IBOutlet UIView *nameContainedContentView;
@property (strong, nonatomic) IBOutlet UIImageView *nameContainedImageView;
@property (strong, nonatomic) IBOutlet UITextField *nameContainedTextField;

@property (strong, nonatomic) IBOutlet UIView *nameExcludeContentView;
@property (strong, nonatomic) IBOutlet UIImageView *nameExcludeImagediew;
@property (strong, nonatomic) IBOutlet UITextField *nameExcludeTextField;


@property (strong, nonatomic) IBOutlet UIView *notifyContainContentView;
@property (strong, nonatomic) IBOutlet UIImageView *notifyContainImageView;
@property (strong, nonatomic) IBOutlet UITextField *notifyContainTextField;

@end

@implementation FilterMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //绑定SP与输入内容
  RACChannelTerminal *spRSSIMinChannel        = [[NSUserDefaults standardUserDefaults]
                                                 rac_channelTerminalForKey:@"SearchedDevice_Filter_RSSIMin"];
  RACChannelTerminal *spRSSIMaxChannel        = [[NSUserDefaults standardUserDefaults]
                                                 rac_channelTerminalForKey:@"SearchedDevice_Filter_RSSIMax"];
  RACChannelTerminal *spNameContainedChannel  = [[NSUserDefaults standardUserDefaults]
                                                 rac_channelTerminalForKey:@"SearchedDevice_Filter_NameContained"];
  RACChannelTerminal *spNameExcludeChannel    = [[NSUserDefaults standardUserDefaults]
                                                 rac_channelTerminalForKey:@"SearchedDevice_Filter_NameExclude"];
  RACChannelTerminal *spNotifyContainChannel  = [[NSUserDefaults standardUserDefaults]
                                                 rac_channelTerminalForKey:@"SearchedDevice_Filter_NotifyContain"];
  RACChannelTerminal *tfRSSIMinChannel        = [self.rSSIMinTextField rac_newTextChannel];
  RACChannelTerminal *tfRSSIMaxChannel        = [self.rSSIMaxTextField rac_newTextChannel];
  RACChannelTerminal *tfNameContainedChannel  = [self.nameContainedTextField rac_newTextChannel];
  RACChannelTerminal *tfNameExcludeChannel    = [self.nameExcludeTextField rac_newTextChannel];
  RACChannelTerminal *tfNotifyContainChannel  = [self.notifyContainTextField rac_newTextChannel];
  [spRSSIMinChannel subscribe:tfRSSIMinChannel];
  [tfRSSIMinChannel subscribe:spRSSIMinChannel];
  [spRSSIMaxChannel subscribe:tfRSSIMaxChannel];
  [tfRSSIMaxChannel subscribe:spRSSIMaxChannel];
  [spNameContainedChannel subscribe:tfNameContainedChannel];
  [tfNameContainedChannel subscribe:spNameContainedChannel];
  [spNameExcludeChannel subscribe:tfNameExcludeChannel];
  [tfNameExcludeChannel subscribe:spNameExcludeChannel];
  [spNotifyContainChannel subscribe:tfNotifyContainChannel];
  [tfNotifyContainChannel subscribe:spNotifyContainChannel];
  
  
  //对勾显示隐藏逻辑
  NSNumber* (^checkImageHiddenLogicBlock)(NSString *string) = ^NSNumber*(NSString *string) {
    return @(!(string != nil && ![string isEqualToString:@""]));
  };
  RAC(self.rSSIMinCheckImageView,hidden)  = [self.rSSIMinTextField.rac_textSignal       map:checkImageHiddenLogicBlock];
  RAC(self.rSSIMaxCheckImageView,hidden)  = [self.rSSIMaxTextField.rac_textSignal       map:checkImageHiddenLogicBlock];
  RAC(self.nameContainedImageView,hidden) = [self.nameContainedTextField.rac_textSignal map:checkImageHiddenLogicBlock];
  RAC(self.nameExcludeImagediew,hidden)   = [self.nameExcludeTextField.rac_textSignal   map:checkImageHiddenLogicBlock];
  RAC(self.notifyContainImageView,hidden) = [self.notifyContainTextField.rac_textSignal map:checkImageHiddenLogicBlock];
  
  
  
}



@end
