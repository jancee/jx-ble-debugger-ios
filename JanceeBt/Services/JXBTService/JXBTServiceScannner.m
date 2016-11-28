//
//  JXBTServiceScannner.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/21.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "JXBTServiceScannner.h"


@interface JXBTServiceScannner ()
<
CBCentralManagerDelegate
>
{
  BOOL (^filterBlock)(JXBTDeviceSearched *item);
  JXBTDeviceSearched * (^mapBlock)(JXBTDeviceSearched *item);
  void(^scannedBlock)(JXBTDeviceSearched *item);
}

@end



@implementation JXBTServiceScannner

static const NSString* logPrefix = @"[JXBTServiceScannner] -> ";

static CBCentralManager *scanCentralManager;


//内部
- (instancetype)initWithLineMethodFilterBlock:(BOOL (^)(JXBTDeviceSearched *item))fBlock
                                     mapBlock:(JXBTDeviceSearched * (^)(JXBTDeviceSearched *item))mBlock
                                      scanned:(void(^)(JXBTDeviceSearched *item))sBlock {
  self = [[JXBTServiceScannner alloc] init];
  if(self) {
    filterBlock   = fBlock;
    mapBlock      = mBlock;
    scannedBlock  = sBlock;
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if(self) {
    if(scanCentralManager == nil) {
      scanCentralManager = [[CBCentralManager alloc] initWithDelegate:[JXBTService sharedInstance] queue:nil];
      dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.5f * NSEC_PER_SEC);
      dispatch_after(time, dispatch_get_main_queue(), ^{
        [scanCentralManager scanForPeripheralsWithServices:nil
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
      });
    }
    //监听搜索到设备的信号
    [[[[JXBTService sharedInstance] rac_signalForSelector:@selector(centralManager:didDiscoverPeripheral:advertisementData:RSSI:)
                                             fromProtocol:@protocol(CBCentralManagerDelegate)]
      filter:^BOOL(RACTuple *tuple) {
        return tuple.first == scanCentralManager;
      }]
     subscribeNext:^(RACTuple *tuple){
       [self centralManager:tuple.first didDiscoverPeripheral:tuple.second advertisementData:tuple.third RSSI:tuple.fourth];
     }];
    
    
    [[[[JXBTService sharedInstance] rac_signalForSelector:@selector(centralManagerDidUpdateState:)
                                             fromProtocol:@protocol(CBCentralManagerDelegate)]
      filter:^BOOL(RACTuple *tuple) {
        return tuple.first == scanCentralManager;
      }]
     subscribeNext:^(RACTuple *tuple) {
       [self centralManagerDidUpdateState:tuple.first];
     }];
    
    //初始化block默认执行
    filterBlock   = ^(JXBTDeviceSearched *item) {
      return YES;
    };
    mapBlock      = ^(JXBTDeviceSearched *item) {
      return item;
    };
    scannedBlock  = ^(JXBTDeviceSearched *item) {
      
    };
    
  }
  return self;
}


- (instancetype)map:(JXBTDeviceSearched * (^)(JXBTDeviceSearched *item))newMapBlock {
  JXBTServiceScannner *newScanner = [[JXBTServiceScannner alloc] initWithLineMethodFilterBlock:filterBlock
                                                                                      mapBlock:newMapBlock
                                                                                       scanned:scannedBlock];
  return newScanner;
}

- (instancetype)setFilter:(BOOL (^)(JXBTDeviceSearched *item))newFilterBlock {
  JXBTServiceScannner *newScanner = [[JXBTServiceScannner alloc] initWithLineMethodFilterBlock:newFilterBlock
                                                                                      mapBlock:mapBlock
                                                                                       scanned:scannedBlock];
  return newScanner;
}

- (instancetype)onScanned:(void(^)(JXBTDeviceSearched *item))newScannedBlock {
  JXBTServiceScannner *newScanner = [[JXBTServiceScannner alloc] initWithLineMethodFilterBlock:filterBlock
                                                                                      mapBlock:mapBlock
                                                                                       scanned:newScannedBlock];
  return newScanner;
}

//内部
- (void)stopScan {
  [scanCentralManager stopScan];
}

#pragma mark - CBCentralManager(rac)
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  if(central.state == CBManagerStatePoweredOn) {
    [self log:@"CentralManager状态已正常"];
  }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
  peripheral.delegate = [JXBTService sharedInstance];
  //整理数据，并告诉service找到的设备信息
  JXBTDeviceSearched *searchedItem = [[JXBTDeviceSearched alloc]
                                      initWithUuid:peripheral.identifier.UUIDString
                                      DeviceName:peripheral.name
                                      localName:[advertisementData objectForKey:@"kCBAdvDataLocalName"]
                                      advData:[advertisementData objectForKey:@"kCBAdvDataManufacturerData"]
                                      rssi:RSSI
                                      peripheral:peripheral];
  static JXBTService *jxbtServiceInstance;
  if(jxbtServiceInstance == nil) {
    jxbtServiceInstance = [JXBTService sharedInstance];
  }
  [jxbtServiceInstance tellMeSearchedDevice:searchedItem];
  
  //做过滤
  if(! filterBlock(searchedItem))
    return;
  
  //做映射并返回数据
  scannedBlock(mapBlock(searchedItem));
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  NSLog(@"dsa");
}

#pragma mark - tools
- (void)log:(NSString*)log {
  NSLog(@"%@(%@)",[logPrefix stringByAppendingString:log],self);
}

@end





