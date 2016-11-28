//
//  JXMusicService.h
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/7.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
  JXMusicServicePlayStatus_Stopped = 1,
  JXMusicServicePlayStatus_Playing,
  JXMusicServicePlayStatus_Paused,
  JXMusicServicePlayStatus_Interrupted,
  JXMusicServicePlayStatus_SeekingForward,
  JXMusicServicePlayStatus_SeekingBackward,
} JXMusicServicePlayStatus;


@interface JXMusicService : NSObject
<
MPMediaPickerControllerDelegate
>



@property (nonatomic, copy, readonly) RACSubject *musicPlayStatusChangedRACSubject;
@property (nonatomic, copy, readonly) RACSubject *musicItemChangedRACSubject;



+ (instancetype)sharedInstance;

+ (void)musicPickAndPlay:(UIViewController*)VC;
- (void)musicPauseOrContinuePlay;
- (void)nextMusic;
- (void)beforeMusic;


@end
