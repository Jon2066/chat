//
//  MyChatViewController.m
//  MyIM
//
//  Created by Jonathan on 15/8/11.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MyChatViewController.h"
#import "MIMMessageTextView.h"
#import "MIMMessageImageView.h"
#import "MIMMessageVoiceView.h"

#import "MIMMessage.h"

#import "MIMVoiceRecorder.h"

#import "NSDate+Utils.h"

#import "MIMAudioPlayer.h"

@interface MyChatViewController ()<MIMChatViewDataSource, MIMChatMediaDelegate, MIMChatViewDelegate>

//聊天双方头像 //多人可用字典 key为userId
@property (strong, nonatomic) MIMImageModel *incomingAvatarImage;
@property (strong, nonatomic) MIMImageModel *outgoingAvatarImage;

@property (strong, nonatomic) NSMutableArray *messageArray;

@property (strong, nonatomic) MIMMessageVoiceView *playingVoiceView;

@end

@implementation MyChatViewController

- (instancetype)initWithNib
{
    self = [super initWithNib];
    if (self) {
        self.dataSource = self;
        self.mediaDelagate = self;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.playingVoiceView) {
        [self.playingVoiceView stopPlay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter -

- (MIMImageModel *)incomingAvatarImage
{
    if (!_incomingAvatarImage) {
        _incomingAvatarImage = [[MIMImageModel alloc] initWithThumbUrl:@"http://img.hb.aicdn.com/66f4edb88dd568bf042436c1eeafe8fab5859aee1c4e2-BoNr5g_fw658" imageUrl:nil placeHolderImage:nil];
    }
    return _incomingAvatarImage;
}
- (MIMImageModel *)outgoingAvatarImage
{
    if (!_outgoingAvatarImage) {
        _outgoingAvatarImage = [[MIMImageModel alloc] initWithThumbUrl:@"http://b.hiphotos.baidu.com/image/pic/item/fc1f4134970a304e5c52aefdd3c8a786c9175c40.jpg" imageUrl:nil placeHolderImage:nil];
    }
    return _outgoingAvatarImage;
}

- (NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}


#pragma mark - chatView DataSource -

#pragma mark - messageContentView -

- (UIView *)loadMessageTextContentView:(UIView *)messageContentView style:(MIMMessageCellStyle)style message:(MIMMessage *)message
{
    MIMMessageTextView *textView = nil;
    //没有contentView则创建
    if (!messageContentView) {
        textView = [[MIMMessageTextView alloc] initFromNib];
        messageContentView = textView;
    }
    else{
        textView = (MIMMessageTextView *)messageContentView;
    }
    [textView loadViewWithMessageText:message.messageText messageCellStyle:style];
    
    return messageContentView;
}

- (UIView *)loadMessageImageContentView:(UIView *)messageContentView style:(MIMMessageCellStyle)style message:(MIMMessage *)message atIndex:(NSInteger)index
{
    MIMMessageImageView *imageView = nil;
    if (!messageContentView) {
        imageView = [[MIMMessageImageView alloc] initFromNib];
        //接收image点击操作
        [imageView receiveImageTapWithBlock:^(MIMMessageImageView *messageImageView) {
            //TODO:: 点击后操作
        }];
        messageContentView = imageView;
    }
    else{
        imageView = (MIMMessageImageView *)messageContentView;
    }
    if (message.imageModel.thumbUrl) {
        [imageView loadViewWithImageUrl:message.imageModel.thumbUrl messageCellStyle:style atIndex:index];
    }
    else{
        [imageView loadViewWithImage:message.imageModel.placeHolderImage messageCellStyle:style atIndex:index];
    }
    return messageContentView;
}

- (UIView *)loadMessageVoiceContentView:(UIView *)messageContentView style:(MIMMessageCellStyle)style message:(MIMMessage *)message
{
    MIMMessageVoiceView *voiceView = nil;
    if (!messageContentView) {
        __weak typeof(self) weakSelf = self;
        voiceView = [[MIMMessageVoiceView alloc] initFromNibWithStartPlay:^(MIMMessageVoiceView *playView) {
            if (weakSelf.playingVoiceView) {
                [weakSelf.playingVoiceView stopPlay];
            }
            weakSelf.playingVoiceView = playView;
        } endPlay:^(MIMMessageVoiceView *playView) {
            weakSelf.playingVoiceView = nil;
        }];
        
        messageContentView = voiceView;
    }
    else{
        voiceView = (MIMMessageVoiceView *)messageContentView;
    }
    [voiceView loadViewWithVoiceFileName:message.mediaFileName messageCellStyle:style];
    return messageContentView;
}


#pragma mark - chatView DataSource -

- (UIView *)chatViewMessageContentView:(UIView *)contentView cellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index
{
    MIMMessage *message = [self.messageArray objectAtIndex:index];
    
    if (message.messageType == MIMMessageTypeText) {//文本消息创建
        return [self loadMessageTextContentView:contentView style:style message:message];
    }
    else if (message.messageType == MIMMessageTypeImage){ //图片视图创建
        return  [self loadMessageImageContentView:contentView style:style message:message atIndex:index];
    }
    else if (message.messageType == MIMMessageTypeVoice){
        return  [self loadMessageVoiceContentView:contentView style:style message:message];
    }
    return contentView;
}


- (CGSize)chatViewMessageContentViewSizeForCellAtIndex:(NSInteger)index
{
    MIMMessage *message = [self.messageArray objectAtIndex:index];
    
    if (message.messageType == MIMMessageTypeText) {//文本消息创建
        return [MIMMessageTextView getTextViewSizeWithText:message.messageText minHeight:MIM_AVATAR_SIZE.height];
    }
    else if (message.messageType == MIMMessageTypeImage){ //图片视图创建
        return [MIMMessageImageView getImageViewSizeWithImageSize:message.imageModel.imageSize];
    }
    else if (message.messageType == MIMIuputTypeVoice){
        CGFloat duration = [MIMAudioPlayer getAudioDurationWithFileName:message.mediaFileName];
        return [MIMMessageVoiceView getViewSizeWithDuration:duration];
    }
    return CGSizeZero;
}

- (MIMImageModel *)chatViewAvatarWithCellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index
{
    if (style == MIMMessageCellStyleOutgoing) {
        return self.outgoingAvatarImage;
    }
    else if (style == MIMMessageCellStyleIncoming){
        return self.incomingAvatarImage;
    }
    return nil;
}

- (NSString *)chatViewNicknameForCellAtIndex:(NSInteger)index
{
    return nil;
}

- (NSString *)chatViewMessageTimeForCellAtIndex:(NSInteger)index
{
    MIMMessage *message = [self.messageArray objectAtIndex:index];
    
    //比较上一个时间  没有上一个或者与上一个时间相差两分钟以上 显示这条的时间
    if (index > 0) {
        MIMMessage *previousMessage = [self.messageArray objectAtIndex:index - 1];
        if (([message.date timeIntervalSince1970] - 120.0) > [previousMessage.date timeIntervalSince1970] ) {
            return [message.date convertToString];
        }
    }
    else{
        return [message.date convertToString];
    }
    
    return nil;
}

- (BOOL)chatViewShowErrorForCellAtIndex:(NSInteger)index
{
    MIMMessage *message = [self.messageArray objectAtIndex:index];
    return NO;
}


/**
 *  消息显示类型
 */
- (MIMMessageCellStyle)chatViewCellStyleAtIndex:(NSInteger)index
{
    //是自己发的还是别人发的  或者是 自定义类型
    MIMMessage *message = [self.messageArray objectAtIndex:index];
//    if(message.isMySend){
//        return MIMMessageCellStyleOutgoing;
//    }
    return MIMMessageCellStyleIncoming;
}

/**
 *  消息类型 复用id
 *  每一种消息类型 指定一个id 用来复用
 */
- (NSString *)chatViewessageTypeReusableIdentifierAtIndex:(NSInteger)index
{
    MIMMessage *message = [self.messageArray objectAtIndex:index];
    if (message.messageType == MIMIuputTypeVoice) {
        return @"kMIMMessageVoice";
    }
    else if(message.messageType == MIMIuputTypeText){
        return @"kMIMMessageText";
    }
    return @"kMIMMessageImage";
}


- (NSInteger)chatViewNumberOfRows
{
    return self.messageArray.count;
}


#pragma mark - chatView dalegate -
- (void)chatViewWillSendMessageText:(NSString *)text
{
    MIMMessage *message = [[MIMMessage alloc] init];
    message.senderId = @"1";
    message.senderNickname = @"me";
    message.messageType = random() % 2 + 1;
    message.messageText = text;
    message.mediaFileName = nil;
    message.date = [NSDate date];
    [self.messageArray addObject:message];
    [self finishReceiveNewMessageWithCount:1 animated:YES];
}


- (void)chatViewFinishRecordWithFileName:(NSString *)filename
{
    MIMMessage *message = [[MIMMessage alloc] init];
    message.senderId = @"1";
    message.senderNickname = @"me";
    message.messageType = MIMMessageTypeVoice;
    message.mediaFileName = filename;
    message.messageText = nil;;
    message.date = [NSDate date];
    [self.messageArray addObject:message];
    [self finishReceiveNewMessageWithCount:1 animated:YES];
}

- (void)chatViewFinishSelectWithImage:(UIImage *)image
{
    //缩略图 用于显示
    UIImage *thumbImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.1)];
    
    MIMMessage *message = [[MIMMessage alloc] init];
    message.senderId = @"1";
    message.senderNickname = @"me";
    message.messageType = MIMMessageTypeImage;
    message.imageModel = [[MIMImageModel alloc] initWithThumbUrl:nil imageUrl:nil size:thumbImage.size placeHolderImage:thumbImage];
    message.mediaFileName = nil;
    message.date = [NSDate date];
    
    [self.messageArray addObject:message];
    [self finishReceiveNewMessageWithCount:1 animated:YES];
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
