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
  void (^dataDidSubjectBlock)(NSDictionary *dict);
}

@property (nonatomic, strong) NSString *uuid;

@property (nonatomic) JXBTServiceConnecter_SendDataIntervalMode sendDataIntervalMode;
@property (nonatomic) CGFloat                                   sendDataIntervalTime;

@end


@implementation JXBTServiceConnecter

static const NSString* logPrefix = @"[JXBTServiceConnecter] -> ";

static NSMutableArray<NSDictionary *> *allConnecterArray;

#pragma mark - 初始化方法
+ (instancetype)getConnecterWithUuid:(NSString*)uuid {
  JXBTServiceConnecter *returnConnecter;
  for (NSDictionary *forDict in allConnecterArray) {
    if([forDict[DictInConnecterArrayKey_UUID] isEqualToString:uuid]) {
      returnConnecter = forDict[DictInConnecterArrayKey_Connecter];
      break;
    }
  }
  if(returnConnecter == nil) {
    returnConnecter = [[JXBTServiceConnecter alloc] initWithUuid:uuid];
    [returnConnecter resetAllBlock];
    NSDictionary *addDict = @{
                              DictInConnecterArrayKey_UUID      : uuid,
                              DictInConnecterArrayKey_Connecter : returnConnecter
                              };
    [allConnecterArray addObject:addDict];
  }
  return returnConnecter;
}

- (instancetype)resetAllBlock {
  connectBlock        = ^(){};
  disconnectBlock     = ^(){};
  dataDidSubjectBlock = ^(NSDictionary *dict){};
  return self;
}


//内部
- (instancetype)initWithUuid:(NSString*)uuid {
  self = [super init];
  if(self) {
    //属性初始化
    self.uuid = uuid;
    
    //RAC
    //  连接断开\失败
    [[[JXBTService sharedInstance].deviceInterruptRACSubject
      filter:^BOOL(CBPeripheral *value) {
        return [value.identifier.UUIDString isEqualToString:uuid];
      }]
     subscribeNext:^(CBPeripheral *value) {
       [self log:@"连接断开、失败"];
     }];
    
    //  连接成功
    [[[JXBTService sharedInstance].deviceConnectRACSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       [self log:@"连接成功"];
     }];
    
    //  更新数据
    [[[JXBTService sharedInstance].dataDidSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       [self log:@"更新数据"];
     }];
    
    //  搜到服务
    [[[JXBTService sharedInstance].searchCharacterRACSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       [self log:@"搜到服务"];
     }];
    
    //  搜到特征
    [[[JXBTService sharedInstance].searchServiceRACSubject
      filter:^BOOL(NSDictionary *value) {
        return [value[@"PeripheralUUID"] isEqualToString:uuid];
      }]
     subscribeNext:^(NSDictionary *value) {
       [self log:@"搜到特征"];
     }];
    
  }
  return self;
}


#pragma mark - 外部调用方法



#pragma mark - 设置方法
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
 发送数据

 @param data 数据
 @param uuid 特征uuid
 @return 链式
 */
- (instancetype)sendData:(NSData*)data
            toCharacterUuid:(NSString*)uuid {
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
                    interval:(CGFloat)second {
  for (NSData* data in dataArray) {
    [self sendData:data toCharacterUuid:uuid];
  }
  return self;
}





#pragma mark - tools
- (void)log:(NSString*)log {
  NSLog(@"%@(%@)",[logPrefix stringByAppendingString:log],self);
}







@end













