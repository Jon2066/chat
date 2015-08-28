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

#define kMIMMaxRecorderTime  60   //最长录音时间 60秒

#define ShareMoreViewHeight  205.0f

@interface MIMChatMediaController ()<MIMChatViewDelegate>

@property (strong, nonatomic) UIButton *voiceSwitchButton;  //语音和文本切换button

@property (strong, nonatomic) UIButton *voiceInputButton;  //语音输入按钮

@property (strong, nonatomic) UIButton *addItemButton;  //添加按钮

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
    MIMInputItemModel *leftModel = [[MIMInputItemModel alloc] initWithButtons:@[self.voiceSwitchButton] itemWidth:35.0];
    [self.inputToolbar setLeftItems:leftModel];
    
    MIMInputItemModel *rightModel = [[MIMInputItemModel alloc] initWithButtons:@[self.addItemButton] itemWidth:35.0];
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
    if (show) {
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self updateToolbarBottomDistance:ShareMoreViewHeight animated:NO];
            self.shareMoreViewBottomConstraint.constant = 0;
            [self.view layoutSubviews];
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self updateToolbarBottomDistance:0 animated:NO];
            self.shareMoreViewBottomConstraint.constant = ShareMoreViewHeight;
            [self.view layoutSubviews];
        } completion:nil];
    }
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

- (UIButton *)addItemButton
{
    if (!_addItemButton) {
        _addItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addItemButton.frame = CGRectMake(0, 0, 35, 50);
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
        _imagePicker= [[MIMImagePicker alloc] initWithRootViewController:self];
    }
    return _imagePicker;
}

#pragma mark - control event -

- (void)voiceSwitchButtonClick:(UIButton *)button
{
    if (self.inputType != MIMIuputTypeVoice) {
        if (self.inputType == MIMIuputTypeMediaItems) {
            [self setShareMoreViewShow:NO];
        }
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



#pragma mark - handle media input -

//开始录音
- (void)startRecord
{
    if (self.touchDown) {
        [self.recorder startRecordWithMaxRecordTime:kMIMMaxRecorderTime];
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
    [self.imagePicker showImagePickerWithType:type completionBlock:^(UIImage *image) {
        if (image) {
            if ([self.mediaDelagate respondsToSelector:@selector(chatViewFinishSelectWithImage:)]) {
                [self.mediaDelagate chatViewFinishSelectWithImage:image];
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

@end
