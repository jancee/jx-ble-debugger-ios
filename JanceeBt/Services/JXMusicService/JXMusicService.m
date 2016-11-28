//
//  JXMusicService.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/7.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXMusicService.h"





@interface JXMusicService ()

@property (nonatomic,strong) MPMusicPlayerController * myMusicPlayer;

@end






@implementation JXMusicService

static JXMusicService  *Instance;



#pragma mark - base
+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^ {
    Instance = [[JXMusicService alloc] init];
  });
  return Instance;
}

- (instancetype)init {
  self = [super init];
  if(self) {
    _musicPlayStatusChangedRACSubject = [RACSubject subject];
    _musicItemChangedRACSubject       = [RACSubject subject];
    [self registerMusic];
  }
  return self;
}

- (void)registerMusic {
  if(self.myMusicPlayer == nil) {
    self.myMusicPlayer = [[MPMusicPlayerController alloc] init];
    
    [self.myMusicPlayer beginGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayerStatedChanged:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:self.myMusicPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nowPlayingItemIsChanged:)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:self.myMusicPlayer];
  }
}







#pragma mark - 调用控制
#pragma mark 音乐选取并播放
/**
 音乐选取并播放
 */
+ (void)musicPickAndPlay:(UIViewController*)VC {
  MPMediaPickerController * mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
  if(mediaPicker != nil) {
    NSLog(@"Successfully instantiated a media picker");
    mediaPicker.delegate = [JXMusicService sharedInstance];
    mediaPicker.allowsPickingMultipleItems = YES;
    [VC presentViewController:mediaPicker animated:YES completion:nil];
  } else {
    NSLog(@"Could not instantiate a media picker");
  }
}

#pragma mark 控制：音乐暂停或者继续
/**
 控制：音乐暂停或者继续
 */
- (void)musicPauseOrContinuePlay {
  switch ([self.myMusicPlayer playbackState]) {
    case MPMusicPlaybackStatePlaying:
      [self.myMusicPlayer pause];
      break;
    case MPMusicPlaybackStateStopped:
    case MPMusicPlaybackStatePaused:
      [self.myMusicPlayer play];
      break;
    default:
      break;
  }
}


/**
 下一首歌曲
 */
- (void)nextMusic {
  [self.myMusicPlayer skipToNextItem];
}


/**
 上一首歌曲
 */
- (void)beforeMusic {
  [self.myMusicPlayer skipToPreviousItem];
}



#pragma mark - 回调
//播放器状态改变 NSNotificationCenter 触发
- (void)musicPlayerStatedChanged:(NSNotification *)paramNotification {
  NSNumber *stateAsObject = [paramNotification.userInfo objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"];
  switch ([stateAsObject integerValue]) {
    case MPMusicPlaybackStateStopped:
      [_musicPlayStatusChangedRACSubject sendNext:@(JXMusicServicePlayStatus_Stopped)];
      break;
    case MPMusicPlaybackStatePlaying:
      [_musicPlayStatusChangedRACSubject sendNext:@(JXMusicServicePlayStatus_Playing)];
      break;
    case MPMusicPlaybackStatePaused:
      [_musicPlayStatusChangedRACSubject sendNext:@(JXMusicServicePlayStatus_Paused)];
      break;
    case MPMusicPlaybackStateInterrupted:
      [_musicPlayStatusChangedRACSubject sendNext:@(JXMusicServicePlayStatus_Interrupted)];
      break;
    case MPMusicPlaybackStateSeekingForward:
      [_musicPlayStatusChangedRACSubject sendNext:@(JXMusicServicePlayStatus_SeekingForward)];
      break;
    case MPMusicPlaybackStateSeekingBackward:
      [_musicPlayStatusChangedRACSubject sendNext:@(JXMusicServicePlayStatus_SeekingBackward)];
      break;
    default:
      break;
  }
}

#pragma mark 当前播放的音乐改变了 NSNotificationCenter 触发
//当前播放的音乐改变了 NSNotificationCenter 触发
- (void)nowPlayingItemIsChanged:(NSNotification *)paramNotification {
  MPMediaItem *musicItem = self.myMusicPlayer.nowPlayingItem;
  [_musicItemChangedRACSubject sendNext:@{
                                          @"Title" :
                                            [musicItem valueForProperty:MPMediaItemPropertyTitle],
                                          @"Artist" :
                                            [musicItem valueForProperty:MPMediaItemPropertyArtist],
                                          }];
}

#pragma mark 音乐选取完成
//音乐选取完成
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
  //设置音乐播放列表
  [self.myMusicPlayer setQueueWithItemCollection:mediaItemCollection];
  
  //开始播放
  [self.myMusicPlayer play];
  
  //选取列表消失
  [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 音乐选取被取消
//音乐选取被取消
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  //选取列表消失
  [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}


@end
