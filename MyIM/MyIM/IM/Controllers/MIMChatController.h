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

#import "MIMInputToolbar.h"

#import "MIMImageModel.h"

@protocol MIMChatViewDataSource <NSObject>

/**
 *  获取cell消息内容 
 *  contentView可复用  nil时创建
 *  若消息类型为完全自定义(MIMMessageCellStyleOthers) 则显示完全为contentView
 */
- (UIView *)chatViewMessageContentView:(UIView *)contentView cellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index;

/**
 *  获得消息内容的显示大小  MIMMessageCellStyleOthers 只参考高度 宽度为屏宽 
 */
-  (CGSize )chatViewMessageContentViewSizeForCellAtIndex:(NSInteger)index;

/**
 *  昵称  nil则不显示
 */
- (NSString *)chatViewNicknameForCellAtIndex:(NSInteger)index;

/**
 *  消息时间 nil则不显示
 */
- (NSString *)chatViewMessageTimeForCellAtIndex:(NSInteger)index;

/**
 *  头像
 */
- (MIMImageModel *)chatViewAvatarWithCellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index;

/**
 *  是否显示发送错误提示
 */
- (BOOL)chatViewShowErrorForCellAtIndex:(NSInteger)index;

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
- (void)chatViewShouldCheckErrorAtIndex:(NSInteger)index;
- (void)chatViewDidSelectCellAtIndex:(NSInteger)index;
- (void)chatViewShouldFinishEditing; //点击view或者开始滚动 用来停止编辑
- (void)chatViewBeginTextEditing;
- (void)chatViewWillDisplayCellWithContentView:(UIView *)contentView atIndex:(NSInteger)index;
@end


@interface MIMChatController : UIViewController<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


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


/**
 *  滚动到指定cell
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;


- (void)scrollToIndex:(NSInteger)index asScrollPosition:(UITableViewScrollPosition)position animated:(BOOL)animated;

/**
 *  滚动到底部
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 *  删除行
 */
- (void)deleteMessageFromIndex:(NSInteger)index;

/**
 *  插入消息
 *
 *  @param index 从index开始
 *  @param count 要插入多少条消息
 */
- (void)insertMessagesFromIndex:(NSInteger)index count:(NSInteger)count;


- (void)reloadMessageCellAtIndex:(NSInteger)index;

/**
 *  完成接收新消息 调用
 *
 *  @param count    多少条新消息
 *  @param animated 是否动画
 */
- (void)finishReceiveNewMessageWithCount:(NSInteger)count animated:(BOOL)animated;

- (void)finishReceiveWithoutScrollWithNewMessageCount:(NSInteger)count;

@end
