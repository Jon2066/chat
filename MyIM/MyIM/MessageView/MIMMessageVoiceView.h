//
//  MIMMessageVoiceView.h
//  MyIM
//
//  Created by Jonathan on 15/8/19.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMDefine.h"

@interface MIMMessageVoiceView : UIView

@property (assign, nonatomic, readonly) BOOL  isPlaying;

- (instancetype)initFromNibWithStartPlay:(void(^)(MIMMessageVoiceView *playView))startPlay endPlay:(void(^)(MIMMessageVoiceView *playView))endPlay;

- (void)loadViewWithVoiceFileName:(NSString *)fileName messageCellStyle:(MIMMessageCellStyle)style;

- (CGSize)getViewSize;

- (void)play;

- (void)stopPlay;
@end
