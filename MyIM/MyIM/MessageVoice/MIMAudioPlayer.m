//
//  MIMAudioPlayer.m
//  MyIM
//
//  Created by Jonathan on 15/8/25.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "MIMVoiceRecorder.h"
#import "MIMVoiceDataConvert.h"

typedef void(^playFinishBlock)(void);

@interface MIMAudioPlayer ()<AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer  *audioPlayer;
@property (strong, nonatomic) playFinishBlock finishBlock;
@end

@implementation MIMAudioPlayer

+ (MIMAudioPlayer *)shareAudioPlayer
{
    static MIMAudioPlayer *shareAudioPlayer = nil;
    static dispatch_once_t onceT;
    dispatch_once(&onceT, ^{
        shareAudioPlayer = [[self alloc] init];
    });
    return shareAudioPlayer;
}

- (void)playVoiceMessageWithFileName:(NSString *)fileName playFinishBlock:(void(^)(void))finish
{
    self.finishBlock = finish;
    dispatch_async(dispatch_queue_create("kMIMAudioLoadData", NULL), ^{
        NSData *data = [MIMVoiceDataConvert wavDataFromAmrFile:[MIMVoiceRecorder voicePathWithFileName:fileName]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playWithData:data];
        });
    });
}

- (void)playWithData:(NSData *)data
{
//    UIApplication *app = [UIApplication sharedApplication];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
}

- (void)stopPlay
{
    if (self.audioPlayer && [self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        if (self.finishBlock) {
            self.finishBlock();
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.finishBlock) {
        self.finishBlock();
    }
}

//- (void)applicationWillResignActive:(UIApplication *)application{
//    if (self.finishBlock) {
//        self.finishBlock();
//    }
//}


/**
 *  用于播放的临时路径
 *
 *  @return 临时播放路径
 */
+ (NSString *)tempVoicePlayPath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"kMIMTempPlayVoice.wav"];
}

/**
 *  获取音频文件时长
 */
+ (NSInteger)getAudioDurationWithFileName:(NSString *)filename
{
    NSString *path = [MIMVoiceRecorder voicePathWithFileName:filename];
    NSData *data = [MIMVoiceDataConvert wavDataFromAmrFile:path];
    AVAudioPlayer *tempPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
//    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:path] options:nil];
//    CMTime audioDuration = audioAsset.duration;
//    float durationSeconds = CMTimeGetSeconds(audioDuration);
//    return durationSeconds;
    return (NSInteger)tempPlayer.duration + 1;
}

@end
