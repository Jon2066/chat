//
//  MIMMessageTableCell.h
//  MyIM
//
//  Created by Jonathan on 15/8/12.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIMDefine.h"

#import "MIMImageModel.h"

typedef void(^messageItemClick)(NSInteger index);

@interface MIMMessageTableCell : UITableViewCell

@property (nonatomic, copy, readonly) NSString  *reuseIdentifier;

@property (assign, nonatomic,readonly) MIMMessageCellStyle style;

@property (assign, nonatomic) NSInteger       atIndex; 

@property (strong, nonatomic) UIView         *messageContentView;
@property (assign, nonatomic) CGSize          messageContentSize;
@property (strong, nonatomic) MIMImageModel  *avatar;
@property (strong, nonatomic) NSString       *nickName;
@property (strong, nonatomic) NSString       *messageTime; //消息时间
@property (assign, nonatomic) BOOL            showError;

@property (strong, nonatomic) messageItemClick avatarClick;
@property (strong, nonatomic) messageItemClick errorClick;

- (instancetype)initWithCellStyle:(MIMMessageCellStyle )style reuseIdentifier:(NSString *)reuseIdentifier;

@end
