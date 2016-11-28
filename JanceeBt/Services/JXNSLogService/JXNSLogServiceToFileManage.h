//
//  JXNSLogServiceToFileManage.h
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXNSLogServiceToFileManage : NSObject



/**
 读指定日志内容

 @param relativePath 路径（相对于document）
 @return 日志内容
 */
+ (NSString*)readLogWithPath:(NSString*)relativePath;


/**
 添加一个日志路径

 @param relativePath 路径（相对于document）
 */
+ (void)addLog:(NSString*)relativePath;


/**
 获取所有日志路径

 @return 所有日志路径array
 */
+ (NSArray<NSString*>*)getAllRelativePaths;

@end
