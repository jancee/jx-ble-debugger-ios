//
//  JXBTServiceScannner.h
//  JanceeBt
//
//  BLE设备搜索者，建议一般情况下只使用一个该实例，或者通过share方法获得的多实例
//  注意通过share方法获得的实例，扫描与停止扫描是公用的同一个BLCentralManager的
//
//  Created by jancee wang on 2016/11/21.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXBTServiceScannner : NSObject


/**
 创建搜索者
 
 @return 新的实例
 */
- (instancetype)init;

/**
 重映射（链式）
 
 @param newMapBlock block
 @return New Instance
 */
- (instancetype)map:(JXBTDeviceSearched * (^)(JXBTDeviceSearched *item))newMapBlock;


/**
 过滤（链式）
 
 @param newFilterBlock 过滤block。通过则返回YES
 @return New Instance
 */
- (instancetype)setFilter:(BOOL (^)(JXBTDeviceSearched *item))newFilterBlock;


/**
 搜索到设备处理（链式）
 
 @param newScannedBlock 处理block
 @return New Instance
 */
- (instancetype)onScanned:(void(^)(JXBTDeviceSearched *item))newScannedBlock;






- (void)stopScan;



- (instancetype)initWithLineMethodFilterBlock:(BOOL (^)(JXBTDeviceSearched *item))fBlock
                                     mapBlock:(JXBTDeviceSearched * (^)(JXBTDeviceSearched *item))mBlock
                                      scanned:(void(^)(JXBTDeviceSearched *item))sBlock;

@end


@protocol JXBTServiceScannerService <NSObject>

- (void)tellMeSearchedDevice:(JXBTDeviceSearched*)item;

@end
