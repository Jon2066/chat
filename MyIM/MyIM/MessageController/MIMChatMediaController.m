//
//  MIMChatVoiceController.m
//  MyIM
//
//  Created by Jonathan on 15/8/21.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMChatMediaController.h"

#import "MIMVoiceRecorder.h"

#import "MIMShareMoreView.h"

#import "MIMImagePicker.h"

#import "MIMButton.h"

#import <AVFoundation/AVFoundation.h>

#define ShareMoreViewHeight  235.0f

@interface MIMChatMediaController ()<MIMChatViewDelegate>

@property (strong, nonatomic) UIButton  *voiceSwitchButton;  //语音和文本切换button

@property (strong, nonatomic) MIMButton *voiceInputButton;  //语音输入按钮

@property (strong, nonatomic) UIButton  *addItemButton;  //添加按钮

@property (strong, nonatomic) MIMShareMoreView   *shareMoreView;

@property (strong, nonatomic) MIMImagePicker *imagePicker; //图片选择

@property (strong, nonatomic) NSLayoutConstraint *shareMoreViewBottomConstraint;//shareMoreView距离底部的高度

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
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加shareMoreView
    [self addShareMoreView];
    
    //加载工具栏 左右按钮
    MIMInputItemModel *leftModel = [[MIMInputItemModel alloc] initWithButtons:@[self.voiceSwitchButton] itemWidth:40.0];
    [self.inputToolbar setLeftItems:leftModel];
    
    MIMInputItemModel *rightModel = [[MIMInputItemModel alloc] initWithButtons:@[self.addItemButton] itemWidth:40.0];
    [self.inputToolbar setRightItems:rightModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


- (void)addShareMoreView
{
    [self.view addSubview:self.shareMoreView];
//    [self.view sendSubviewToBack:self.shareMoreView];
    
    [self.shareMoreView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *mHC = [NSLayoutConstraint constraintWithItem:_shareMoreView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:ShareMoreViewHeight];
    
    NSLayoutConstraint *leadingCt = [NSLayoutConstraint constraintWithItem:_shareMoreView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    NSLayoutConstraint *trailingCt = [NSLayoutConstraint constraintWithItem:_shareMoreView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    self.shareMoreViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_shareMoreView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:ShareMoreViewHeight];
    
    [self.view addConstraints:@[mHC, leadingCt, trailingCt, self.shareMoreViewBottomConstraint]];
    
    [self.view updateConstraintsIfNeeded];
}


- (void)setShareMoreViewShow:(BOOL)show
{
    __weak typeof(self) weakSelf = self;
    if (show) {
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakSelf updateToolbarBottomDistance:ShareMoreViewHeight animated:NO];
            weakSelf.shareMoreViewBottomConstraint.constant = 0;
            [weakSelf.view layoutSubviews];
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakSelf updateToolbarBottomDistance:0 animated:NO];
            weakSelf.shareMoreViewBottomConstraint.constant = ShareMoreViewHeight;
            [weakSelf.view layoutSubviews];
        } completion:nil];
    }
}

- (void)hiddenShareMoreView
{
    self.shareMoreViewBottomConstraint.constant = ShareMoreViewHeight;
    [self.view layoutSubviews];
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
        _voiceInputButton = [MIMButton buttonWithType:UIButtonTypeCustom];
        
        _voiceInputButton.frame = CGRectMake(5, 5, 200, 50);
//        _voiceInputButton.layer.cornerRadius  = 5.0f;
//        _voiceInputButton.layer.borderWidth   = 0.5f;
//        _voiceInputButton.layer.borderColor   = [UIColor blackColor].CGColor;
        _voiceInputButton.layer.masksToBounds = YES;
        
        [_voiceInputButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceInputButton setBackgroundImage:[[UIImage imageNamed:@"chat_send_message"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)] forState:UIControlStateNormal];
        [_voiceInputButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_voiceInputButton addTarget:self action:@selector(voiceInputButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_voiceInputButton addTarget:self action:@selector(voiceInputButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceInputButton addTarget:self action:@selector(voiceInputButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    }
    return _voiceInputButton;
}

- (UIButton *)addItemButton
{
    if (!_addItemButton) {
        _addItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addItemButton.frame = CGRectMake(5, 0, 35, 50);
        _addItemButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 7.5, 0);
        [_addItemButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_addItemButton addTarget:self action:@selector(addItemButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addItemButton;
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


- (MIMShareMoreView *)shareMoreView
{
    if (!_shareMoreView) {
        
        __weak typeof(self) weakSelf = self;
        _shareMoreView = [[MIMShareMoreView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ShareMoreViewHeight) itemClick:^(MIMShareMoreItemView *itemView) {
            [weakSelf handleShareMoreItemClick:itemView];
        }];
    }
    return _shareMoreView;
}

- (MIMImagePicker *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker= [[MIMImagePicker alloc] initWithRootViewController:self.navigationController];
    }
    return _imagePicker;
}

#pragma mark - control event -

- (void)voiceSwitchButtonClick:(UIButton *)button
{
    if (self.inputType == MIMIuputTypeMediaItems) {
        [self setShareMoreViewShow:NO];
    }
    
    if (self.inputType != MIMIuputTypeVoice && self.inputToolbar.middleItemView == self.textView) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                           delegate:nil
                                  cancelButtonTitle:@"好"
                                  otherButtonTitles:nil] show];
            }
        }];
        
        self.inputType = MIMIuputTypeVoice;
        [self.voiceSwitchButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        self.textToolbarHeight = self.inputToolBarHeight;
        [self.textView resignFirstResponder];
        self.inputToolBarHeight = MIM_INPUT_TOOLBAR_HEIGHT;
        [self.inputToolbar setMiddleItemView:self.voiceInputButton];
        
    }
    else{

        self.inputType = MIMIuputTypeText;
        [self.voiceSwitchButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        self.inputToolBarHeight = self.textToolbarHeight;
        [self.inputToolbar setMiddleItemView:self.textView];
        [self.textView becomeFirstResponder];
    }
}

- (void)voiceInputButtonTouchDown:(UIButton *)button
{
    self.touchDown = YES;
    [button setTitle:@"松开 结束" forState:UIControlStateNormal];
    [self startRecord];
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

- (void)addItemButtonClick
{
    if (self.inputType == MIMIuputTypeMediaItems) {
        return;
    }
    self.inputType = MIMIuputTypeMediaItems;
    
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    [self setShareMoreViewShow:YES];

    
}

#pragma mark - chatView deleagate -
- (void)chatViewShouldFinishEditing
{
    //收起shareMoreView
    if (self.inputType == MIMIuputTypeMediaItems) {
        self.inputType = MIMIuputTypeText;
        [self setShareMoreViewShow:NO];
    }
}

- (void)chatViewBeginTextEditing
{
    if (self.inputType == MIMIuputTypeMediaItems) {
        [self hiddenShareMoreView];
    }
    self.inputType = MIMIuputTypeText;
}



#pragma mark - handle media input -

//开始录音
- (void)startRecord
{
    if (self.touchDown) {
        if ([self.mediaDelagate respondsToSelector:@selector(chatViewStartVoiceInput)]) {
            [self.mediaDelagate chatViewStartVoiceInput];
        }
        [self.recorder startRecordWithMaxRecordTime:MIMMessageMaxRecorderTime];
    }
}

//处理其他媒体输入
- (void)handleShareMoreItemClick:(MIMShareMoreItemView *)itemView
{
    if (itemView.itemType == MIMItemTypePicture) {
        [self showImagePickerWithType:MIMImagePickerTypePhotoAlbum];
    }
    else if (itemView.itemType == MIMItemTypeTakePhoto){
        [self showImagePickerWithType:MIMImagePickerTypeCamera];
    }
}

//处理语音输入
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


/**
 *  选择图片
 */
- (void)showImagePickerWithType:(MIMImagePickerType)type
{
    __weak typeof(self) weakSelf = self;
    [self.imagePicker showImagePickerWithType:type completionBlock:^(UIImage *image) {
        if (image) {
            if ([weakSelf.mediaDelagate respondsToSelector:@selector(chatViewFinishSelectWithImage:)]) {
                [weakSelf.mediaDelagate chatViewFinishSelectWithImage:image];
            }
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    
}

@end
