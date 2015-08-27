//
//  MIMMessageContent.h
//  MyIM
//
//  Created by Jonathan on 15/8/21.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "MIMImageModel.h"

@interface MIMMessageContent : NSObject
@property (strong, nonatomic) UIView         *contentView;  //先设置view 再设置size
@property (assign, nonatomic) CGSize          contentSize; //消息内容大小 完全自定义的消息只参考height
@property (strong, nonatomic) MIMImageModel  *avatar;    //头像
@property (strong, nonatomic) NSString       *nickName;  //昵称 不显示为nil
@property (strong, nonatomic) NSString       *messageTime; //消息时间 不显示为nil

@property (assign, nonatomic) BOOL            showError; //是否显示发送错误提示


@end
