//
//  MIMMessageVoiceView.m
//  MyIM
//
//  Created by Jonathan on 15/8/19.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMMessageVoiceView.h"

#import "MIMAudioPlayer.h"

#import "MIMVoiceRecorder.h"

#define kMIMOpacityAnimationKey  @"kMIMOpacityAnimationKey"

typedef void(^PlayStateFeedbockBlock)(MIMMessageVoiceView *playView);

@interface MIMMessageVoiceView ()
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) MIMMessageCellStyle style;

@property (strong, nonatomic) MIMMessage *message;

@property (strong, nonatomic) PlayStateFeedbockBlock startPlay;
@property (strong, nonatomic) PlayStateFeedbockBlock endPlay;

@property (assign, nonatomic) NSInteger voiceDuration;

@property (strong, nonatomic) CABasicAnimation *opacityBaseAnimation;
@end

@implementation MIMMessageVoiceView

- (instancetype)initFromNibWithStyle:(MIMMessageCellStyle)style startPlay:(void (^)(MIMMessageVoiceView *))startPlay endPlay:(void (^)(MIMMessageVoiceView *))endPlay
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIMMessageVoiceView class]) owner:nil options:nil] lastObject];
    if (self) {
        self.style = style;
        _isPlaying = NO;
        self.startPlay = startPlay;
        self.endPlay = endPlay;
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    if (self.style == MIMMessageCellStyleOutgoing) {
        [self.voiceButton setBackgroundImage:[[UIImage imageNamed:@"chatto_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"chatto_voice3"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"chatto_voice3"] forState:UIControlStateHighlighted];

        self.voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        self.voiceButton.imageView.animationImages = @[[UIImage imageNamed:@"chatto_voice1"],
                                                       [UIImage imageNamed:@"chatto_voice2"],
                                                       [UIImage imageNamed:@"chatto_voice3"]];
        self.voiceButton.imageView.animationDuration = 1;
        self.voiceButton.imageView.animationRepeatCount = 0;

        [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
        
//        [self.timeLabel setTextColor:[UIColor whiteColor]];
    }
    else if (self.style == MIMMessageCellStyleIncoming){
        [self.voiceButton setBackgroundImage:[[UIImage imageNamed:@"chatfrom_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"chatfrom_voice3"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"chatfrom_voice3"] forState:UIControlStateHighlighted];

        self.voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        self.voiceButton.imageView.animationImages = @[[UIImage imageNamed:@"chatfrom_voice1"],
                                                       [UIImage imageNamed:@"chatfrom_voice2"],
                                                       [UIImage imageNamed:@"chatfrom_voice3"]];
        self.voiceButton.imageView.animationDuration = 1;
        self.voiceButton.imageView.animationRepeatCount = 0;
        [self.timeLabel setTextAlignment:NSTextAlignmentRight];
        
//        [self.timeLabel setTextColor:[UIColor darkGrayColor]];
    }

}
- (void)loadViewWithMessage:(MIMMessage *)message;
{
    self.message = message;
    
    [self.voiceButton.imageView stopAnimating];
    [self startPlay];
    [self.layer removeAnimationForKey:kMIMOpacityAnimationKey];
    NSString *fileName  = message.media.localFileName;
    [self.layer removeAnimationForKey:kMIMOpacityAnimationKey];
    if (message.media.isDownload) { //文件已经下载
        self.voiceButton.userInteractionEnabled = YES;
        self.voiceDuration = [MIMAudioPlayer getAudioDurationWithFileName:fileName];
        [self.timeLabel setText:[NSString stringWithFormat:@"%ld's",self.voiceDuration]];
    }
    else{ //文件还未下载
        self.voiceButton.userInteractionEnabled = NO;
        self.voiceDuration = MIMMessageMaxRecorderTime / 2;
        [self.timeLabel setText:nil];
        [self downloadData];
    }
    

    
    CGSize size = [MIMMessageVoiceView getViewSizeWithDuration:self.voiceDuration];

//    self.voiceButton.bounds = CGRectMake(0, 0, size.width, size.height);
    

    if(self.style == MIMMessageCellStyleOutgoing){
        self.voiceButton.imageEdgeInsets = UIEdgeInsetsMake(0, size.width - 35, 0, 0);
    }
    else if (self.style == MIMMessageCellStyleIncoming){
        self.voiceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, size.width - 35);
    }
}

- (void)stopPlay
{
    if (!self.isPlaying) {
        return;
    }
    _isPlaying = NO;
    [self.voiceButton.imageView stopAnimating];
    [[MIMAudioPlayer shareAudioPlayer] stopPlay];
}

- (void)play
{
    if (self.isPlaying) {
        return;
    }
    
    [self.voiceButton.imageView startAnimating];
    _isPlaying = YES;
    __weak typeof(self) weakSelf = self;
    [[MIMAudioPlayer shareAudioPlayer] playVoiceMessageWithFileName:self.message.media.localFileName playFinishBlock:^(BOOL complete) {
        if (weakSelf) {
            if (complete) {
                _isPlaying = NO;
                [weakSelf.voiceButton.imageView stopAnimating];
            }
            if (weakSelf.endPlay) {
                weakSelf.endPlay(weakSelf);
            }
        }
    }];
    
    if (self.startPlay) {
        self.startPlay(self);
    }
}

- (IBAction)voiceButtonClick:(id)sender {
    
    if (self.isPlaying) {
        [self stopPlay];
    }
    else{
        if(self.message.media.isDownload){
            [self play];
        }
        else{
            [self downloadData];
        }
    }
}

- (CABasicAnimation *)opacityBaseAnimation
{
    if (!_opacityBaseAnimation) {
        _opacityBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
        _opacityBaseAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        _opacityBaseAnimation.toValue = [NSNumber numberWithFloat:0.65f];//这是透明度。
        _opacityBaseAnimation.autoreverses = YES;
        _opacityBaseAnimation.duration = 0.5f;
        _opacityBaseAnimation.repeatCount = MAXFLOAT;
        _opacityBaseAnimation.removedOnCompletion = NO;
        _opacityBaseAnimation.fillMode = kCAFillModeForwards;
        _opacityBaseAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    }
    return _opacityBaseAnimation;
   
}
- (void)downloadData
{
    [self.layer addAnimation:self.opacityBaseAnimation forKey:kMIMOpacityAnimationKey];
    
    NSString *url      = self.message.media.remoteUrl;
    NSString *savePath = [MIMVoiceRecorder voicePathWithFileName:self.message.media.localFileName];
    __weak typeof(self) weakSelf = self;
//    [loadVoice completionBlock:^(BOOL success, NSString *remoteUrl) {
//        if (success) {
//            if (weakSelf && [weakSelf.message.media.remoteUrl isEqualToString:remoteUrl]) {
//                weakSelf.message.media.isDownload = YES;
//                [weakSelf.layer removeAnimationForKey:kMIMOpacityAnimationKey];
//                [weakSelf loadViewWithMessage:weakSelf.message];
//            }
//        }
//        else{
//            [weakSelf.layer removeAnimationForKey:kMIMOpacityAnimationKey];
//        }
//    }];
}

+ (CGSize)getViewSizeWithDuration:(CGFloat)duration
{
    //TODO:: 处理语音视图 长度 self.voiceDuration
    return CGSizeMake(MIM_MESSAGE_MIN_VOICE_WIDTH + (MIM_MESSAGE_MAX_VOICE_WIDTH - MIM_MESSAGE_MIN_VOICE_WIDTH) / MIMMessageMaxRecorderTime * duration, 45.0f);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
