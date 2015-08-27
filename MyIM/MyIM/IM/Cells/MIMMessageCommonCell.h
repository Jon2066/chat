//
//  MIMMessageCommonCell.h
//  MyIM
//
//  Created by Jonathan on 15/8/20.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIMMessageContent.h"
/**
 *  空白cell  不带时间 头像 昵称 只显示viewModel中的contentView
 */
@interface MIMMessageCommonCell : UITableViewCell

@property (strong, nonatomic) MIMMessageContent *messageContent;

@end
