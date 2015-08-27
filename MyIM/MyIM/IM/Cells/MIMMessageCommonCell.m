//
//  MIMMessageCommonCell.m
//  MyIM
//
//  Created by Jonathan on 15/8/20.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMMessageCommonCell.h"

@interface MIMMessageCommonCell ()
@property (strong, nonatomic) UIView *messageView;
@end

@implementation MIMMessageCommonCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageContent:(MIMMessageContent *)messageContent
{
    _messageContent = messageContent;
    
    self.messageView = messageContent.contentView;
    
    [self.contentView addSubview:self.messageView];

    [self.messageView setTranslatesAutoresizingMaskIntoConstraints:NO];

    //创建约束
    NSLayoutConstraint *leadingCt = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];

    NSLayoutConstraint *trailingCt = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];

    NSLayoutConstraint *topCt = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomCt = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];


    [self.contentView addConstraints:@[leadingCt, trailingCt, topCt, bottomCt]];
}
@end
