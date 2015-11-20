//
//  MIMMessageTextView.h
//  MyIM
//
//  Created by Jonathan on 15/8/15.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMDefine.h"

@interface MIMMessageTextView : UIView


- (instancetype)initFromNib;


- (void)loadViewWithMessageText:(NSString *)messageText messageCellStyle:(MIMMessageCellStyle)style;

/**
 *  获取texView在消息中显示大小
 *
 *  @param minHeight 给出最小高度
 */
+ (CGSize)getTextViewSizeWithText:(NSString *)messagetext minHeight:(CGFloat)minHeight;

/*
 * 处理textView链接
 */
- (void)textViewShouldInteractWithBlock:(BOOL(^)(NSURL *URL,NSRange characterRange))block;

@end
