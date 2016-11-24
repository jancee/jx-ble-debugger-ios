//
//  NSDate+WJXTools.m
//  balanceCar
//
//  Created by jancee wang on 16/9/6.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "NSDate+WJXTools.h"

@implementation NSDate (WJXTools)

#pragma mark 将NSDate转换为yyyy-MM-dd
- (NSString*)dateFormatyyyyMMdd
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  NSString *dateStr = [formatter stringFromDate:self];
  return dateStr;
}


#pragma mark 将NSString按照某种格式，变成NSDate
+ (NSDate*)dateFromString:(NSString*)dateStr withDateFormat:(NSString*)formatStr
{
  if (formatStr == nil) {
    formatStr = @"yyyy-MM-dd";
  }
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:formatStr];
  NSDate *date = [formatter dateFromString:dateStr];
  return date;
}




@end
