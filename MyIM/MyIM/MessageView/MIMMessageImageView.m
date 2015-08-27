//
//  MIMMessageImageView.m
//  MyIM
//
//  Created by Jonathan on 15/8/19.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMMessageImageView.h"

#import "SDWebImageManager.h"

typedef void(^MIMMessageImageTap)(MIMMessageImageView *messsageImageView);

@interface MIMMessageImageView ()
{
    CAShapeLayer *_maskLayer;
}
@property (assign, nonatomic) MIMMessageCellStyle style;

@property (strong, nonatomic) MIMMessageImageTap imageTapBlock;
@end

@implementation MIMMessageImageView

- (instancetype)initFromNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIMMessageImageView class]) owner:nil options:nil] lastObject];
    if (self) {
        _style = -100;
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [self.imageView addGestureRecognizer:gesture];
}

- (void)imageClick
{
    if (self.imageTapBlock) {
        self.imageTapBlock(self);
    }
}

- (void)receiveImageTapWithBlock:(void (^)(MIMMessageImageView *))block
{
    self.imageTapBlock = block;
}

- (void)loadViewWithImageUrl:(NSURL *)url messageCellStyle:(MIMMessageCellStyle)style atIndex:(NSInteger)index;
{
    _index = index;
    self.style = style;
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            [weakSelf setContentImage:image style:weakSelf.style];
        }
    }];
}

- (void)loadViewWithImage:(UIImage *)image messageCellStyle:(MIMMessageCellStyle)style atIndex:(NSInteger)index;
{
    _index = index;
    self.style = style;
    [self setContentImage:image style:style];

}

- (void)setContentImage:(UIImage *)image style:(MIMMessageCellStyle)style
{
    _messageImage = image;
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    CGSize size = [self getImageViewSizeWithImageSize:image.size];
    _maskLayer.frame = CGRectMake(0, 0, size.width, size.height);
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.mask = _maskLayer;
    
    _maskLayer.contents = (id)[UIImage imageNamed:style == MIMMessageCellStyleOutgoing?@"chatto_bg_normal":@"chatfrom_bg_normal"].CGImage;
    
//    self.layer.contents = (id)_messageImage.CGImage;
    [self.imageView setImage:image];
}


- (CGSize)getImageViewSizeWithImageSize:(CGSize )imageSize
{
    //TODO::处理 图片显示大小
    return CGSizeMake(150, 150);
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
