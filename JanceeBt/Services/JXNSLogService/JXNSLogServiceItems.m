//
//  JXNSLogServiceItems.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXNSLogServiceItems.h"
#import "JXNSLogServiceToFileManage.h"

@interface JXNSLogFilePackage ()

@property (nonatomic, copy) NSString *relativePath;

@property (nonatomic, copy) NSString *name;

@end



@implementation JXNSLogFilePackage

- (instancetype)initWithRelativePath:(NSString*)path {
  self = [super init];
  if(self) {
    self.relativePath = path;
    NSRange range = [path rangeOfString:@"JXNSLogService_Log/"];
    self.name = [path substringFromIndex:range.location + range.length];
  }
  return self;
}

- (NSString*)getName {
  return self.name;
}

- (NSString*)getContent {
  return [JXNSLogServiceToFileManage readLogWithPath:self.relativePath];
}


@end
