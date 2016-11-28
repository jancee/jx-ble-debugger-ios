//
//  JXNSLogService.h
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXNSLogServiceItems.h"



@interface JXNSLogService : NSObject

+ (instancetype)sharedInstance;


/**
 将NSLog指向文件
 
 (模拟器不保存，连接xocde不保存)
 */
- (void)redirectNSlogToFile;


/**
 获取所有日志文件Package
 */
- (NSArray<JXNSLogFilePackage*>*)getAllJXNSLogFilePackage;


/**
 设置异常处理方法 ———— 邮件发送
 */
- (void)installCrashSendMailAddress:(NSString*)mailAddress
                          mailTitle:(NSString*)mailTitle
                            mailTip:(NSString*)mailTip;

@end
