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

/**
 获取到一个指定设备Uuid的连接器

 @param uuid 设备Uuid
 @return 连接器
 */
+ (instancetype)getConnecterWithUuid:(NSString*)uuid;


/**
 断开连接
 */
- (instancetype)setDisconnectBlock:(void (^)())block;



/**
 已连接
 */
- (instancetype)setConnectedBlock:(void (^)())block;


/**
 数据改变
 */
- (instancetype)setDataDidBlock:(void (^)(NSDictionary *dict))block;

- (instancetype)setSearchedCharacterBlock:(void (^)(NSDictionary *dict))block;
- (instancetype)setSearchedServiceBlock:(void (^)(NSDictionary *dict))block;
/**
 连接设备

 @return 链式
 */
- (instancetype)connect;


/**
 断开连接设备

 @return 链式
 */
- (instancetype)disconnect;


/**
 设置是否重连

 @param enable 重连？
 @return 链式
 */
- (instancetype)setReconnectListener:(BOOL)enable;


/**
 发送一条数据

 @param data 数据
 @param uuid 设备uuid
 @param response 写响应？
 @return 链式
 */
- (instancetype)sendData:(NSData*)data
         toCharacterUuid:(NSString*)uuid
            withResponse:(BOOL)response;


/**
 发送一堆数据

 @param dataArray 数据array
 @param uuid 设备uuid
 @param second 间隔时间
 @param response 写响应？
 @return 链式
 */
- (instancetype)sendManyData:(NSArray<NSData*>*)dataArray
             toCharacterUuid:(NSString*)uuid
                    interval:(CGFloat)second
                withResponse:(BOOL)response;

@end
