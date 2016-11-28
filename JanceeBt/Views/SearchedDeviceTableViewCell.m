//
//  SearchedDeviceTableViewCell.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/14.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "SearchedDeviceTableViewCell.h"

@implementation SearchedDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRssi:(long)rssi {
  self.signalLabel.text = [[NSString alloc] initWithFormat:@"%ld", (long)rssi];
  
  NSString *imageName = @"";
  if(rssi > -30) {
    imageName = @"信号/信号满";
  } else if (rssi > -50) {
    imageName = @"信号/信号中上";
  } else if (rssi > -70) {
    imageName = @"信号/信号中";
  } else if (rssi > -90) {
    imageName = @"信号/信号低";
  } else {
    imageName = @"信号/无信号锁";
  }
  [self.signalImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)setDeviceName:(NSString*)deviceName localName:(NSString*)localName {
  self.nameLabel.text = [[NSString alloc] initWithFormat:@"%@(%@)",deviceName, localName];
}

- (void)setNotify:(NSData*)notify {
  NSString *hexString = [notify hexadecimalString];
  NSMutableString *mutableString = [[NSMutableString alloc] initWithString:hexString != nil ? [notify hexadecimalString] : @""];
  
  //1byte 增加空格
  NSInteger insertIndex = -1;
  while (((NSInteger)[hexString length] - insertIndex - 8) > 0) {
    insertIndex += 9;
    [mutableString insertString:@" " atIndex:insertIndex];
  }
  self.notifyTextView.text = mutableString;
}

- (void)setSearched:(BOOL)searched {
  //self.backgroundColor = searched ? [UIColor whiteColor] : [UIColor grayColor];
}

@end
