//
//  MIMAudioPlayer.h
//  MyIM
//
//  Created by Jonathan on 15/8/25.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMAudioPlayer : NSObject

/**
 *  单例
 */
+ (MIMAudioPlayer *)shareAudioPlayer;

/**
 *  播放声音
 *
 *  @param fileName 声音文件名称
 *  @param finish   播放完成或者停止播放时调用
 */
- (void)playVoiceMessageWithFileName:(NSString *)fileName playFinishBlock:(void(^)(void))finish;

/**
 *  停止播放
 */
- (void)stopPlay;


/**
 *  获取音频文件时长
 */
+ (NSInteger)getAudioDurationWithFileName:(NSString *)filename;
@end
