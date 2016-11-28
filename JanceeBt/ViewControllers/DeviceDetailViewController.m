//
//  DeviceDetailViewController.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/28.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "DeviceDetailViewController.h"

@interface DeviceDetailViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *returnButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *disconnectAndReturnButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *disconnectButtonItem;


@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *uuidLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end







@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
  self.uuidLabel.text       = self.deviceItem.uuid;
  self.deviceNameLabel.text = self.deviceItem.deviceName;
  
  
}



- (IBAction)return:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)returnAndDisconnect:(id)sender {
  
}

- (IBAction)disconnect:(id)sender {
  
}




@end
