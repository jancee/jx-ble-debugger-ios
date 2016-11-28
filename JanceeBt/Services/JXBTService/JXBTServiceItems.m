//
//  JXBTServiceItems.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/10.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXBTServiceItems.h"


/******************************************************************************************/
@implementation JXBTDeviceDetail

- (instancetype)init {
  self = [super init];
  if(self) {
    self.serviceArray   = [[NSMutableArray alloc] init];
    self.characterArray = [[NSMutableArray alloc] init];
    self.connectStatus  = JXBTDeviceConnectStatus_NoConnect;
  }
  return self;
}

- (CBCharacteristic*)findCBCharacteristic:(NSString*)characterUuid {
  for (CBCharacteristic *character in self.characterArray) {
    if([character.UUID.UUIDString isEqualToString:characterUuid]) {
      return character;
    }
  }
  return nil;
}

- (CBService*)findCBService:(NSString*)serviceUuid {
  for (CBService *service in self.serviceArray) {
    if([service.UUID.UUIDString isEqualToString:serviceUuid]) {
      return service;
    }
  }
  return nil;
}

@end

/******************************************************************************************/



@implementation JXBTDeviceSearched

- (instancetype)initWithUuid:(NSString*)uuid
                  DeviceName:(NSString*)deviceName
                   localName:(NSString*)localName
                     advData:(NSData*)advData
                        rssi:(NSNumber*)rssi
                  peripheral:(CBPeripheral*)peripheral {
  self = [super init];
  if(self) {
    _uuid       = uuid;
    _deviceName = deviceName;
    _localName  = localName;
    _advData    = advData;
    _rssi       = rssi;
    _peripheral = peripheral;
  }
  return self;
}

@end



/******************************************************************************************/
