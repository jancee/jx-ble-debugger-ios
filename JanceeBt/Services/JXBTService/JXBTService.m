//
//  JXBTService.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/7.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXBTService.h"




@interface JXBTService ()

@property(nonatomic, strong) NSMutableArray<JXBTDeviceDetail*>   *allDeviceDetails;


/******************/

@end




@implementation JXBTService

static const NSString* logPrefix = @"[JXBTService] -> ";

static JXBTService        *Instance;
static CBCentralManager   *cbCentralManager;


+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^ {
    Instance = [[JXBTService alloc] init];
  });
  return Instance;
}


- (id)init {
  self = [super init]; //获得父类的对象并进行初始化
  if (self) {
    //持有实例处理
    cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                            queue:nil];
    
    //对象初始化
    self.allDeviceDetails               = [[NSMutableArray alloc] init];
    
    //RAC配置
    [self initRAC];
    
  }
  return self;
}

- (CBCentralManager*)getCentralManager {
  return cbCentralManager;
}



#pragma mark - CBCentralManager Basic Method
/**
 连接指定一个设备
 
 @param uuid 设备BleUuid
 @return 是否去连接了
 */
- (instancetype)connectDevice:(NSString*)uuid {
  static CBPeripheral *toPeripheral;
  for (JXBTDeviceDetail *detail in self.allDeviceDetails) {
    if([detail.peripheral.identifier.UUIDString isEqualToString:uuid]) {
      toPeripheral = detail.peripheral;
      break;
    }
  }
  
  if(toPeripheral != nil) {
    JXBTDeviceDetail *aimItem;
    for (JXBTDeviceDetail *forItem in self.allDeviceDetails) {
      if([forItem.peripheral.identifier.UUIDString isEqualToString:uuid]) {
        aimItem = forItem;
        break;
      }
    }
    
    //设置detail状态
    aimItem.connectStatus = JXBTDeviceConnectStatus_Connecting;
    
    toPeripheral.delegate = self;
    //进行连接
    [cbCentralManager connectPeripheral:[toPeripheral copy] options:nil];
  }
  return self;
}


- (void)timeoutTimer:(NSTimer*)t {
  
}


/**
 连接多个设备
 
 @param uuidArray 设备uuid array
 @return 尝试去连接的设备数量
 */
- (instancetype)connectManyDevice:(NSArray<NSString*>*)uuidArray {
  if(uuidArray == nil || [uuidArray count] == 0) {
  }
  else {
    for (NSString *uuid in uuidArray) {
      [self connectDevice:uuid];
    }
  }
  return self;
}

/**
 断开指定设备
 
 @param uuid 设备BleUuid
 @return 断开至少一个设备
 */
- (BOOL)disconnectOneDevice:(NSString*)uuid {
  CBPeripheral *toPeripheral;
  for (JXBTDeviceDetail *detail in self.allDeviceDetails) {
    if([detail.peripheral.identifier.UUIDString isEqualToString:uuid]) {
      toPeripheral = detail.peripheral;
      break;
    }
  }
  
  if(toPeripheral != nil) {
    [cbCentralManager cancelPeripheralConnection:toPeripheral];
    return YES;
  }
  
  return NO;
}

/**
 断开所有设备
 
 @return 尝试去断开的设备数量
 */
- (NSUInteger)disconnectAllDevice {
  NSUInteger findCount = 0;
  for (JXBTDeviceDetail* detail in self.allDeviceDetails) {
    if(detail.peripheral.state != CBPeripheralStateDisconnected) {
      [cbCentralManager cancelPeripheralConnection:detail.peripheral];
      findCount ++;
    }
  }
  return findCount;
}

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
                  withResponse:(BOOL)withResponse {
  JXBTDeviceDetail *aimBleItem = [self getItemFromDeviceDetailsArray:bleUuid];
  if(aimBleItem == nil)
    return NO;
  if (aimBleItem.connectStatus != JXBTDeviceConnectStatus_Connected)
    return NO;
  
  CBCharacteristic *character = [aimBleItem findCBCharacteristic:characterUuid];
  if (character == nil)
    return NO;
  
  [aimBleItem.peripheral writeValue:sendData
                  forCharacteristic:character
                               type:withResponse ? CBCharacteristicWriteWithResponse : CBCharacteristicWriteWithoutResponse];
  return YES;
}


/**
 发送数据给已连接设备的指定特征
 
 @param sendData      数据
 @param characterUuid 特征
 @param withResponse  是否需要写响应
 @return 尝试发送给多少个设备
 */
- (NSUInteger)sendDataToAllBtLayerHandshakedDevice:(NSData*)sendData
                                characteristicUuid:(NSString*)characterUuid
                                      withResponse:(BOOL)withResponse {
  NSUInteger findCount = 0;
  for (JXBTDeviceDetail *btLayerDevice in self.allDeviceDetails) {
    if(btLayerDevice.connectStatus == JXBTDeviceConnectStatus_Connected) {
      CBCharacteristic *character = [btLayerDevice findCBCharacteristic:characterUuid];
      if(character != nil) {
        [btLayerDevice.peripheral
         writeValue:sendData
         forCharacteristic:character
         type:withResponse ? CBCharacteristicWriteWithResponse : CBCharacteristicWriteWithoutResponse];
        
        findCount++;
      }
    }
  }
  return findCount;
}


/**
 获取指定uuid设备的服务和特征信息
 
 */
- (NSArray*)getServicesAndCharacters:(NSString*)uuid {
  JXBTDeviceDetail *item = [self getItemFromDeviceDetailsArray:uuid];
  
  NSMutableArray *returnArray = [[NSMutableArray alloc] init];
  for (CBService *forService in item.peripheral.services) {
    NSDictionary *addDict = @{
                              @"uuid"       : forService.UUID.UUIDString,
                              @"character"  : forService.characteristics
                              };
    [returnArray addObject:addDict];
  }
  return returnArray;
}





#pragma mark - 数据处理
/**
 从allDeviceDetails找到指定设备uuid的Item
 
 @param uuid 设备uuid
 @return JXBTBtLayerDevice
 */
- (JXBTDeviceDetail*)getItemFromDeviceDetailsArray:(NSString*)uuid {
  for (JXBTDeviceDetail *btLayerDevice in self.allDeviceDetails) {
    if([btLayerDevice.peripheral.identifier.UUIDString isEqualToString:uuid]) {
      return btLayerDevice;
    }
  }
  return nil;
}

#pragma mark - RAC
/**
 初始化RAC相关信号，以及相关订阅
 */
- (void)initRAC {
  _dataDidSubject                 = [RACSubject subject];
  _deviceInterruptRACSubject      = [RACSubject subject];
  _deviceConnectRACSubject        = [RACSubject subject];
  _searchCharacterRACSubject      = [RACSubject subject];
  _searchServiceRACSubject        = [RACSubject subject];
}


#pragma mark - tools
- (void)log:(NSString*)log {
  NSLog(@"%@",[logPrefix stringByAppendingString:log]);
}


#pragma mark - JXBTServiceScannerService
/**
 Connecter通知我，搜到设备
 
 @param item 设备JXBTDeviceSearchedItem
 */
- (void)tellMeSearchedDevice:(JXBTDeviceSearched *)item {
  BOOL alreadyExist = NO;
  for (JXBTDeviceDetail* forDetail in self.allDeviceDetails) {
    if([item.uuid isEqualToString:forDetail.peripheral.identifier.UUIDString]) {
      alreadyExist = YES;
      break;
    }
  }
  
  //如果搜到的设备不存在，则添加到details
  if(alreadyExist == NO) {
    JXBTDeviceDetail *detail = [[JXBTDeviceDetail alloc] init];
    detail.peripheral = item.peripheral;
    [self.allDeviceDetails addObject:detail];
  }
}




#pragma mark - CBCentralManager delegate
#pragma mark 查询手机蓝牙情况回调
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  switch (central.state) {
    case CBManagerStatePoweredOn:     //蓝牙打开
      break;
    case CBManagerStatePoweredOff:    //蓝牙关闭
      break;
    case CBManagerStateResetting:     //蓝牙重置
      break;
    case CBManagerStateUnknown:       //未知状态
      break;
    case CBManagerStateUnsupported:   //设备不支持
      break;
    case CBManagerStateUnauthorized:  //设备不支持
      break;
    default:
      break;
  }
}

//不能删
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
}

#pragma mark 连接成功回调
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
  [self log:@"didConnectPeripheral"];
  
  //启动搜索服务
  if(peripheral != nil) {
    [peripheral setDelegate:self];      //设置periphral
    [peripheral discoverServices:nil];
  }
  
  //更新item状态为已连接
  JXBTDeviceDetail *detail = [self getItemFromDeviceDetailsArray:peripheral.identifier.UUIDString];
  detail.connectStatus = JXBTDeviceConnectStatus_Connected;
  
  //发送通知
  [_deviceConnectRACSubject sendNext:@{
                                           @"PeripheralUUID"      : peripheral.identifier.UUIDString,
                                           }];
}




#pragma mark - CBPeripheral delegate
#pragma mark 连接失败/断开回调
- (void)connectInterruptPeripheral:(CBPeripheral *)peripheral {
  if(peripheral == nil)
    return;
  
  for (JXBTDeviceDetail *detail in [self.allDeviceDetails copy]) {
    if([detail.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
      detail.connectStatus = JXBTDeviceConnectStatus_NoConnect;
      break;
    }
  }
  [self.deviceInterruptRACSubject sendNext:peripheral];
}
- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error{
  
  [self log:@"didFailToConnectPeripheral"];
  [self connectInterruptPeripheral:peripheral];
}
- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error {
  
  [self log:@"didDisconnectPeripheral"];
  [self connectInterruptPeripheral:peripheral];
}

#pragma mark 搜索服务结束回调
/**
 *  搜索服务结束回调
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {
  //异常处理
  if(peripheral == nil)
    return;
  if(error != nil)
    [cbCentralManager cancelPeripheralConnection:peripheral];
  
  //开始搜索每个服务中的特征
  for (CBService *search in peripheral.services) {
    [peripheral discoverCharacteristics:nil forService:search];
  }
  
}

#pragma mark 搜索特征结束回调
/**
 *  搜索特征结束回调
 */
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
  //异常处理
  if(peripheral == nil)
    return;
  if(error != nil)
    [cbCentralManager cancelPeripheralConnection:peripheral];
  
  //查找DetailsArray中该设备item
  JXBTDeviceDetail *detail = [self getItemFromDeviceDetailsArray:peripheral.identifier.UUIDString];
  if(detail == nil)
    return;
  
  //在item中寻找该service是否存在，不存在就添加进去
  BOOL findService = NO;
  for (CBService *forService in detail.serviceArray) {
    if([forService.UUID.UUIDString isEqualToString:service.UUID.UUIDString]) {
      findService = YES;
      break;
    }
  }
  if(!findService) {
    [detail.serviceArray addObject:service];
  }
  
  //在item中寻找character是否存在，不存在就添加进去
  for (CBCharacteristic *forC in [service characteristics]) {
    BOOL findC = NO;
    for (CBCharacteristic *forDetailC in [detail.characterArray copy]) {
      if([forDetailC.UUID.UUIDString isEqualToString:forC.UUID.UUIDString]) {
        findC = YES;
        break;
      }
      if(!findC) {
        [detail.characterArray addObject:forC];
      }
    }
  }
  
  //整理特征array
  NSMutableArray *characterUUIDArray = [[NSMutableArray alloc] init];
  for (CBCharacteristic *forC in [service characteristics]) {
    [characterUUIDArray addObject:forC.UUID.UUIDString];
  }
  
  //sendNext服务   服务
  [_searchServiceRACSubject sendNext:@{
                                       @"PeripheralUUID"      : peripheral.identifier.UUIDString,
                                       @"ServiceUUID"         : service.UUID.UUIDString,
                                       }];
  //sendNext特征    
  [_searchCharacterRACSubject sendNext:@{
                                         @"PeripheralUUID"      : peripheral.identifier.UUIDString,
                                         @"ServiceUUID"         : service.UUID.UUIDString,
                                         @"CharacterUUIDArray"  : characterUUIDArray,
                                         }];
}


#pragma mark 蓝牙接收到数据回调
/**
 *  获取外设发来的数据
 *  不论是read和notify,获取数据都是从这个方法中读取。
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
  if(error != nil)
    return;
  
  [self log:@"获取外设发来的数据"];
  [_dataDidSubject sendNext:@{
                              @"Type"               : @(JXBTServiceDataDidSubjectType_WriteValueForCharacteristic),
                              @"PeripheralUUID"     : peripheral.identifier.UUIDString,
                              @"CharacteristicUUID" : characteristic.UUID.UUIDString,
                              @"Error"              : error
                              }];
}

//写到Characteristic完成
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
  if(error != nil)
    return;
  
  [self log:@"写到Characteristic完成"];
  [_dataDidSubject sendNext:@{
                              @"Type"               : @(JXBTServiceDataDidSubjectType_WriteValueForCharacteristic),
                              @"PeripheralUUID"     : peripheral.identifier.UUIDString,
                              @"CharacteristicUUID" : characteristic.UUID.UUIDString,
                              @"Error"              : error
                              }];
}

//发现服务中包含的服务
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverIncludedServicesForService:(CBService *)service
             error:(NSError *)error {
  if(error != nil)
    return;
  
  [self log:@"发现服务中包含的服务"];
  [_dataDidSubject sendNext:@{
                              @"Type"           : @(JXBTServiceDataDidSubjectType_DiscoverIncludedServices),
                              @"PeripheralUUID" : peripheral.identifier.UUIDString,
                              @"ServiceUUID"    : service.UUID.UUIDString,
                              @"Error"          : error
                              }];
}

//Characteristic广播更新
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:
(CBCharacteristic *)characteristic
             error:(NSError *)error {
  if(error != nil)
    return;
  
  [self log:@"Characteristic广播更新"];
  [_dataDidSubject sendNext:@{
                              @"Type"               : @(JXBTServiceDataDidSubjectType_UpdateNotificationState),
                              @"PeripheralUUID"     : peripheral.identifier.UUIDString,
                              @"CharacteristicUUID" : characteristic.UUID.UUIDString,
                              @"Error"              : error
                              }];
}

//寻找到Descriptor的Descriptors
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
  if(error != nil)
    return;
  
  [self log:@"从Descriptor获得数据"];
  [_dataDidSubject sendNext:@{
                              @"Type" :
                                @(JXBTServiceDataDidSubjectType_DiscoverDescriptors),
                              @"PeripheralUUID" :
                                peripheral.identifier.UUIDString,
                              @"CharacteristicUUID" :
                                characteristic.UUID.UUIDString,
                              @"Error" :
                                error
                              }];
}

//从Descriptor获得数据
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForDescriptor:(CBDescriptor *)descriptor
             error:(NSError *)error {
  if(error != nil)
    return;
  
  [self log:@"从Descriptor获得数据"];
  [_dataDidSubject sendNext:@{
                              @"Type" :
                                @(JXBTServiceDataDidSubjectType_UpdateValue),
                              @"PeripheralUUID" :
                                peripheral.identifier.UUIDString,
                              @"DescriptorUUID" :
                                descriptor.UUID.UUIDString,
                              @"Error" :
                                error
                              }];
}

//写到Descriptor完成
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForDescriptor:(CBDescriptor *)descriptor
             error:(NSError *)error {
  if(error != nil)
    return;
  
  [self log:@"写到Descriptor完成"];
  [_dataDidSubject sendNext:@{
                              @"Type" :
                                @(JXBTServiceDataDidSubjectType_WriteValueForDescriptor),
                              @"PeripheralUUID" :
                                peripheral.identifier.UUIDString,
                              @"Descriptor" :
                                descriptor.UUID.UUIDString,
                              @"Error" :
                                error
                              }];
}


@end
