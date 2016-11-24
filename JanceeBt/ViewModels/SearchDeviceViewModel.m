//
//  SearchDeviceViewModel.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/14.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "SearchDeviceViewModel.h"


@interface SearchDeviceViewModel ()

@property (nonatomic, strong) NSMutableArray              *searchedDeviceArray;       //搜到的设备

@property (nonatomic, strong) NSMutableArray<NSString*>   *fixedDeviceUuidArray;      //置顶的设备uuid array

@property (nonatomic, strong) NSMutableArray<NSString*>   *connectedDeviceUuidArray;  //已连接的设备uuid array

@end







@implementation SearchDeviceViewModel

static id<SearchDeviceViewDelegate> myVC;


- (instancetype)init {
  self = [super init];
  if(self != nil) {
    self.searchedDeviceArray      = [[NSMutableArray alloc] init];
    self.fixedDeviceUuidArray     = [[NSMutableArray alloc] init];
    self.connectedDeviceUuidArray = [[NSMutableArray alloc] init];
    
    
  }
  return self;
}



- (instancetype)initWithVC:(id<SearchDeviceViewDelegate>)VC {
  self = [self init];
  if(self != nil) {
    myVC = VC;
  }
  return self;
}



@end
