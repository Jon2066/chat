# chat
IM聊天
1.2
  修改了cell的实现方式 修复一些严重问题 现在应该可以用了 
下一步：
1.文本消息  拦截url
2.语音听筒扬声器切换
3.正在播放语音时  按录制语音则停止播放语音
4.点击查看大图
6.长按message 工具条

1.1 

（1）键盘收起优化
（2）图片输入实现   

1.0

（1）IM文件下为基础实现
    消息布局 以及 文本输入
    若只需要文本输入 则继承MIMChatController实现datasource和delegate即可
（2）实现文本、图片和语音显示
（3）实现语音等多媒体输入则需继承MIMChatMediaController
    目前只有语音输入  其他媒体形式请在MIMChatMediaController中自定义实现
 


代码：
    
    
    输入栏支持自定义

    左右按钮实现通过model 中间传入自定义view 具体实现查看MIMChatMediaController

    MIMInputItemModel *leftModel = [[MIMInputItemModel alloc] initWithButtons:@[self.voiceSwitchButton] itemWidth:35.0];
    [self.inputToolbar setLeftItems:leftModel];
    
    [self.inputToolbar setMiddelView:self.textView];
    
    
代码:

#pragma mark - chatView dataSource and dalegate -

/**
*  获取cell消息内容 
*  contentView可复用  nil时创建
*  若消息类型为完全自定义(MIMMessageCellStyleOthers) 则显示完全为contentView
*/
- (UIView *)chatViewMessageContentView:(UIView *)contentView cellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index;

/**
*  获得消息内容的显示大小  MIMMessageCellStyleOthers 只参考高度 宽度为屏宽 
*/
-  (CGSize )chatViewMessageContentViewSizeForCellAtIndex:(NSInteger)index;

/**
*  昵称  nil则不显示
*/
- (NSString *)chatViewNicknameForCellAtIndex:(NSInteger)index;

/**
*  消息时间 nil则不显示
*/
- (NSString *)chatViewMessageTimeForCellAtIndex:(NSInteger)index;

/**
*  头像
*/
- (MIMImageModel *)chatViewAvatarWithCellStyle:(MIMMessageCellStyle)style forCellAtIndex:(NSInteger)index;

/**
*  是否显示发送错误提示
*/
- (BOOL)chatViewShowErrorForCellAtIndex:(NSInteger)index;

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


//目前只实现了文本、图片和语音代理

- (void)chatViewWillSendMessageText:(NSString *)text;

- (void)chatViewFinishRecordWithFileName:(NSString *)filename;

- (void)chatViewFinishSelectWithImage:(UIImage *)image;

