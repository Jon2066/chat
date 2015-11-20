//
//  MIMMessageTableCell.m
//  MyIM
//
//  Created by Jonathan on 15/8/12.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMMessageTableCell.h"

#import "UIButton+WebCache.h"

@interface MIMMessageTableCell ()

@property (assign, nonatomic) CGSize          avatarSize;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nicknameHeightConstraint;

@property (strong, nonatomic) NSLayoutConstraint *contentMHC;
@property (strong, nonatomic) NSLayoutConstraint *contentMVC;

@property (strong, nonatomic) UIButton      *errorButton;

@end

@implementation MIMMessageTableCell
@synthesize reuseIdentifier = _reuseIdentifier;
- (instancetype)initWithCellStyle:(MIMMessageCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSString *nibName = style == MIMMessageCellStyleIncoming?@"MIMMessageInCell":@"MIMMessageOutCell";
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
    if (self) {
        _style = style;
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)awakeFromNib {

    self.avatarSize         = MIM_AVATAR_SIZE;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)avatarClick:(id)sender {
    if (self.avatarClick) {
        self.avatarClick(self.atIndex);
    }
}

#pragma mark - setter -

- (void)setMessageContentView:(UIView *)messageContentView
{
    if (_messageContentView) {
        if (_messageContentView != messageContentView) { //存在 并且和之前的不是同一个view
            [_messageContentView removeFromSuperview];
            [self.contentView addSubview:messageContentView];
            _messageContentView = messageContentView;
        }
        else{
            //存在 并且和之前的是同一个view 不做操作
            return;
        }

    }
    else{
        //不存在
        _messageContentView = messageContentView;
        [self.contentView addSubview:_messageContentView];
    }

    
    [_messageContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //创建约束
        
    NSLayoutConstraint *leadingCt = nil;
    if (self.style == MIMMessageCellStyleOutgoing) {
        leadingCt = [NSLayoutConstraint constraintWithItem:self.avatarButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_messageContentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:MIM_SPACE_BETWEEN_AVATAR];
    }
    else{
        leadingCt = [NSLayoutConstraint constraintWithItem:self.avatarButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_messageContentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-MIM_SPACE_BETWEEN_AVATAR];
    }
    
    NSLayoutConstraint *topCt = [NSLayoutConstraint constraintWithItem:self.nicknameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_messageContentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:MIM_SPACE_BETWEEN_NICKNAME];
    
    self.contentMHC = [NSLayoutConstraint constraintWithItem:self.messageContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:0];
    
    self.contentMVC = [NSLayoutConstraint constraintWithItem:self.messageContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:0];
    
    [self.contentView addConstraints:@[leadingCt, topCt, self.contentMHC, self.contentMVC]];
    [self updateConstraints];

}

- (void)setMessageContentSize:(CGSize)messageContentSize
{
    //与原来相同 不做操作
    if (CGSizeEqualToSize(_messageContentSize, messageContentSize)) {
        return;
    }
    _messageContentSize = messageContentSize;
    
    self.contentMHC.constant = messageContentSize.height;
    self.contentMVC.constant = messageContentSize.width;
    
    [self updateConstraintsIfNeeded];
    
}

- (void)setMessageTime:(NSString *)messageTime
{
    _messageTime = messageTime;
    if (_messageTime) {
        self.timeHeightConstraint.constant = MIM_TIME_LABEL_HEIGHT;
    }
    else{
        self.timeHeightConstraint.constant = 0.0f;
    }
    [self updateConstraintsIfNeeded];
    
    self.timeLabel.text = self.messageTime;

}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    if (_nickName) {
        self.nicknameHeightConstraint.constant = MIM_NICKNAME_LABEL_HEIGHT;
    }
    else{
        self.nicknameHeightConstraint.constant = 0.0f;
    }
    [self updateConstraintsIfNeeded];
    
    self.nicknameLabel.text = self.nickName;

}

- (void)setAvatar:(MIMImageModel *)avatar
{
    if (_avatar == avatar) {
        return;
    }
    
    if (avatar) {
        NSString * previousAvatarUrl = _avatar.thumbUrl?_avatar.thumbUrl:_avatar.imageUrl;
        NSString * avatarUrl = avatar?(avatar.thumbUrl?avatar.thumbUrl:avatar.imageUrl):nil;
        //如果存在新url 并且存在前url 并且地址相同 则不做操作，否则重新设置
        if (avatarUrl && previousAvatarUrl
            && [previousAvatarUrl isEqualToString:avatarUrl]) {
        }
        else{
            _avatar = avatar;
            [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal placeholderImage:self.avatar.placeHolderImage];
        }
        
    }
}

- (void)setShowError:(BOOL)showError
{
    _showError = showError;
    if (showError) {
        [self.contentView bringSubviewToFront:self.errorButton];
        self.errorButton.hidden = NO;
    }
    else{
        self.errorButton.hidden = YES;
    }
}

- (UIButton *)errorButton
{
    if (!_errorButton) {
        _errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _errorButton.frame = CGRectMake(0, 0, 20.0, 20.0);
//        [_errorButton setTitle:@"!" forState:UIControlStateNormal];
        [_errorButton setImage:[UIImage imageNamed:@"message_fail"] forState:UIControlStateNormal];
        [_errorButton addTarget:self action:@selector(errorButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_errorButton];
        [_errorButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *leadingCt = [NSLayoutConstraint constraintWithItem:self.messageContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_errorButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:3.0f];
        if (self.style == MIMMessageCellStyleIncoming) {
            leadingCt = [NSLayoutConstraint constraintWithItem:self.messageContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_errorButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:3.0f];
        }
        
        NSLayoutConstraint *centerCt = [NSLayoutConstraint constraintWithItem:_errorButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.messageContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0f];
        
        NSLayoutConstraint *widthCt  = [NSLayoutConstraint constraintWithItem:_errorButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:30.0];
        
        NSLayoutConstraint *heightCt  = [NSLayoutConstraint constraintWithItem:_errorButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:30.0];

        
        [self.contentView addConstraints:@[leadingCt, centerCt, widthCt, heightCt]];
        
    }
    return _errorButton;
}

- (void)errorButtonClick
{
    if(self.errorClick){
        self.errorClick(self.atIndex);
    }
}

@end
