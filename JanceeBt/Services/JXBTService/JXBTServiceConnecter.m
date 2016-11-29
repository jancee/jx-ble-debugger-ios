//
//  JXBTServiceConnecter.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/21.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "JXBTServiceConnecter.h"



static const NSString* DictInConnecterArrayKey_UUID      = @"UUID";
static const NSString* DictInConnecterArrayKey_Connecter = @"CONNECTER";


@interface JXBTServiceConnecter () {
  void (^connectBlock)();
  void (^disconnectBlock)();
  void (^dataDidBlock)(NSDictionary *dict);
  void (^searchedCharacterBlock)(NSDictionary *dict);
  void (^searchedServiceBlock)(NSDictionary *dict);
}

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic) BOOL reconnectEnable;

@property (nonatomic) JXBTServiceConnecter_SendDataIntervalMode sendDataIntervalMode;
@property (nonatomic) CGFloat                                   sendDataIntervalTime;

@end


@implementation JXBTServiceConnecter

static const NSString* logPrefix = @"[JXBTServiceConnecter]";

static NSMutableArray<NSDictionary *> *allConnecterArray;

#pragma mark - 初始化方法
+ (instancetype)getConnecterWithUuid:(NSString*)uuid {
  JXBTServiceConnecter *returnConnecter;
  
  //查找对应的uuid的连接器
  for (NSDictionary *forDict in allConnecterArray) {
    if([forDict[DictInConnecterArrayKey_UUID] isEqualToString:uuid]) {
      returnConnecter = forDict[DictInConnecterArrayKey_Connecter];
      break;
    }
  }
  
  //没有已有连接器
  if(returnConnecter == nil) {
    //初始化一个新的连接器
    returnConnecter = [[JXBTServiceConnecter alloc] initWithUuid:uuid];
    [returnConnecter resetAllBlock];
    
    //记录这个连接器到静态array
    NSDictionary *addDict = @{
                              DictInConnecterArrayKey_UUID      : uuid,
                              DictInConnecterArrayKey_Connecter : returnConnecter
                              };
    [allConnecterArray addObject:addDict];
  }
  
  //连机器
  return returnConnecter;
}


//连接器重置
- (instancetype)resetAllBlock {
  self.reconnectEnable = NO;
  connectBlock        = ^(){};
  disconnectBlock     = ^(){};
  dataDidBlock = ^(NSDictionary *dict){};
  searchedCharacterBlock = ^(NSDictionary *dict){};
  searchedServiceBlock = ^(NSDictionary *dict){};
  return self;
}


//内部
- (instancetype)initWithUuid:(NSString*)uuid {
  self = [super init];
  if(self) {
    //属性初始化
    self.uuid = uuid;
    
    /******** RAC **********/
    //  连接断开/失败
    [[[JXBTService sharedInstance].deviceInterruptRACSubject
      filter:^BOOL(CBPeripheral *value) {
        return [value.identifier.UUIDString isEqualToString:uuid];
      }]
     subscribeNext:^(CBPeripheral *value) {
       disconnectBlock();
     }];
    
    //  连接成功
    [[[JXBTService sharedInstance].deviceConnectRACSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       connectBlock();
     }];
    
    //  更新数据
    [[[JXBTService sharedInstance].dataDidSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       dataDidBlock(value);
     }];
    
    //  搜到服务
    [[[JXBTService sharedInstance].searchCharacterRACSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       searchedServiceBlock(value);
     }];
    
    //  搜到特征
    [[[JXBTService sharedInstance].searchServiceRACSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       searchedCharacterBlock(value);
     }];
    /***********************/
    
  }
  return self;
}


#pragma mark - 方法
- (instancetype)setConnectedBlock:(void (^)())block {
  connectBlock = block;
  return self;
}

- (instancetype)setDisconnectBlock:(void (^)())block {
  disconnectBlock = block;
  return self;
}

- (instancetype)setDataDidBlock:(void (^)(NSDictionary *dict))block {
  dataDidBlock = block;
  return self;
}

- (instancetype)setSearchedCharacterBlock:(void (^)(NSDictionary *dict))block {
  searchedCharacterBlock = block;
  return self;
}

- (instancetype)setSearchedServiceBlock:(void (^)(NSDictionary *dict))block {
  searchedServiceBlock = block;
  return self;
}

/**
 设置发送数据时间间隔模式
 
 @param mode      模式
 @param seconds   间隔时间
 @return          链式
 */
- (instancetype)setSendDataIntervalMode:(JXBTServiceConnecter_SendDataIntervalMode)mode
                        withMinInterval:(CGFloat)seconds {
  self.sendDataIntervalMode = mode;
  self.sendDataIntervalTime = seconds;
  return self;
}


/**
 设置连接超时时间
 先设置，然后再连接才有效
 
 @param seconds 超时时间
 @return  链式
 */
- (instancetype)setConnectTimeoutTime:(CGFloat)seconds {
  return self;
}





#pragma mark - 操作方法

/**
 连接
 */
- (instancetype)connect {
  [[JXBTService sharedInstance] connectDevice:self.uuid];
  return self;
}


/**
 断开连接
 */
- (instancetype)disconnect {
  [[JXBTService sharedInstance] disconnectOneDevice:self.uuid];
  return self;
}


/**
 设置是否重连

 @param enable 重连？
 @return 链式
 */
- (instancetype)setReconnectListener:(BOOL)enable {
  self.reconnectEnable = enable;
  return self;
}


/**
 发送数据
 
 @param data 数据
 @param uuid 特征uuid
 @return 链式
 */
- (instancetype)sendData:(NSData*)data
         toCharacterUuid:(NSString*)uuid
            withResponse:(BOOL)response {
  [[JXBTService sharedInstance] sendDataToSingleDevice:data
                                               bleUuid:self.uuid
                                    characteristicUuid:uuid
                                          withResponse:response];
  return self;
}


/**
 发送一堆数据
 
 @param dataArray 数据array
 @param uuid 特征uuid
 @param second 时间间隔
 @return 链式
 */
- (instancetype)sendManyData:(NSArray<NSData*>*)dataArray
             toCharacterUuid:(NSString*)uuid
                    interval:(CGFloat)second
                withResponse:(BOOL)response {
  for (NSData* data in dataArray) {
    [[JXBTService sharedInstance] sendDataToSingleDevice:data
                                                 bleUuid:self.uuid
                                      characteristicUuid:uuid
                                            withResponse:response];
  }
  return self;
}





#pragma mark - tools
- (void)log:(NSString*)log {
  NSLog(@"%@ -> %@ -> %@",logPrefix, self, log);
}







@end













