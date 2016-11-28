//
//  JXNSLogServiceItems.h
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXNSLogFilePackage : NSObject
- (instancetype)initWithRelativePath:(NSString*)path;


/**
 获取日志名称
 */
- (NSString*)getName;


/**
 获取日志内容
 */
- (NSString*)getContent;


@end
