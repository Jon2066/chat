//
//  MIMMessageVoiceView.h
//  MyIM
//
//  Created by Jonathan on 15/8/19.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMDefine.h"

#import "MIMMessage.h"
@interface MIMMessageVoiceView : UIView

@property (assign, nonatomic, readonly) BOOL  isPlaying;

- (instancetype)initFromNibWithStyle:(MIMMessageCellStyle)style startPlay:(void(^)(MIMMessageVoiceView *playView))startPlay endPlay:(void(^)(MIMMessageVoiceView *playView))endPlay;

- (void)loadViewWithMessage:(MIMMessage *)message;

- (void)play;

- (void)stopPlay;


+ (CGSize)getViewSizeWithDuration:(CGFloat)duration;
@end
