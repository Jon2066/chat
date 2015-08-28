//
//  MIMChatVoiceController.h
//  MyIM
//
//  Created by Jonathan on 15/8/21.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//


/**
 *  继承MIMChatController 
 *  实现其他媒体输入
 */

#import "MIMChatController.h"


typedef enum {
    MIMIuputTypeText       = 0, //文本输入
    MIMIuputTypeVoice      = 1, //语音输入
    MIMIuputTypeMediaItems = 2, //其他媒体输入
}MIMIuputType;



@protocol MIMChatMediaDelegate <NSObject>

@optional
- (void)chatViewFinishRecordWithFileName:(NSString *)filename;
- (void)chatViewFinishSelectWithImage:(UIImage *)image;
@end


@interface MIMChatMediaController : MIMChatController

@property (assign, nonatomic) MIMIuputType inputType;

@property (assign, nonatomic) id<MIMChatMediaDelegate>mediaDelagate;

- (instancetype)initWithNib;

@end
