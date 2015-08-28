//
//  MIMChatController.h
//  MyIM
//
//  Created by Jonathan on 15/8/10.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

/**
 *  基础controller  更多功能可继承后拓展
 *  实现view排版
 *  实现文本输入
 */

#import <UIKit/UIKit.h>

#import "MIMDefine.h"

#import "MIMMessageContent.h"

#import "MIMInputToolbar.h"


@protocol MIMChatViewDataSource <NSObject>

/**
 *  自定义实现cell消息内容
 *  messageContent可复用  传入为nil时创建  非nil时修改model即可
 */
- (MIMMessageContent *)chatViewMessageContentView:(MIMMessageContent *)messageContent cellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index;

/**
 *  对话cell 头像左、右或其他类型 自定义的其他类型则不必传入（头像、昵称、时间）这些参数
 */
- (MIMMessageCellStyle)chatViewCellStyleAtIndex:(NSInteger )index;

/**
 *  返回消息类型标识 用于复用(messageContent 复用id)
 */
- (NSString *)chatViewessageTypeReusableIdentifierAtIndex:(NSInteger)index;

/**
 *  消息数量
 */
- (NSInteger)chatViewNumberOfRows;

@end


@protocol MIMChatViewDelegate <NSObject>

@optional
- (void)chatViewWillSendMessageText:(NSString *)text;
- (void)chatViewDidSelectAvatarAtIndex:(NSInteger)index;
- (void)chatViewDidSelectCellAtIndex:(NSInteger)index;
- (void)chatViewShouldFinishEditing; //点击view或者开始滚动 用来停止编辑

@end


@interface MIMChatController : UIViewController<UITextViewDelegate>


/**
 *  输入控件
 *  controller只实现一个textView输入
 *  其他按钮或输入控件自定义
 */
@property (strong, nonatomic) UITextView *textView;

/**
 *  输入toolbar
 */
@property (weak, nonatomic) IBOutlet MIMInputToolbar *inputToolbar;

/**
 *  输入toolbar的高度
 */
@property (assign, nonatomic) CGFloat inputToolBarHeight;

/**
 *  输入toolbar 最高的高度 不设置高度限制为0.0
 */
@property (assign, nonatomic) CGFloat maxInputToolBarHeight;


@property (assign, nonatomic) id<MIMChatViewDataSource>dataSource;
@property (assign, nonatomic) id<MIMChatViewDelegate>delegate;

- (instancetype)initWithNib;

/**
 *  更新toolbar距离底部的高度
 */
- (void)updateToolbarBottomDistance:(CGFloat )height animated:(BOOL)animated;

//完成接收新消息 调用
- (void)finishReceiveNewMessageWithCount:(NSInteger)count animated:(BOOL)animated;
@end
