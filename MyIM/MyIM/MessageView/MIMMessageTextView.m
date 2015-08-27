//
//  MIMMessageTextView.m
//  MyIM
//
//  Created by Jonathan on 15/8/15.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMMessageTextView.h"
#import "MIMDefine.h"

@interface MIMMessageTextView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (assign, nonatomic) MIMMessageCellStyle messageCellStyle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeadingConstaint;

@property (assign, nonatomic) CGSize textSize;

@end

@implementation MIMMessageTextView

- (instancetype)initFromNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIMMessageTextView class]) owner:nil options:nil] lastObject];
    if (self) {
        self.messageCellStyle = -100;
    }
    return self;
}

- (void)loadViewWithMessageText:(NSString *)messageText messageCellStyle:(MIMMessageCellStyle)style
{
    [self setBackgroundImageWithStyle:style];
    [self setMessageText:messageText];
}

- (void)setBackgroundImageWithStyle:(MIMMessageCellStyle)style
{
    if (self.messageCellStyle == style) {
        return;
    }
    if (style == MIMMessageCellStyleOutgoing) {
        UIImage *bgImage = [[UIImage imageNamed:@"chatto_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
        [self.backgroudImageView setImage:bgImage];
        
    }
    else {
         UIImage *bgImage = [[UIImage imageNamed:@"chatfrom_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
        [self.backgroudImageView setImage:bgImage];
    }
    
    if (self.messageCellStyle == MIMMessageCellStyleIncoming) {
        self.textViewLeadingConstaint.constant = MIM_MESSAGE_TEXT_EDGE.right;
        self.textViewTrailingConstraint.constant = MIM_MESSAGE_TEXT_EDGE.left;
    }
    else{
        self.textViewLeadingConstaint.constant = MIM_MESSAGE_TEXT_EDGE.left;
        self.textViewTrailingConstraint.constant = MIM_MESSAGE_TEXT_EDGE.right;
    }
    [self updateConstraintsIfNeeded];

}

- (void)setMessageText:(NSString *)messageText
{
    _textView.text = messageText;
    
    CGFloat width = [self getTextWidth:messageText];
    if(width >= MIM_MESSAGE_MAX_TEXT_WIDTH){
        width = MIM_MESSAGE_MAX_TEXT_WIDTH;
    }
    
    CGFloat height = [self getTextHeight:messageText withWidth:width];
    self.textViewHeightConstraint.constant = height;
    [self updateConstraintsIfNeeded];
    
    
    self.textSize = CGSizeMake(width, height);
    
}


- (void)awakeFromNib
{
    self.textView.font = MIM_MESSAGE_TEXT_FONT;
    
    self.textView.delegate = self;
    
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textContainer.lineFragmentPadding = 0;

    self.textView.contentOffset = CGPointZero;

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}


- (CGFloat)getTextHeight:(NSString *)text withWidth:(CGFloat)width
{
    UIFont *textFont = MIM_MESSAGE_TEXT_FONT;
    return  [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil].size.height + 1.0;
}

- (CGFloat)getTextWidth:(NSString *)text
{
    UIFont *textFont = MIM_MESSAGE_TEXT_FONT;

    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil].size;
    return size.width + 0.5;
}

- (CGSize)getTextViewSizeWithMinHeight:(CGFloat)minHeight
{
    UIEdgeInsets contentInset = MIM_MESSAGE_TEXT_EDGE;
    
    CGFloat textWidth = self.textSize.width;
    
    if (textWidth + contentInset.left + contentInset.right < MIM_MESSAGE_MAX_TEXT_WIDTH) {
        if (textWidth < 25) {
            textWidth = 25;
        }
        return CGSizeMake(textWidth + contentInset.left + contentInset.right, minHeight);
    }
    
    CGFloat textHeight = self.textSize.height;
    
    return CGSizeMake(MIM_MESSAGE_MAX_TEXT_WIDTH + contentInset.left + contentInset.right , textHeight + contentInset.top + contentInset.bottom );
}
@end
