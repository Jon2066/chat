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

/**
 *  toolbar layout 高度和距离底部高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarButtomConstraint;

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
    self.inputToolBarHeight = MIM_INPUT_TOOLBAR_HEIGHT;

    [self registerForKeyboardNotifications];
    
    self.textView.delegate = self;
    //捕捉textView contentSize改变
    [self.textView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:kMIMTextViewContentSizeContext];
    
    [self.inputToolbar setMiddleItemView:self.textView];
    [self.inputToolbar setLeftItems:nil];
    [self.inputToolbar setRightItems:nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap)];
    [self.tableView addGestureRecognizer:gesture];
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
//    [self.tableView setTableFooterView:footerView];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeKeyboardNotifications];
    @try {
        [self.textView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) context:kMIMTextViewContentSizeContext];
    }
    @catch (NSException *exception){
//        NSLog(@"%@", exception);
    }
    @finally {
        
    }

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

- (void)reloadMessageCellAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)deleteMessageFromIndex:(NSInteger)index
{
    [self.tableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:visibleIndexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertMessagesFromIndex:(NSInteger)index count:(NSInteger)count
{
    [self.tableView beginUpdates];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSInteger i = index ; i < index + count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [indexPaths addObject: indexPath];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
}

- (void)finishReceiveNewMessageWithCount:(NSInteger)count animated:(BOOL)animated
{
    
    NSInteger number = [self.tableView numberOfRowsInSection:0];
    
    [self insertMessagesFromIndex:number count:count];
//    [self.tableView reloadData];
    [self scrollToBottomAnimated:animated];
}

- (void)finishReceiveWithoutScrollWithNewMessageCount:(NSInteger)count
{
    NSInteger number = [self.tableView numberOfRowsInSection:0];
    [self insertMessagesFromIndex:number count:count];
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
    [self scrollToIndex:itemsNumber - 1 animated:animated];

}

/**
 *  滚动到指定位置
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


- (void)scrollToIndex:(NSInteger)index asScrollPosition:(UITableViewScrollPosition)position animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
}


#pragma mark - table cell method -

/**
 *  计算cell的高度
 */
- (CGFloat)getCellHeightWithTableView:(UITableView *)tableView atIndex:(NSInteger)index
{
    MIMMessageCellStyle style = [self.dataSource chatViewCellStyleAtIndex:index];
    if (style == MIMMessageCellStyleOthers) {//完全自定义 即contentView.height
        CGSize contentSize = [self.dataSource chatViewMessageContentViewSizeForCellAtIndex:index];
        return contentSize.height;
    }
    
    CGFloat height = 0.0;
    NSString *timeString = [self.dataSource chatViewMessageTimeForCellAtIndex:index];
    
    if (timeString) {
        height += MIM_TIME_LABEL_HEIGHT;
    }
    NSString *nickname = [self.dataSource chatViewNicknameForCellAtIndex:index];
    
    CGSize contentSize = [self.dataSource chatViewMessageContentViewSizeForCellAtIndex:index];
    
    CGFloat avatarHeight = MIM_AVATAR_SIZE.height;

    CGFloat contentHeight = nickname?contentSize.height + MIM_NICKNAME_LABEL_HEIGHT:contentSize.height;
    
    height += (contentHeight > avatarHeight?contentHeight:avatarHeight);
    
    height += MIM_BOTTOM_SPACE;
    
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
        commonCell.messageContentView = [self.dataSource chatViewMessageContentView:commonCell.messageContentView cellStyle:cellStyle forCellAtIndex:indexPath.row];
        return cell;
    }
    
    NSString *messageId = (cellStyle == MIMMessageCellStyleIncoming?@"kMIMMessageInCell":@"kMIMMessageOutCell");
    NSString *reusableId = [NSString stringWithFormat:@"%@_%@", messageId, contentId];
    cell = [tableView dequeueReusableCellWithIdentifier:reusableId];
    if (cell == nil) {
        cell = [[MIMMessageTableCell alloc] initWithCellStyle:cellStyle reuseIdentifier:reusableId];
        __weak typeof(self) weakSelf = self;
        ((MIMMessageTableCell *)cell).avatarClick = ^(NSInteger index){
            if ([weakSelf.delegate respondsToSelector:@selector(chatViewDidSelectAvatarAtIndex:)]) {
                [weakSelf.delegate chatViewDidSelectAvatarAtIndex:index];
            }
        };
        ((MIMMessageTableCell *)cell).errorClick = ^(NSInteger index){
            if ([weakSelf.delegate respondsToSelector:@selector(chatViewShouldCheckErrorAtIndex:)]) {
                [weakSelf.delegate chatViewShouldCheckErrorAtIndex:index];
            }
        };
    }
    
    MIMMessageTableCell *messageCell = (MIMMessageTableCell *)cell;

    messageCell.atIndex     = indexPath.row;
    
    messageCell.messageTime = [self.dataSource chatViewMessageTimeForCellAtIndex:indexPath.row];

    messageCell.messageContentView = [self.dataSource chatViewMessageContentView:messageCell.messageContentView cellStyle:cellStyle forCellAtIndex:indexPath.row];
    messageCell.messageContentSize = [self.dataSource chatViewMessageContentViewSizeForCellAtIndex:indexPath.row];
    messageCell.nickName    = [self.dataSource chatViewNicknameForCellAtIndex:indexPath.row];
    messageCell.avatar      = [self.dataSource chatViewAvatarWithCellStyle:cellStyle forCellAtIndex:indexPath.row];
    messageCell.showError   = [self.dataSource chatViewShowErrorForCellAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - tableView Delegate and dataSource -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellWithTableView:tableView indexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource chatViewNumberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeightWithTableView:tableView atIndex:indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(chatViewDidSelectCellAtIndex:)]) {
        [self.delegate chatViewDidSelectCellAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MIMMessageTableCell class]]) {
        if ([self.delegate respondsToSelector:@selector(chatViewWillDisplayCellWithContentView:atIndex:)]) {
            [self.delegate chatViewWillDisplayCellWithContentView:((MIMMessageTableCell *)cell).messageContentView atIndex:indexPath.row];
        }
    }
    else if ([cell isKindOfClass:[MIMMessageCommonCell class]]){
        if ([self.delegate respondsToSelector:@selector(chatViewWillDisplayCellWithContentView:atIndex:)]) {
            [self.delegate chatViewWillDisplayCellWithContentView:((MIMMessageCommonCell *)cell).messageContentView atIndex:indexPath.row];
        }
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
    }
    return _textView;
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
- (void)updateToolbarBottomDistance:(CGFloat )height animated:(BOOL)animated
{
    if(!animated){
        self.toolbarButtomConstraint.constant = height;
        [self.view layoutSubviews];
        [self scrollToBottomAnimated:NO];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:height?0.35f:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.toolbarButtomConstraint.constant = height;
        [weakSelf.view layoutSubviews];
        [weakSelf scrollToBottomAnimated:NO];

    } completion:nil];
}

- (void)updateToolbarTextViewHeight:(CGFloat)height
{
    CGPoint textViewLastLinePoint = CGPointMake(0.0f, self.textView.contentSize.height - CGRectGetHeight(self.textView.bounds));
    if (self.maxInputToolBarHeight && self.maxInputToolBarHeight < height) {
        height = self.maxInputToolBarHeight;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.01f animations:^{
        if (height + weakSelf.textView.frame.origin.y * 2.0 < weakSelf.inputToolBarHeight) {
            weakSelf.toolbarHeightConstraint.constant = weakSelf.inputToolBarHeight;
        }
        else{
            weakSelf.toolbarHeightConstraint.constant = height + weakSelf.textView.frame.origin.y * 2.0;
        }
        [weakSelf.inputToolbar updateConstraintsIfNeeded];
        
        weakSelf.textView.contentOffset = textViewLastLinePoint;
    } completion:^(BOOL finished) {
        [weakSelf scrollToBottomAnimated:YES];
    }];
}

#pragma mark - textViewDelegate -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        NSString * textString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([textString isEqualToString:@""]) {//只是空格不允许发送
            return NO;
        }
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
    [self updateToolbarBottomDistance:0.0f animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatViewBeginTextEditing)]) {
        [self.delegate chatViewBeginTextEditing];
    }
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
        [self updateToolbarBottomDistance:kbSize.height animated:YES];
    }
}

//- (void)keyboardWillHidden:(NSNotification *)noti
//{
//    [self updateToolbarBottomDistance:0.0];
//}

#pragma mark - dealloc -
- (void)dealloc
{
    
}

@end
