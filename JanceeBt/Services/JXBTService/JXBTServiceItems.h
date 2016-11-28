//
//  JXBTServiceItems.h
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import <Foundation/Foundation.h>




/******************************************************************************************/

typedef enum {
  JXBTDeviceConnectStatus_NoConnect         = 0,
  JXBTDeviceConnectStatus_Connecting,
  JXBTDeviceConnectStatus_Connected,
} JXBTDeviceConnectStatus;


typedef enum {
  JXBTDeviceBtProcessSubjectType_FoundDevice          = 0,
  JXBTDeviceBtProcessSubjectType_FoundAllCharacter,
  JXBTDeviceBtProcessSubjectType_NotFoundAllCharacter,
} JXBTDeviceBtProcessSubjectType;

/******************************************************************************************/
/**
 
 */
@protocol JXBTDeviceDetail <NSObject>
@end
@interface JXBTDeviceDetail : NSObject <JXBTDeviceDetail>

/**
 蓝牙模型
 */
@property (atomic, strong)        CBPeripheral                       *peripheral;


/**
 连接状态
 */
@property (atomic)                JXBTDeviceConnectStatus            connectStatus;


/**
 服务array
 */
@property (atomic, strong)        NSMutableArray<CBService*>         *serviceArray;


/**
 特征array
 */
@property (atomic, strong)        NSMutableArray<CBCharacteristic*>  *characterArray;

/**
 指定特征UUID，寻找特征

 @param characterUuid 特征UUID
 @return 特征
 */
- (CBCharacteristic*)findCBCharacteristic:(NSString*)characterUuid;


/**
 指定服务UUID，寻找服务

 @param serviceUuid 服务UUID
 @return 服务
 */
- (CBService*)findCBService:(NSString*)serviceUuid;

@end


/******************************************************************************************/

/******************************************************************************************/

@interface JXBTDeviceSearched : NSObject

@property (nonatomic, strong, readonly) NSString *uuid;         //设备UUID
@property (nonatomic, strong, readonly) NSString *deviceName;   //设备名
@property (nonatomic, strong, readonly) NSString *localName;    //设备搜索响应名
@property (nonatomic, strong, readonly) NSData   *advData;      //自定义广播
@property (nonatomic, strong, readonly) NSNumber *rssi;         //信号强度


@property (nonatomic, strong, readonly) CBPeripheral *peripheral; //Peripheral


//初始化
- (instancetype)initWithUuid:(NSString*)uuid
                  DeviceName:(NSString*)deviceName
                         localName:(NSString*)localName
                           advData:(NSData*)advData
                              rssi:(NSNumber*)rssi
                  peripheral:(CBPeripheral*)peripheral;

@end


/******************************************************************************************/

/******************************************************************************************/

/******************************************************************************************/

/******************************************************************************************/

/******************************************************************************************/

/******************************************************************************************/

/******************************************************************************************/





































