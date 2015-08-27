//
//  MIMChatVoiceController.m
//  MyIM
//
//  Created by Jonathan on 15/8/21.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMChatMediaController.h"

#import "MIMVoiceRecorder.h"

#define kMIMMaxRecorderTime  60   //最长录音时间 60秒


@interface MIMChatMediaController ()

@property (strong, nonatomic) UIButton *voiceSwitchButton;  //语音和文本切换button

@property (strong, nonatomic) UIButton *voiceInputButton;  //语音输入按钮

@property (strong, nonatomic) UIButton *addItemButton;  //添加按钮

@property (assign, nonatomic) CGFloat  textToolbarHeight;

@property (strong, nonatomic) MIMVoiceRecorder *recorder;

@property (assign, nonatomic) BOOL      isRecordCancel;

@property (assign, nonatomic) BOOL      touchDown;
@end

@implementation MIMChatMediaController

- (instancetype)initWithNib
{
    self = [super initWithNib];
    if (self) {
        self.inputType = MIMIuputTypeText;
        self.isRecordCancel = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载工具栏 左右按钮
    MIMInputItemModel *leftModel = [[MIMInputItemModel alloc] initWithButtons:@[self.voiceSwitchButton] itemWidth:35.0];
    [self.inputToolbar setLeftItems:leftModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - getter -
- (UIButton *)voiceSwitchButton
{
    if (!_voiceSwitchButton) {
        _voiceSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceSwitchButton.frame = CGRectMake(0, 0, 35, 50);
        _voiceSwitchButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 7.5, 0);
        [_voiceSwitchButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceSwitchButton addTarget:self action:@selector(voiceSwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceSwitchButton;
}

- (UIButton *)voiceInputButton
{
    if (!_voiceInputButton) {
        _voiceInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _voiceInputButton.frame = CGRectMake(5, 5, 1, 1);
        _voiceInputButton.layer.cornerRadius  = 5.0f;
        _voiceInputButton.layer.borderWidth   = 0.5f;
        _voiceInputButton.layer.borderColor   = [UIColor blackColor].CGColor;
        _voiceInputButton.layer.masksToBounds = YES;
        
        [_voiceInputButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceInputButton setBackgroundImage:[[UIImage imageNamed:@"chat_send_message"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)] forState:UIControlStateNormal];
        [_voiceInputButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_voiceInputButton addTarget:self action:@selector(voiceInputButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_voiceInputButton addTarget:self action:@selector(voiceInputButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceInputButton addTarget:self action:@selector(voiceInputButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _voiceInputButton;
}

- (MIMVoiceRecorder *)recorder
{
    if (!_recorder) {
        __weak typeof(self) weakSelf = self;
        _recorder = [[MIMVoiceRecorder alloc]  initWithBlock:^(MIMVoiceRecorder *recorder, BOOL finished) {
            [weakSelf handleRecorder:recorder feedbackFinished:finished];
        }];
    }
    return _recorder;
}


- (void)handleRecorder:(MIMVoiceRecorder *)recorder feedbackFinished:(BOOL)finished
{
    if (finished) {
        if (self.isRecordCancel) {
            //取消录音
            
            self.isRecordCancel = NO;
        }
        else{
            if (recorder.recordCurrentTime < 0.5) { //录音小于0.5秒
//                NSLog(@"< 0.5");
            }
            else{
                if ([self.mediaDelagate respondsToSelector:@selector(chatViewFinishRecordWithFileName:)]) {
                    [self.mediaDelagate chatViewFinishRecordWithFileName:recorder.voiceFileName];
                }
            }
        }
    }
    else{
        
        //处理时间 
        
    }
}


#pragma mark - control event -

- (void)voiceSwitchButtonClick:(UIButton *)button
{
    if (self.inputType != MIMIuputTypeVoice) {
        self.inputType = MIMIuputTypeVoice;
        [self.voiceSwitchButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        self.textToolbarHeight = self.inputToolBarHeight;
        [self.textView resignFirstResponder];
        self.inputToolBarHeight = MIM_INPUT_TOOLBAR_HEIGHT;
        [self.inputToolbar setMiddelView:self.voiceInputButton];
        
    }
    else{
        self.inputType = MIMIuputTypeText;
        [self.voiceSwitchButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        self.inputToolBarHeight = self.textToolbarHeight;
        [self.inputToolbar setMiddelView:self.textView];
        [self.textView becomeFirstResponder];
    }
}

- (void)voiceInputButtonTouchDown:(UIButton *)button
{
    self.touchDown = YES;
    [button setTitle:@"松开 结束" forState:UIControlStateNormal];
    [self performSelector:@selector(startRecord) withObject:nil afterDelay:0.3f];
    
}

- (void)startRecord
{
    if (self.touchDown) {
        [self.recorder startRecordWithMaxRecordTime:kMIMMaxRecorderTime];
    }
}

- (void)voiceInputButtonTouchUpInside:(UIButton *)button
{
    self.touchDown = NO;
    [button setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recorder finishRecord];
}

- (void)voiceInputButtonTouchUpOutside:(UIButton *)button
{
    self.touchDown = NO;
    [button setTitle:@"按住 说话" forState:UIControlStateNormal];
    
    self.isRecordCancel = YES;
    [self.recorder finishRecord];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
