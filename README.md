# chat
IM聊天

1.0

（1）IM文件下为基础实现
    消息布局 以及 文本输入
    若只需要文本输入 则继承MIMChatController实现datasource和delegate即可
（2）实现文本、图片和语音显示
（3）实现语音等多媒体输入则需继承MIMChatMediaController
    目前只有语音输入  其他媒体形式请在MIMChatMediaController中自定义实现
 
    
下一步：
1.文本消息  拦截url
2.语音听筒扬声器切换
3.正在播放语音时  按录制语音则停止播放语音
4.点击查看大图
5.键盘收起 优化（键盘监听）
6.长按message 工具条
7.图片等其他媒体输入实现




代码：
    
    
    输入栏支持自定义

    左右按钮实现通过model 中间传入自定义view 具体实现查看MIMChatMediaController

    MIMInputItemModel *leftModel = [[MIMInputItemModel alloc] initWithButtons:@[self.voiceSwitchButton] itemWidth:35.0];
    [self.inputToolbar setLeftItems:leftModel];
    
    [self.inputToolbar setMiddelView:self.textView];

    
    具体代码请参照MyChatViewController  在其中实现自己的代码
    
chatView DataSource  

/**
*  自定义实现cell消息内容
*  messageContent可复用  传入为nil时创建  非nil时修改model即可
*/
- (MIMMessageContent *)chatViewMessageContentView:(MIMMessageContent *)messageContent cellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index;

/**
*  对话cell 头像左、右或其他类型 自定义的其他类型则不必传入（头像、昵称、时间）这些参数
*/
- (MIMMessageCellStyle)chatViewCellStyleAtIndex:(NSInteger )index;

/**
*  返回消息类型标识 用于复用(messageContent 复用id)
*/
- (NSString *)chatViewessageTypeReusableIdentifierAtIndex:(NSInteger)index;

/**
*  消息数量
*/
- (NSInteger)chatViewNumberOfRows;


通过messageContent来复用
如果传回messageContent为nil 则需要创建一个实例
若messageContent不为nil 则复用即可
另外 messageContent支持完全自定义（没有时间、头像和昵称等不必赋值） 消息类型使用MIMMessageCellStyleOthers  显示完全是messageContent.contentView
代码如下
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
//这里需要指定 消息内容的显示大小
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
[imageView loadViewWithImageUrl:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/fc1f4134970a304e5c52aefdd3c8a786c9175c40.jpg"] messageCellStyle:style atIndex:index];
messageContent.contentSize = [imageView getImageViewSizeWithImageSize:CGSizeMake(150, 150)];

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

//目前只实现了文本和语音代理

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
