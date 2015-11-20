//
//  MIMDefine.h
//  MyIM
//
//  Created by Jonathan on 15/8/14.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#ifndef MyIM_MIMDefine_h
#define MyIM_MIMDefine_h



typedef enum{
    MIMMessageCellStyleOthers   = 0, //自定义 其他类型
    MIMMessageCellStyleIncoming = 1, //别人发送
    MIMMessageCellStyleOutgoing = 2, //我发送的
}MIMMessageCellStyle;


//cell 定义
#define MIM_TIME_LABEL_HEIGHT        36.0f  //时间高度
#define MIM_NICKNAME_LABEL_HEIGHT    24.0f  //昵称高度
#define MIM_SPACE_BETWEEN_AVATAR     10.0f  //头像与内容的距离
#define MIM_SPACE_BETWEEN_NICKNAME   0.0f  //昵称与内容的距离
#define MIM_AVATAR_SIZE              CGSizeMake(45, 45) //头像大小
#define MIM_BOTTOM_SPACE             15.0f //内容与cell下边间距

//toolbar 定义
#define MIM_INPUT_TOOLBAR_HEIGHT     50.0f   //输入toolb默认高度 也是两边按钮的高度


//消息定义
//文本消息
#define MIM_MESSAGE_MAX_TEXT_WIDTH       [UIScreen mainScreen].bounds.size.width * 0.618  //文本消息最大宽度为屏幕比例的多少
#define MIM_MESSAGE_TEXT_EDGE             UIEdgeInsetsMake(8.0, 15.0, 8.0, 18.0)             //文本四周边距（按右边给出 左边消息左右调换）
#define MIM_MESSAGE_TEXT_FONT            [UIFont systemFontOfSize:17.0f]                      //文本消息文字大小

//图片消息
#define MIM_MESSAGE_MAX_IMAGE_WIDTH      [UIScreen mainScreen].bounds.size.width * 0.4   //图片最宽为屏幕0.4
#define MIM_MESSAGE_MAX_IMAGE_HEIGHT     [UIScreen mainScreen].bounds.size.width * 0.4  //图片最宽为屏幕0.618
#define MIM_MESSAGE_MIN_IMAGE_WIDTH      [UIScreen mainScreen].bounds.size.width * 0.1   //图片最小宽度
#define MIM_MESSAGE_MIN_IMAGE_HEIGHT     [UIScreen mainScreen].bounds.size.width * 0.1  //图片最小高度

//语音消息
#define MIM_MESSAGE_MAX_VOICE_WIDTH      [UIScreen mainScreen].bounds.size.width * 0.55
#define MIM_MESSAGE_MIN_VOICE_WIDTH      75.0f

#define MIMMessageMaxRecorderTime        60   //最长录音时间 60秒

#endif
