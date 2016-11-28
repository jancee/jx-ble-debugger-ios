//
//  JXBTServiceConnecter.h
//  JanceeBt
//
//  Created by jancee wang on 2016/11/21.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  JXBTServiceConnecter_SendDataIntervalMode_NoLimit                 = 0,  //无限制，数据来一个发一个
  JXBTServiceConnecter_SendDataIntervalMode_IgnoreNewerInInterval     ,   //在时间间隔内，忽略所有新来的数据
  JXBTServiceConnecter_SendDataIntervalMode_SendNewestInInterval      ,   //在时间间隔内，保留最新来的数据
} JXBTServiceConnecter_SendDataIntervalMode;



@interface JXBTServiceConnecter : NSObject

+ (instancetype)getConnecterWithUuid:(NSString*)uuid;

- (instancetype)connect;
- (instancetype)disconnect;

- (instancetype)sendData:(NSData*)data
         toCharacterUuid:(NSString*)uuid;

- (instancetype)sendManyData:(NSArray<NSData*>*)dataArray
             toCharacterUuid:(NSString*)uuid
                    interval:(CGFloat)second;

@end
