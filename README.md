JanceeBt
==============
* 简介

    用于BLE蓝牙调试工具例程，该例程使用JXBTService框架。
    
    用于扫描、过滤周边BLE设备，查看BLE设备，功能类似LightBlue。


* 要求

    IOS10.0及以上，Xcode8.0及以上，Iphone6及以上。


******


JXBTService
==============
BLE做主连接从设备的框架，对CBLManager通过RAC进行二次封装，良好支持多设备连接情况。

使设备连接逻辑更加清晰，使用者无需维护BLE状态，仅需简单调用接口，实现多



要求
==============
* iOS 7.0 or later
* Xcode 8.0 or later


使用方法
==============
* 导入头文件

      #import "JXBTService.h"
    
* 初始化

      - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         
         //配置JXBTService，是否完成服务
         [[JXBTService sharedInstance] setCheckWhetherCompleteService:NO];
         //JXBTService开启
         [[JXBTService sharedInstance] startService];
  
         return YES;
        }

* 搜索设备

* 服务特征指定

    适用于
    * 需要过滤（配置过滤为YES）
    * 不需要过滤（配置过滤为NO）
    
* 连接过程监控
    用于知道连接的BLE设备
    
    
后续开发计划
==============
* 目前框架，在有“需要连接多种类型的BLE设备，需要用服务特征来判别设备是否有效，并且不同类型的设备判别方法不同"时，无法通过已有接口实现过滤。后续会改进，但这种需求应该很少出现。






API详解
==============
