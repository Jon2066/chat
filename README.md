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
    
    

#pragma mark - chatView dataSource and dalegate -

具体代码请参照MyChatViewController  在其中实现自己的代码

通过messageContent来复用
如果传回messageContent为nil 则需要创建一个实例
若messageContent不为nil 则复用即可
另外 messageContent支持完全自定义（没有时间、头像和昵称等不必赋值） 消息类型使用MIMMessageCellStyleOthers  显示完全是messageContent.contentView

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


//目前只实现了文本和语音代理

- (void)chatViewWillSendMessageText:(NSString *)text;

- (void)chatViewFinishRecordWithFileName:(NSString *)filename;

    
