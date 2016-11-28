//
//  JXNSLogService.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXNSLogService.h"
#import "JXNSLogServiceToFileManage.h"

@interface JXNSLogService ()

@property (nonatomic, copy) NSString *mailAddress;
@property (nonatomic, copy) NSString *mailTitle;
@property (nonatomic, copy) NSString *mailTip;

@end




@implementation JXNSLogService

static JXNSLogService  *Instance;

NSString *simpleLogFilePath;

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^ {
    Instance = [[JXNSLogService alloc] init];
  });
  return Instance;
}

/**
 将NSLog指向文件
 
 (模拟器不保存，连接xocde不保存)
 */
- (void)redirectNSlogToFile {
  //如果已经连接Xcode则不输出到文件
  if(isatty(STDOUT_FILENO)) {
    return;
  }
  //在模拟器不保存到文件中
  UIDevice *device = [UIDevice currentDevice];
  if([[device model] hasSuffix:@"Simulator"]) {
    return;
  }
  
  //创建（如果不存在）保存日志用的Log文件夹，并生成路径
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *logDirectory = [[paths objectAtIndex:0]
                            stringByAppendingPathComponent:@"JXNSLogService_Log"];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
  if (!fileExists) {
    [fileManager createDirectoryAtPath:logDirectory
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
  }
  
  //生成本次启动的日志名
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
  NSString *dateStr = [formatter stringFromDate:[NSDate date]];
  
  //拼接成完整的日志文件路径，并将NSLog输出转向该路径
  simpleLogFilePath = [logDirectory stringByAppendingFormat:@"/%@.log",dateStr];
  freopen([simpleLogFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
  freopen([simpleLogFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
  
  //向文件管理中，记录这个路径
  [JXNSLogServiceToFileManage
   addLog:[[NSString alloc] initWithFormat:@"JXNSLogService_Log/%@.log",dateStr]];
}

/**
 获取所有日志文件Package
 */
- (NSArray<JXNSLogFilePackage*>*)getAllJXNSLogFilePackage {
  NSArray         *getLogs = [JXNSLogServiceToFileManage getAllRelativePaths];
  NSMutableArray  *returnArray = [[NSMutableArray alloc] init];
  
  for (NSString* relativePath in getLogs) {
    JXNSLogFilePackage *package = [[JXNSLogFilePackage alloc] initWithRelativePath:relativePath];
    [returnArray addObject:package];
  }
  
  return [returnArray copy];
}

/**
 设置异常处理方法 ———— 邮件发送
 */
- (void)installCrashSendMailAddress:(NSString*)mailAddress
                          mailTitle:(NSString*)mailTitle
                            mailTip:(NSString*)mailTip {
  self.mailAddress  = mailAddress;
  self.mailTitle    = mailTitle;
  self.mailTip      = mailTip;
  NSSetUncaughtExceptionHandler(&UncaughtExceptionHandlerByMail);
}


/**
 *  @brief 邮件发送 异常处理
 */
void UncaughtExceptionHandlerByMail(NSException* exception) {
  NSString* name = [ exception name ];
  NSString* reason = [ exception reason ];
  NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
  NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; //将调用栈拼成输出日志的字符串
  for ( NSString* item in symbols )
  {
    [ strSymbols appendString: item ];
    [ strSymbols appendString: @"\r\n" ];
  }
  
  //将crash日志保存到Document目录下的Log文件夹下
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *logDirectory =
  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"JXNSLogService_Log"];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:logDirectory]) {
    [fileManager createDirectoryAtPath:logDirectory
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
  }
  
  NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"UncaughtException.log"];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *dateStr = [formatter stringFromDate:[NSDate date]];
  
  NSString *crashString = [NSString stringWithFormat:
                           @"<- %@ ->[ Uncaught Exception ]\r\n"
                           @"Name: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n",
                           dateStr, name, reason, strSymbols];
  
  //把错误日志写到文件中
  if (![fileManager fileExistsAtPath:logFilePath]) {
    [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
  }else{
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    [outFile seekToEndOfFile];
    [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
    [outFile closeFile];
  }
  
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  
  //读取操作日志信息
  NSData *simpleLogData = [NSData dataWithContentsOfFile:simpleLogFilePath
                                                 options:NSDataReadingUncached error:nil];
  NSString *simpleLogString = [[NSString alloc]initWithData:simpleLogData
                                                   encoding:NSUTF8StringEncoding];
  
  //把错误日志发送到邮箱
  NSString *urlStr = [[NSString alloc] init];
  urlStr = [urlStr stringByAppendingString:@"mailto:"];
  urlStr = [urlStr stringByAppendingString:[JXNSLogService sharedInstance].mailAddress];//邮箱地址
  urlStr = [urlStr stringByAppendingString:@"?subject="];
  urlStr = [urlStr stringByAppendingString:[JXNSLogService sharedInstance].mailTitle];  //邮件标题
  urlStr = [urlStr stringByAppendingString:@"&body="];
  urlStr = [urlStr stringByAppendingString:[JXNSLogService sharedInstance].mailTip];    //用户提示说明
  urlStr = [urlStr stringByAppendingString:@"<br><br><br><br><br>"];
  //手机信息
  urlStr = [urlStr stringByAppendingFormat:
            @"$$$$$$$$$手机信息$$$$$$$$$<br>%@<br>$$$$$$$$$$$$$$$$$$$$$$$$$$$$<br>",infoDictionary];
  //错误信息
  urlStr = [urlStr stringByAppendingFormat:@"$$$$$$$$$错误信息$$$$$$$$$<br>%@<br>$$$$$$$$$$$$$$$$$$$$$$$$$$$$<br>",crashString];
  //操作日志
  urlStr = [urlStr stringByAppendingFormat:@"$$$$$$$$$操作日志$$$$$$$$$<br>%@<br>$$$$$$$$$$$$$$$$$$$$$$$$$$$$<br>",simpleLogString];
  NSURL *url = [NSURL URLWithString:[urlStr
                                     stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  [[UIApplication sharedApplication] openURL:url];
}



@end






