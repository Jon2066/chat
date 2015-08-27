//
//  MIMVoiceRecorder.h
//  MyIM
//
//  Created by Jonathan on 15/8/24.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMVoiceRecorder : NSObject

@property (strong, nonatomic, readonly) NSString *voiceFileName; //录音文件标识 用于获取文件

@property (assign, nonatomic, readonly) NSTimeInterval recordCurrentTime; //录音时间


/**
 *  创建recorder
 *
 *  @param block finished 是否完成  currentTime 若没完成，则当前录音多长时间
 *
 */
- (instancetype)initWithBlock:(void(^)(MIMVoiceRecorder *recorder, BOOL finished))block;

/**
 *  开始录音
 *
 *  每次开始录音就会创建一个新路径并返回文件名
 *
 *  @param  maxTime 最长录音时间 到达时间限制会自动结束录音
 *
 *  @return 返回 voiceFileName
 */
- (NSString *)startRecordWithMaxRecordTime:(NSTimeInterval)maxTime;


/**
 *  结束录音
 */
- (void)finishRecord;


/**
 *  文件是否存在
 */
+ (BOOL)fileExistWithFileName:(NSString *)fileName;

/**
 *  重命名文件
 *
 *  @param oldName 就名字
 *  @param newName 新名字
 */
+ (void)renameFileWithOldName:(NSString *)oldName newName:(NSString *)newName;


/**
 *  音频文件保存路径
 */
+ (NSString *)voicePathWithFileName:(NSString *)fileName;

@end
