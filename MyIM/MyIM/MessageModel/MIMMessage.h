//
//  MIMMessage.h
//  MyIM
//
//  Created by Jonathan on 15/8/14.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MIMImageModel.h"

typedef enum {
    MIMMessageTypeText  = 1,
    MIMMessageTypeImage = 2,
    MIMMessageTypeVoice = 3,
}MIMMessageType;

@interface MIMMessage : NSObject

@property (strong, nonatomic) NSString       *senderId;//发送人
@property (strong, nonatomic) NSString       *senderNickname;//发送人昵称
@property (assign, nonatomic) MIMMessageType  messageType; //消息类型
@property (strong, nonatomic) NSString       *messageText; //文本消息
@property (strong, nonatomic) MIMImageModel  *imageModel;  //图片用imageModel  我发送的消息 没有url则使用placeHolderImage 有url使用缩略 大图使用url
@property (strong, nonatomic) NSString       *mediaFileName;    //多媒体消息 文件名称(远程url加密字符串 保证唯一性)
@property (strong, nonatomic) NSDate         *date;        //发送时间

@end
