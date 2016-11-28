//
//  JXAVMusicService.h
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/11.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JXAVMusicService : NSObject

+ (instancetype)sharedInstance;

- (NSArray<MPMediaItem*>*)getAllMusicFromIpodMedia;

@end
