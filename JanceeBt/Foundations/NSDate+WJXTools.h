//
//  NSDate+WJXTools.h
//  balanceCar
//
//  Created by jancee wang on 16/9/6.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WJXTools)


/**
 *  @brief 将NSDate转换为yyyy-MM-dd
 *
 *  @return yyyy-MM-dd
 */
- (NSString*)dateFormatyyyyMMdd;





/**
 *  @brief 将NSString按照某种格式，变成NSDate
 *
 *  @param dateStr
 *  @param formatStr
 *
 *  @return
 */
+ (NSDate*)dateFromString:(NSString*)dateStr withDateFormat:(NSString*)formatStr;


@end
