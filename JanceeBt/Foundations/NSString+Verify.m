//
//  NSString+Verify.m
//  balanceCar
//
//  Created by jancee wang on 16/9/6.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "NSString+Verify.h"

@implementation NSString (Verify)

#pragma mark 检查是否是有效邮箱
- (BOOL)isValidateEmail {
  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
  return[emailTest evaluateWithObject:self];
}















@end
