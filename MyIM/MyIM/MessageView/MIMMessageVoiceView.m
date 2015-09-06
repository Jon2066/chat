//
//  MIMMessageVoiceView.m
//  MyIM
//
//  Created by Jonathan on 15/8/19.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMMessageVoiceView.h"

#import "MIMAudioPlayer.h"

typedef void(^PlayStateFeedbockBlock)(MIMMessageVoiceView *playView);

@interface MIMMessageVoiceView ()
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) MIMMessageCellStyle style;
@property (strong, nonatomic) NSString *fileName;

@property (strong, nonatomic) PlayStateFeedbockBlock startPlay;
@property (strong, nonatomic) PlayStateFeedbockBlock endPlay;

@property (assign, nonatomic) NSInteger voiceDuration;
@end

@implementation MIMMessageVoiceView

- (instancetype)initFromNibWithStartPlay:(void(^)(MIMMessageVoiceView *playView))startPlay endPlay:(void(^)(MIMMessageVoiceView *playView))endPlay
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIMMessageVoiceView class]) owner:nil options:nil] lastObject];
    if (self) {
        self.style = - 100;
        _isPlaying = NO;
        self.startPlay = startPlay;
        self.endPlay = endPlay;
    }
    return self;
}

- (void)loadViewWithVoiceFileName:(NSString *)fileName messageCellStyle:(MIMMessageCellStyle)style
{
    self.fileName = fileName;
    
    [self.voiceButton.imageView stopAnimating];
    
    
    if (self.style != style) {
        self.style = style;
        if (style == MIMMessageCellStyleOutgoing) {
            [self.voiceButton setBackgroundImage:[[UIImage imageNamed:@"chatto_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)] forState:UIControlStateNormal];
            [self.voiceButton setImage:[UIImage imageNamed:@"chatto_voice3"] forState:UIControlStateNormal];
            
            self.voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            self.voiceButton.imageView.animationImages = @[[UIImage imageNamed:@"chatto_voice1"],
                                                           [UIImage imageNamed:@"chatto_voice2"],
                                                           [UIImage imageNamed:@"chatto_voice3"]];
            self.voiceButton.imageView.animationDuration = 1;

            [self.timeLabel setTextAlignment:NSTextAlignmentLeft];

            [self.timeLabel setTextColor:[UIColor whiteColor]];
        }
        else if (style == MIMMessageCellStyleIncoming){
            [self.voiceButton setBackgroundImage:[[UIImage imageNamed:@"chatfrom_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)] forState:UIControlStateNormal];
            [self.voiceButton setImage:[UIImage imageNamed:@"chatfrom_voice3"] forState:UIControlStateNormal];
            
            self.voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            self.voiceButton.imageView.animationImages = @[[UIImage imageNamed:@"chatfrom_voice1"],
                                                           [UIImage imageNamed:@"chatfrom_voice2"],
                                                           [UIImage imageNamed:@"chatfrom_voice3"]];
            self.voiceButton.imageView.animationDuration = 1;

            [self.timeLabel setTextAlignment:NSTextAlignmentRight];
            
            [self.timeLabel setTextColor:[UIColor darkGrayColor]];
        }
    }
    
    self.voiceDuration = [MIMAudioPlayer getAudioDurationWithFileName:fileName];

    [self.timeLabel setText:[NSString stringWithFormat:@"%ld's",self.voiceDuration]];
    
    CGSize size = [MIMMessageVoiceView getViewSizeWithDuration:self.voiceDuration];

//    self.voiceButton.bounds = CGRectMake(0, 0, size.width, size.height);
    

    if(style == MIMMessageCellStyleOutgoing){
        self.voiceButton.imageEdgeInsets = UIEdgeInsetsMake(0, size.width - 35, 0, 0);
    }
    else if (style == MIMMessageCellStyleIncoming){
        self.voiceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, size.width - 35);
    }
}

- (void)stopPlay
{
    if (!self.isPlaying) {
        return;
    }
    [[MIMAudioPlayer shareAudioPlayer] stopPlay];
    [self.voiceButton.imageView stopAnimating];
    _isPlaying = NO;
}

- (void)play
{
    if (self.isPlaying) {
        return;
    }
    
    [self.voiceButton.imageView startAnimating];
    _isPlaying = YES;
    if (self.startPlay) {
        self.startPlay(self);
    }
    [[MIMAudioPlayer shareAudioPlayer] playVoiceMessageWithFileName:self.fileName playFinishBlock:^{
        if (self.endPlay) {
            self.endPlay(self);
        }
        [self.voiceButton.imageView stopAnimating];
        _isPlaying = NO;
    }];
}

- (IBAction)voiceButtonClick:(id)sender {
    
    if (self.isPlaying) {
        [self stopPlay];
    }
    else{
        [self play];
    }
}

+ (CGSize)getViewSizeWithDuration:(CGFloat)duration
{
    //TODO:: 处理语音视图 长度 self.voiceDuration
    return CGSizeMake(MIM_MESSAGE_MIN_VOICE_WIDTH + (MIM_MESSAGE_MAX_VOICE_WIDTH - MIM_MESSAGE_MIN_VOICE_WIDTH) / 60.0 * duration, 45.0f);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
