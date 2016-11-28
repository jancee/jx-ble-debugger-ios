//
//  JXAVMusicService.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/11.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXAVMusicService.h"

@interface JXAVMusicService ()

@property(nonatomic, strong) NSTimer *timer;


@end


@implementation JXAVMusicService

static JXAVMusicService  *Instance;

static AVAudioPlayer *player;


+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^ {
    Instance = [[JXAVMusicService alloc] init];
  });
  return Instance;
}


- (NSArray<MPMediaItem*>*)getAllMusicFromIpodMedia {
  MPMediaQuery *everything = [[MPMediaQuery alloc] init];
  
  // 读取条件
  MPMediaPropertyPredicate *albumNamePredicate =
  [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic]
                                   forProperty: MPMediaItemPropertyMediaType];
  [everything addFilterPredicate:albumNamePredicate];
  NSArray *itemsFromGenericQuery = [everything items];
  for (MPMediaItem *song in itemsFromGenericQuery) {
    NSURL *songTitle = [song valueForProperty:MPMediaItemPropertyAssetURL];
    if(songTitle) {
      NSLog(@"播放%@  %@  %@",
            songTitle,
            [song valueForProperty:MPMediaItemPropertyTitle],
            [songTitle class]);
      
      player = [[AVAudioPlayer alloc] initWithContentsOfURL:songTitle error:nil];
      NSData* ddd = [[NSData data] initWithContentsOfURL:songTitle];
      NSLog(@"%@",ddd);
      
      [player prepareToPlay];
      [player setVolume:1.0f];
      player.numberOfLoops = -1;
      [player play];
      
    }
  }
  
  NSLog(@"xxx");
  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                       target:self
                                     selector:@selector(ccc:)
                                     userInfo:nil
                                      repeats:YES];
  
  return itemsFromGenericQuery;
}



- (void)ccc:(NSTimer *)t {
  NSLog(@"aa");
  [player updateMeters];
  
  //取得第一个通道的音频，注意音频强度范围时-160到0
  NSLog(@"cccc%f",[player averagePowerForChannel:0]);
  NSLog(@"cccc%f",[player averagePowerForChannel:1]);
  NSLog(@"cccc%f",[player averagePowerForChannel:3]);
  NSLog(@"cccc%f",[player averagePowerForChannel:4]);
}

@end
