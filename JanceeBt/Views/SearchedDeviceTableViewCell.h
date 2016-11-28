//
//  SearchedDeviceTableViewCell.h
//  JanceeBt
//
//  Created by jancee wang on 2016/11/14.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchedDeviceTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView  *signalImageView;
@property (strong, nonatomic) IBOutlet UILabel      *signalLabel;

@property (strong, nonatomic) IBOutlet UILabel      *serviceCountLabel;

@property (strong, nonatomic) IBOutlet UITextView   *notifyTextView;
@property (strong, nonatomic) IBOutlet UIButton     *topButton;
@property (strong, nonatomic) IBOutlet UILabel      *nameLabel;


- (void)setRssi:(long)rssi;

- (void)setDeviceName:(NSString*)deviceName localName:(NSString*)localName;

- (void)setNotify:(NSData*)notify;

- (void)setSearched:(BOOL)searched;

@end
