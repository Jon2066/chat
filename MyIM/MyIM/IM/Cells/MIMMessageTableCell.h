//
//  MIMMessageTableCell.h
//  MyIM
//
//  Created by Jonathan on 15/8/12.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIMDefine.h"

#import "MIMMessageContent.h"

typedef void(^messageAvatarClick)(void);

@interface MIMMessageTableCell : UITableViewCell

@property (assign, nonatomic,readonly) MIMMessageCellStyle style;

@property (strong, nonatomic) MIMMessageContent *messageContent;

@property (strong, nonatomic) messageAvatarClick avatarClick;

- (instancetype)initWithCellStyle:(MIMMessageCellStyle )style;

@end
