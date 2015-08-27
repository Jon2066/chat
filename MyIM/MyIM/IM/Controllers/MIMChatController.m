//
//  MIMChatController.m
//  MyIM
//
//  Created by Jonathan on 15/8/10.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMChatController.h"

#import "MIMMessageTableCell.h"

#import "MIMMessageCommonCell.h"

static void *kMIMTextViewContentSizeContext = &kMIMTextViewContentSizeContext;

@interface MIMChatController ()<UITableViewDataSource, UITableViewDelegate>
//view
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  toolbar layout 高度和距离底部高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarButtomConstraint;

@property (strong, nonatomic) NSMutableDictionary *cellDictionary;
@end

@implementation MIMChatController

- (instancetype)initWithNib
{
    self = [super initWithNibName:NSStringFromClass([MIMChatController class]) bundle:[NSBundle bundleForClass:[MIMChatController class]]];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registerForKeyboardNotifications];
    
    self.inputToolBarHeight = MIM_INPUT_TOOLBAR_HEIGHT;
    [self.view updateConstraintsIfNeeded];
    [self.inputToolbar setMiddelView:self.textView];
    [self.inputToolbar setLeftItems:nil];
    [self.inputToolbar setRightItems:nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap)];
    [self.tableView addGestureRecognizer:gesture];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    [self.tableView setTableFooterView:footerView];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewTap
{
    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
    if ([self.delegate respondsToSelector:@selector(chatViewShouldFinishEditing)]) {
        [self.delegate chatViewShouldFinishEditing];
    }
}

- (void)finishReceiveNewMessageWithCount:(NSInteger)count animated:(BOOL)animated
{
    
    NSInteger number = [self.tableView numberOfRowsInSection:0];
    [self.tableView beginUpdates];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSInteger i = number ; i < number + count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [indexPaths addObject: indexPath];
        
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
    [self scrollToBottomAnimated:animated];
}

/**
 *tableview滚动到底部
 */
- (void)scrollToBottomAnimated:(BOOL)animated
{
    if (self.tableView.numberOfSections == 0) {
        return;
    }
    
    NSInteger itemsNumber = [self.tableView numberOfRowsInSection:0];
    if (itemsNumber == 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemsNumber - 1 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];

}


#pragma mark - table cell method -

/**
 *  计算cell的高度
 */
- (CGFloat)getCellHeightWithMessageContent:(MIMMessageContent *)content style:(MIMMessageCellStyle)style
{
    //完全自定义 即是contentView的高度
    if (style == MIMMessageCellStyleOthers) {
        return content.contentSize.height;
    }
    
    CGFloat height = 0.0;
    NSString *timeString = content.messageTime;
    
    
    if (timeString) {
        height += MIM_TIME_LABEL_HEIGHT;
    }
    NSString *nickname = content.nickName;
    
    CGSize contentSize = content.contentSize;
    
    CGFloat avatarHeight = MIM_AVATAR_SIZE.height;

    CGFloat contentHeight = nickname?contentSize.height + MIM_NICKNAME_LABEL_HEIGHT:contentSize.height;
    
    height += contentHeight > avatarHeight?contentHeight:avatarHeight;
    
    return height;
}

/**
 *  获取cell
 */
- (UITableViewCell *)getCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    MIMMessageCellStyle cellStyle = [self.dataSource chatViewCellStyleAtIndex:indexPath.row];
    
    NSString *contentId = [self.dataSource chatViewessageTypeReusableIdentifierAtIndex:indexPath.row];
    
    //其他类型 完全自定义的类型
    if (cellStyle == MIMMessageCellStyleOthers) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:contentId];
        if(cell == nil){
            cell = [[MIMMessageCommonCell alloc] init];
        }
        MIMMessageCommonCell *commonCell = (MIMMessageCommonCell *)cell;
        commonCell.messageContent = [self.dataSource chatViewMessageContentView:commonCell.messageContent cellStyle:cellStyle forCellAtIndex:indexPath.row];
        
        return cell;
    }
    
    NSString *messageId = (cellStyle == MIMMessageCellStyleIncoming?@"kMIMMessageInCell":@"kMIMMessageOutCell");
    NSString *reusableId = [NSString stringWithFormat:@"%@_%@", messageId, contentId];
    cell = [tableView dequeueReusableCellWithIdentifier:reusableId];
    if (cell == nil) {
        cell = [[MIMMessageTableCell alloc] initWithCellStyle:cellStyle];
    }
    
    MIMMessageTableCell *messageCell = (MIMMessageTableCell *)cell;
    __weak typeof(self) weakSelf = self;
    
    messageCell.avatarClick = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(chatViewDidSelectAvatarAtIndex:)]) {
            [weakSelf.delegate chatViewDidSelectAvatarAtIndex:indexPath.row];
        }
    };
    
    messageCell.messageContent = [self.dataSource chatViewMessageContentView:messageCell.messageContent cellStyle:cellStyle forCellAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - tableView Delegate and dataSource -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellDictionary objectForKey:@(indexPath.row)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource chatViewNumberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self getCellWithTableView:tableView indexPath:indexPath];
    
    [self.cellDictionary setObject:cell forKey:@(indexPath.row)];
    
    MIMMessageContent *content = nil;
    MIMMessageCellStyle style = MIMMessageCellStyleIncoming;
    
    if ([cell isKindOfClass:[MIMMessageCommonCell class]]) {
        content = [(MIMMessageCommonCell *)cell messageContent];
        style = MIMMessageCellStyleOthers;
    }
    else if ([cell isKindOfClass:[MIMMessageTableCell class]]){
        content = [(MIMMessageTableCell *)cell messageContent];
        style = [(MIMMessageTableCell *)cell style];
    }
    
    if (content) {
        return [self getCellHeightWithMessageContent:content style:style];
    }
    
    return 0.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(chatViewDidSelectCellAtIndex:)]) {
        [self.delegate chatViewDidSelectCellAtIndex:indexPath.row];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self tableViewTap];
    //释放键盘
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - getter -
- (UITextView *)textView
{
    if (!_textView) {
        [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //坐标用来设置上下左右留出距离  长宽会自适应
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 5, 5)];

        _textView.layer.cornerRadius = 5.0f;
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(5.0f, 0.0f, 5.0f, 0.0f);

        _textView.returnKeyType = UIReturnKeySend;
        
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.textAlignment = NSTextAlignmentNatural;
        _textView.contentMode = UIViewContentModeRedraw;

        [_textView setFont:[UIFont systemFontOfSize:17.0f]];
        
        _textView.enablesReturnKeyAutomatically = YES;
        //捕捉textView contentSize改变
        [_textView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:kMIMTextViewContentSizeContext];
        
        _textView.delegate = self;

    }
    return _textView;
}
            
- (NSMutableDictionary *)cellDictionary
{
    if (!_cellDictionary) {
        _cellDictionary = [[NSMutableDictionary alloc] init];
    }
    return _cellDictionary;
}


#pragma mark - setter -
- (void)setMaxInputToolBarHeight:(CGFloat)maxInputToolBarHeight
{
    _maxInputToolBarHeight = maxInputToolBarHeight;
}

- (void)setInputToolBarHeight:(CGFloat)inputToolBarHeight
{
    if (_inputToolBarHeight == inputToolBarHeight) {
        return;
    }
    _inputToolBarHeight = inputToolBarHeight;
    
    self.toolbarHeightConstraint.constant = _inputToolBarHeight;
    
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - toolbar layout reset -
- (void)updateToolbarBottomDistance:(CGFloat )height
{
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.toolbarButtomConstraint.constant = height;
    } completion:^(BOOL finished) {
        if (height) {
            [UIView animateWithDuration:0.25 animations:^{
                [self scrollToBottomAnimated:NO];
            }];
        }
    }];
}

- (void)updateToolbarTextViewHeight:(CGFloat)height
{
    CGPoint textViewLastLinePoint = CGPointMake(0.0f, self.textView.contentSize.height - CGRectGetHeight(self.textView.bounds));
    if (self.maxInputToolBarHeight && self.maxInputToolBarHeight < height) {
        height = self.maxInputToolBarHeight;
    }
    
    [UIView animateWithDuration:0.01f animations:^{
        self.toolbarHeightConstraint.constant = height + self.textView.frame.origin.y * 2.0;
        [self.inputToolbar updateConstraintsIfNeeded];
        
        self.textView.contentOffset = textViewLastLinePoint;
    }];
}

#pragma mark - textViewDelegate -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        //发送文字
        if ([self.delegate respondsToSelector:@selector(chatViewWillSendMessageText:)]) {
            [self.delegate chatViewWillSendMessageText:self.textView.text];
        }
        self.textView.text = @"";
        return NO;
    }

    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self updateToolbarBottomDistance:0.0f];
}

#pragma mark - observe -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kMIMTextViewContentSizeContext) {
        if (object == self.textView && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            
            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
            if (oldContentSize.height != newContentSize.height) {
                [self updateToolbarTextViewHeight:newContentSize.height];
            }
        }
    }
}


#pragma mark - keyboard -
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if ([self.textView isFirstResponder]) {
        [self updateToolbarBottomDistance:kbSize.height];
    }
}

//- (void)keyboardWillHidden:(NSNotification *)noti
//{
//    [self updateToolbarBottomDistance:0.0];
//}

#pragma mark - dealloc -
- (void)dealloc
{
    self.cellDictionary = nil;
    [self removeKeyboardNotifications];
    @try {
        [self.textView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) context:kMIMTextViewContentSizeContext];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
