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

@interface MyChatViewController ()<MIMChatViewDataSource, MIMChatMediaDelegate>

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
        _incomingAvatarImage = [[MIMImageModel alloc] initWithThumbUrl:nil imageUrl:[NSURL URLWithString:@"http://img.hb.aicdn.com/66f4edb88dd568bf042436c1eeafe8fab5859aee1c4e2-BoNr5g_fw658"] placeHolderImage:nil];
    }
    return _incomingAvatarImage;
}
- (MIMImageModel *)outgoingAvatarImage
{
    if (!_outgoingAvatarImage) {
        _outgoingAvatarImage = [[MIMImageModel alloc] initWithThumbUrl:nil imageUrl:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/fc1f4134970a304e5c52aefdd3c8a786c9175c40.jpg"] placeHolderImage:nil];
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

/**
 *  设置 一个 cell中显示消息内容的view
 */
- (MIMMessageContent *)chatViewMessageContentView:(MIMMessageContent *)messageContent cellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index
{
    //没有content 则创建
    if(!messageContent){
        messageContent = [[MIMMessageContent alloc] init];
    }
    
    MIMMessage *message = [self.messageArray objectAtIndex:index];

    if (message.messageType == MIMMessageTypeText) {//文本消息创建
        
        MIMMessageTextView *textView = nil;
        //没有contentView则创建
        if (!messageContent.contentView) {
            textView = [[MIMMessageTextView alloc] initFromNib];
            messageContent.contentView = textView;
        }
        else{
                
            textView = (MIMMessageTextView *)messageContent.contentView;
        }
        [textView loadViewWithMessageText:message.messageText messageCellStyle:style];
        
        messageContent.contentSize = [textView getTextViewSizeWithMinHeight:MIM_AVATAR_SIZE.height];
        
    }
    else if (message.messageType == MIMMessageTypeImage){ //图片视图创建
        
        MIMMessageImageView *imageView = nil;
        if (!messageContent.contentView) {
            imageView = [[MIMMessageImageView alloc] initFromNib];
            //接收image点击操作
            [imageView receiveImageTapWithBlock:^(MIMMessageImageView *messageImageView) {
                //TODO:: 点击后操作
            }];
            messageContent.contentView = imageView;
        }
        else{
            imageView = (MIMMessageImageView *)messageContent.contentView;
        }
        if (message.imageModel.thumbUrl) {
            [imageView loadViewWithImageUrl:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/fc1f4134970a304e5c52aefdd3c8a786c9175c40.jpg"] messageCellStyle:style atIndex:index];
            messageContent.contentSize = [imageView getImageViewSizeWithImageSize:CGSizeMake(150, 150)];
        }
        else{
            [imageView loadViewWithImage:message.imageModel.placeHolderImage messageCellStyle:style atIndex:index];
            messageContent.contentSize = [imageView getImageViewSizeWithImageSize:message.imageModel.imageSize];
        }

        
    }
    else if (message.messageType == MIMMessageTypeVoice){
        
        MIMMessageVoiceView *voiceView = nil;
        if (!messageContent.contentView) {
            __weak typeof(self) weakSelf = self;
            voiceView = [[MIMMessageVoiceView alloc] initFromNibWithStartPlay:^(MIMMessageVoiceView *playView) {
                if (weakSelf.playingVoiceView) {
                    [weakSelf.playingVoiceView stopPlay];
                }
                weakSelf.playingVoiceView = playView;
            } endPlay:^(MIMMessageVoiceView *playView) {
                weakSelf.playingVoiceView = nil;
            }];
            
            messageContent.contentView = voiceView;
        }
        else{
            voiceView = (MIMMessageVoiceView *)messageContent.contentView;
        }
        [voiceView loadViewWithVoiceFileName:message.mediaFileName messageCellStyle:style];
        
        messageContent.contentSize = [voiceView getViewSize];
        
    }
    
    // --- 通用设置 ------
    messageContent.avatar = ({
        
        MIMImageModel *model = nil;
        
        if (style == MIMMessageCellStyleOutgoing) {
           model = self.outgoingAvatarImage;
        }
        else if (style == MIMMessageCellStyleIncoming){
            model = self.incomingAvatarImage;
        }
        
        model;
    });
    
    messageContent.nickName = nil; //不显示昵称
    messageContent.messageTime = [message.date convertToString];
    
   //-----
    
    return messageContent;

}


/**
 *  消息显示类型
 */
- (MIMMessageCellStyle)chatViewCellStyleAtIndex:(NSInteger)index
{
    //是自己发的还是别人发的  或者是 自定义类型
    if(index % 3){
        return MIMMessageCellStyleOutgoing;
    }
    return MIMMessageCellStyleIncoming;
}

/**
 *  消息类型 复用id
 *  每一种消息类型 指定一个id 用来复用
 */
- (NSString *)chatViewessageTypeReusableIdentifierAtIndex:(NSInteger)index
{
    MIMMessage *message = [self.messageArray objectAtIndex:index];
    if (message.messageType == MIMMessageTypeVoice) {
        return @"kMIMMessageVoice";
    }
    else if(message.messageType == MIMMessageTypeText){
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
