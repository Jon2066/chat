//
//  MIMShareMoreItemView.m
//  MyIM
//
//  Created by Jonathan on 15/8/27.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMShareMoreItemView.h"


@interface MIMShareMoreItemView ()
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) MIMShareMoreItemClick itemClickBlock;
@end

@implementation MIMShareMoreItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initFromNibWithItemType:(MIMItemType)type image:(UIImage *)image title:(NSString *)title
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIMShareMoreItemView class]) owner:nil options:nil] lastObject];
    if (self) {
        self.image    = image;
        self.itemType = type;
        self.title    = title;
    }
    return self;
}

- (void)receiveItemClick:(void (^)(MIMShareMoreItemView *))itemClickBlock
{
    self.itemClickBlock = itemClickBlock;
}

- (void)awakeFromNib
{
    self.imageButton.layer.cornerRadius  = 5.0f;
    self.imageButton.layer.borderColor   = [UIColor blackColor].CGColor;
    self.imageButton.layer.borderWidth   = 0.5f;
    self.imageButton.layer.masksToBounds = YES;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.imageButton setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.titleLabel setText:title];
}

- (IBAction)imageButtonClick:(id)sender {
    if (self.itemClickBlock) {
        self.itemClickBlock(self);
    }
}

@end
