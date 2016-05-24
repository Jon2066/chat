//
//  MIMMessageTextView.m
//  MyIM
//
//  Created by Jonathan on 15/8/15.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMMessageTextView.h"
#import "MIMDefine.h"

typedef BOOL(^textViewInteractBlock)(NSURL *URL,NSRange characterRange);
@interface MIMMessageTextView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (assign, nonatomic) MIMMessageCellStyle messageCellStyle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeadingConstaint;

//@property (assign, nonatomic) CGSize textSize;
@property (strong, nonatomic) textViewInteractBlock interactBlock;

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

- (void)textViewShouldInteractWithBlock:(BOOL (^)(NSURL *, NSRange))block
{
    self.interactBlock = block;
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
    
    self.messageCellStyle = style;
    
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
    _textView.attributedText = nil;
    _textView.attributedText = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:MIM_MESSAGE_TEXT_FONT}];
    
    CGFloat width = [MIMMessageTextView getTextWidth:messageText];
    if(width >= MIM_MESSAGE_MAX_TEXT_WIDTH){
        width = MIM_MESSAGE_MAX_TEXT_WIDTH;
    }
    
    CGFloat height = [MIMMessageTextView getTextHeight:messageText withWidth:width];
    self.textViewHeightConstraint.constant = height;
    [self updateConstraintsIfNeeded];
    
    
//    self.textSize = CGSizeMake(width, height);
    
}


- (void)awakeFromNib
{
    
    self.textView.delegate = self;
    
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textContainer.lineFragmentPadding = 0;

    self.textView.contentOffset = CGPointZero;

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (self.interactBlock) {
        return self.interactBlock(URL, characterRange);
    }
    return YES;
}


+ (CGFloat)getTextHeight:(NSString *)text withWidth:(CGFloat)width
{
    UIFont *textFont = MIM_MESSAGE_TEXT_FONT;
    return  [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil].size.height + 1.0;
}

+ (CGFloat)getTextWidth:(NSString *)text
{
    UIFont *textFont = MIM_MESSAGE_TEXT_FONT;

    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil].size;
    return size.width + 0.5;
}

+ (CGSize)getTextViewSizeWithText:(NSString *)messagetext minHeight:(CGFloat)minHeight;
{
    UIEdgeInsets contentInset = MIM_MESSAGE_TEXT_EDGE;
    
    CGFloat textWidth = [self getTextWidth:messagetext];
    
    if (textWidth < MIM_MESSAGE_MAX_TEXT_WIDTH) {
        if (textWidth < 25) {
            textWidth = 25;
        }
//        return CGSizeMake(textWidth + contentInset.left + contentInset.right, minHeight);
    }
    else{
        textWidth = MIM_MESSAGE_MAX_TEXT_WIDTH;
    }
    
    CGFloat textHeight = [self getTextHeight:messagetext withWidth:textWidth];
    CGFloat viewHeight = textHeight + contentInset.top + contentInset.bottom;
    if (viewHeight < minHeight) {
        viewHeight = minHeight;
    }
    return CGSizeMake(textWidth + contentInset.left + contentInset.right , viewHeight);
}
@end
