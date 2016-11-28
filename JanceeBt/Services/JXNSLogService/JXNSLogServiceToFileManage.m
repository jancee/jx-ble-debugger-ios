//
//  JXNSLogServiceToFileManage.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXNSLogServiceToFileManage.h"

NSString *const HandleLogPathsFileName = @"JXNSLogService_Log/_HandleLogPathsFileName_";

@implementation JXNSLogServiceToFileManage

#pragma mark - 操作
#pragma mark 读取操作日志内容
+ (NSString*)readLogWithPath:(NSString*)relativePath {
  NSArray *documentPaths =
  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  
  NSString *documentLogPath =
  [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:relativePath];
  
  NSData    *logData    = [NSData dataWithContentsOfFile:documentLogPath
                                                 options:NSDataReadingUncached error:nil];
  NSString  *logString  = [[NSString alloc]initWithData:logData
                                               encoding:NSUTF8StringEncoding];
  return logString;
}

#pragma mark 添加本次启动app的操作日志路径
+ (void)addLog:(NSString*)relativePath {
  //读取持久化array
  NSMutableArray *tempArray = [[JXNSLogServiceToFileManage getPersistentInFilePath:HandleLogPathsFileName] mutableCopy];
  //array中添加本次的路径
  [tempArray addObject:relativePath];
  //存储持久化array
  [self savePersistent:tempArray inFilePath:HandleLogPathsFileName];
}

#pragma mark 获取所有操作日志路径
+ (NSArray<NSString*>*)getAllRelativePaths {
  return [JXNSLogServiceToFileManage getPersistentInFilePath:HandleLogPathsFileName];
}



#pragma mark - 数据处理
#pragma mark 获取持久化
+ (NSArray*)getPersistentInFilePath:(NSString*)fileName {
  NSArray *outData;
  
  NSArray *list = nil;
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
  NSData *data = [NSData dataWithContentsOfFile:path];
  
  list = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  outData = list;
  if(outData == nil) {
    outData = [[NSArray alloc] init];
  }
  return outData;
}

#pragma mark 保存持久化
+ (BOOL)savePersistent:(NSArray*)saveArray
            inFilePath:(NSString*)fileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
  
  BOOL result = [NSKeyedArchiver archiveRootObject:saveArray toFile:path];
  return result;
}



@end
