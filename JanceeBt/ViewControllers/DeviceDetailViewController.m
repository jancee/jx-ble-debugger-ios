//
//  DeviceDetailViewController.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/28.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "ShowDeviceCharacterTableViewCell.h"

@interface DeviceDetailViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem  *returnButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem  *disconnectAndReturnButtonItem;
@property (strong, nonatomic) IBOutlet UIButton         *disconnectButtonItem;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *uuidLabel;

@property (strong, nonatomic) IBOutlet UITextView *notifyTextView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end







@implementation DeviceDetailViewController

static JXBTServiceConnecter *connecter;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.uuidLabel.text       = self.deviceItem.uuid;
  self.deviceNameLabel.text = self.deviceItem.deviceName;
  
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  connecter = [[[[[[[JXBTServiceConnecter getConnecterWithUuid:self.deviceItem.uuid]
                    setConnectedBlock:^{
                      self.statusLabel.text           = @"已连接";
                      [self.disconnectButtonItem setTitle:@"断开" forState:UIControlStateNormal];
                    }]
                   setSearchedServiceBlock:^(NSDictionary *dict) {
                     [self.tableView reloadData];
                   }]
                  setSearchedCharacterBlock:^(NSDictionary *dict) {
                    [self.tableView reloadData];
                  }]
                 setDataDidBlock:^(NSDictionary *dict) {
                   NSLog(@"%@",dict);
                   
                   //更新tableview
                   [self.tableView reloadData];
                 }]
                setDisconnectBlock:^{
                  self.statusLabel.text            = @"未连接";
                  [self.disconnectButtonItem setTitle:@"连接" forState:UIControlStateNormal];
                  
                  
                  [self.tableView reloadData];
                }]
               connect];
  
}


- (IBAction)returnLastView:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)returnAndDisconnect:(id)sender {
  [self returnLastView:nil];
  if([self.disconnectButtonItem.titleLabel.text isEqualToString:@"断开"]) {
    [self disconnect:nil];
  }
}

- (IBAction)disconnect:(id)sender {
  if([self.disconnectButtonItem.titleLabel.text isEqualToString:@"断开"]) {
    [connecter disconnect];
  } else {
    [connecter connect];
  }
}

#pragma mark - tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ShowDeviceCharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowDeviceCharacterTableViewCell"
                                                                           forIndexPath:indexPath];
  
  //uuid
  CBCharacteristic *aimCharacter =
  [((CBService*)[self.deviceItem.peripheral services][indexPath.section]) characteristics][indexPath.row];
  
  cell.textLabel.text       = aimCharacter.UUID.UUIDString;
  
  
  //属性显示
  NSMutableString *propertyString = [[NSMutableString alloc] init];
  CBCharacteristicProperties properties = aimCharacter.properties;
  if((properties & CBCharacteristicPropertyBroadcast) != 0) {
    [propertyString appendString:@"广播|"];
  }
  if((properties & CBCharacteristicPropertyRead) != 0) {
    [propertyString appendString:@"读|"];
  }
  if((properties & CBCharacteristicPropertyWriteWithoutResponse) != 0) {
    [propertyString appendString:@"无响应写|"];
  }
  if((properties & CBCharacteristicPropertyWrite) != 0) {
    [propertyString appendString:@"写|"];
  }
  if((properties & CBCharacteristicPropertyNotify) != 0) {
    [propertyString appendString:@"通告|"];
  }
  if((properties & CBCharacteristicPropertyIndicate) != 0) {
    [propertyString appendString:@"表明|"];
  }
  if((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) != 0) {
    [propertyString appendString:@"认证的写|"];
  }
  if((properties & CBCharacteristicPropertyExtendedProperties) != 0) {
    [propertyString appendString:@"额外属性|"];
  }
  if((properties & CBCharacteristicPropertyNotifyEncryptionRequired) != 0) {
    [propertyString appendString:@"需加密通告|"];
  }
  if((properties & CBCharacteristicPropertyIndicateEncryptionRequired) != 0) {
    [propertyString appendString:@"需加密表明|"];
  }
  cell.detailTextLabel.text = propertyString;
  
  
  
  
  return cell;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[((CBService*)[self.deviceItem.peripheral services][section]) characteristics] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //取消选择
  [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.deviceItem.peripheral services] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [self.deviceItem.peripheral services][section].UUID.UUIDString;
}


@end
