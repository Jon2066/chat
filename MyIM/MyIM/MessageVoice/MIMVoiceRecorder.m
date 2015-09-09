//
//  MIMVoiceRecorder.m
//  MyIM
//
//  Created by Jonathan on 15/8/24.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMVoiceRecorder.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import "MIMVoiceFileConvert.h"

typedef void(^MIMRecordBlock)(MIMVoiceRecorder *recorder, BOOL finished);

@interface MIMVoiceRecorder ()<AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioRecorder *recorder;

@property (strong, nonatomic) MIMRecordBlock recordBlock;

@property (strong, nonatomic) NSTimer       *timer;
@end

@implementation MIMVoiceRecorder


- (instancetype)initWithBlock:(void(^)(MIMVoiceRecorder *recorder ,BOOL finished))block
{
    self = [super init];
    if (self) {
        _recordBlock = block;
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
}

- (NSString *)startRecordWithMaxRecordTime:(NSTimeInterval)maxTime
{
    _voiceFileName = [self createUuid];
    
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
//    UInt32 doChangeDefault = 1;
//    
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    
    
    NSString *path = [MIMVoiceRecorder tempVoiceSavePath];
    
    NSError *error = nil;

    NSDictionary *settings = [self getAudioRecordSetting];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:settings error:&error];
    
    self.recorder.meteringEnabled = YES;
    
    self.recorder.delegate = self;
    
    [self.recorder prepareToRecord];
    
    if(self.timer){
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeLeftFeedback) userInfo:nil repeats:YES];

    //最长录音时间
    [self.recorder recordForDuration:maxTime];
    //开始录音

    
    [self.recorder record];
    
    return _voiceFileName;
}

- (void)finishRecord
{
    if ([self.recorder isRecording]) {
        [self.timer invalidate];
        self.timer = nil;
        [self.recorder stop];
    }
}


- (NSDictionary *)getAudioRecordSetting
{
    return @{AVSampleRateKey        : @(8000.0),  //采样率 8k
             AVFormatIDKey          : @(kAudioFormatLinearPCM),
             AVLinearPCMBitDepthKey : @(16), //采样位数
             AVNumberOfChannelsKey  : @(1)}; //通道数
}


/**
 *  生成一个唯一标识 用于保存文件
 *
 *  @return 唯一标识
 */
- (NSString *)createUuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (self.timer) {
        [self.timer invalidate];
    }
    [MIMVoiceFileConvert wavToAmr:[MIMVoiceRecorder tempVoiceSavePath] amrSavePath:[MIMVoiceRecorder voicePathWithFileName:_voiceFileName]];
    if (self.recordBlock) {
        self.recordBlock(self, YES);
    }
    _recordCurrentTime = 0;
}


- (void)timeLeftFeedback
{
    if ([self.recorder isRecording]) {
        _recordCurrentTime  = self.recorder.currentTime;
        if (self.recordBlock) {
            self.recordBlock(self, NO);
        }
    }
}

#pragma mark - 文件处理 -



/**
 *  录音临时保存路径
 *
 *  @return 临时保存路径
 */
+ (NSString *)tempVoiceSavePath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"kMIMTempVoice.wav"];
}

/**
 *  音频文件保存路径
 */
+ (NSString *)voicePathWithFileName:(NSString *)fileName
{
    return [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"Voice_%@",fileName]] stringByAppendingPathExtension:@"amr"];
}

/**
 *  文件是否存在
 */
+ (BOOL)fileExistWithFileName:(NSString *)fileName
{
    NSString *path = [self voicePathWithFileName:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


/**
 *  重命名文件
 *
 *  @param oldName 就名字
 *  @param newName 新名字
 */
+ (void)renameFileWithOldName:(NSString *)oldName newName:(NSString *)newName
{
    NSString *oldPath = [self voicePathWithFileName:oldName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:oldPath]) {
        NSString *newPath = [self voicePathWithFileName:newName];
        [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
    }
}





@end
