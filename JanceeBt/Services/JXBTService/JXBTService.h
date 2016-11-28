//
//  JXBTService.h
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/7.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "JXBTServiceItems.h"
#import "JXBTServiceScannner.h"
#import "JXBTServiceConnecter.h"

/***********************ScannedDeviceRACSubjectDict***************************/


typedef enum {
  JXBTServiceDataDidSubjectType_DiscoverIncludedServices  = 0,    //已找到服务中包含的服务
  JXBTServiceDataDidSubjectType_UpdateNotificationState,          //已更新蓝牙广播
  JXBTServiceDataDidSubjectType_DiscoverDescriptors,              //已发现Descriptors
  JXBTServiceDataDidSubjectType_UpdateValue,                      //已更新数据
  JXBTServiceDataDidSubjectType_WriteValueForDescriptor,          //已写入数据到Descriptor
  JXBTServiceDataDidSubjectType_WriteValueForCharacteristic,      //已写入数据到Characteristic
} JXBTServiceDataDidSubjectType;

typedef enum {
  JXBTServiceDeviceSignalEvenType_SearchBLE       = 0 ,
  JXBTServiceDeviceSignalEvenType_Connected           ,
  JXBTServiceDeviceSignalEvenType_FailToConnect       ,
  JXBTServiceDeviceSignalEvenType_Disconnect          ,
  JXBTServiceDeviceSignalEvenType_SearchService       ,
  JXBTServiceDeviceSignalEvenType_SearchCharacter     ,
} JXBTServiceDeviceSignalEvenType;

/***************************JXBTService*******************************/



@interface JXBTService : NSObject
<
CBCentralManagerDelegate,
CBPeripheralDelegate,
JXBTServiceScannerService
>






/***********  建议使用connecter里的回调，而不要直接订阅这几个  *************/
/**
 设备断开或者连接失败
 sendNext
 */
@property (atomic, strong, readonly) RACSubject  *deviceInterruptRACSubject;
/**
 设备连接完成
 sendNext
 */
@property (atomic, strong, readonly) RACSubject  *deviceConnectRACSubject;
/**
 搜到服务
 sendNext
 */
@property (atomic, strong, readonly) RACSubject  *searchCharacterRACSubject;
/**
 搜到特征
 sendNext
 */
@property (atomic, strong, readonly) RACSubject  *searchServiceRACSubject;
/**
 蓝牙数据更新
 sendNext
 */
@property (atomic, strong, readonly) RACSubject  *dataDidSubject;
/*******************************************************************/












/*************** 公开方法 ****************/
/**
 SharedInstance
 */
+ (instancetype)sharedInstance;

/**
 断开指定设备
 
 @param uuid 设备BleUuid
 @return 断开至少一个设备
 */
- (BOOL)disconnectOneDevice:(NSString*)uuid;

/**
 获取指定uuid设备的服务和特征信息
 */
- (NSArray*)getServicesAndCharacters:(NSString*)uuid;


/**
 发送数据给指定设备的指定特征
 
 @param sendData      要发送的数据
 @param bleUuid       设备BleUuid
 @param characterUuid 特征Uuid
 @param withResponse  是否需要写响应
 */
- (BOOL)sendDataToSingleDevice:(NSData*)sendData
                       bleUuid:(NSString*)bleUuid
            characteristicUuid:(NSString*)characterUuid
                  withResponse:(BOOL)withResponse;

/**
 发送数据给所有蓝牙层已达成协议的设备的指定特征
 
 @param sendData      数据
 @param characterUuid 特征
 @param withResponse  是否需要写响应
 @return 尝试发送给多少个设备
 */
- (NSUInteger)sendDataToAllBtLayerHandshakedDevice:(NSData*)sendData
                                characteristicUuid:(NSString*)characterUuid
                                      withResponse:(BOOL)withResponse;
/*********************************************/






































/************** 内部方法，不要使用 ***************/
- (CBCentralManager*)getCentralManager;

/**
 连接指定一个设备
 
 @param uuid 设备BleUuid
 @return 是否去连接了
 */
- (instancetype)connectDevice:(NSString*)uuid;

/**
 连接多个设备
 
 @param uuidArray 设备uuid array
 @return 尝试去连接的设备数量
 */
- (instancetype)connectManyDevice:(NSArray<NSString*>*)uuidArray;

/**
 断开所有设备
 
 @return 尝试去断开的设备数量
 */
- (NSUInteger)disconnectAllDevice;


/**
 获取指定uuid设备的detail

 @param uuid 设备UUID
 @return detail
 */
- (JXBTDeviceDetail*)getItemFromDeviceDetailsArray:(NSString*)uuid;

@end

/**********************************************/




