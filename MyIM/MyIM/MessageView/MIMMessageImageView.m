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
 //  处理 图片显示大小
    CGFloat ratio           = imageSize.height / imageSize.width; //高宽比
    CGFloat maxWidth        = MIM_MESSAGE_MAX_IMAGE_WIDTH;
    CGFloat minWidth        = MIM_MESSAGE_MIN_IMAGE_WIDTH;
    CGFloat maxHeight       = MIM_MESSAGE_MAX_IMAGE_HEIGHT;
    CGFloat minHeight       = MIM_MESSAGE_MIN_IMAGE_HEIGHT;
    CGFloat minHeightRatio  = minHeight / maxWidth; //最小高度 高宽比
    CGFloat minWidthRatio   = maxHeight / minWidth; //最小宽度 高宽比
    if (ratio <= 1) {//宽大于高
        if (ratio <= minHeightRatio) { //比例小于minHeightRatio 则使用minHeightRatio
            if(imageSize.width < maxWidth){ //图片宽小于最大宽
                return CGSizeMake(imageSize.width, imageSize.width *minHeightRatio);
            }
            return CGSizeMake(maxWidth, minHeight);
        }
        else{
            if(imageSize.width < maxWidth){ //图片宽小于最大宽
                return CGSizeMake(imageSize.width, imageSize.height);
            }
            return CGSizeMake(maxWidth, maxWidth * ratio);
        }
    }
    else{ //高大于宽
        if (ratio >= minWidthRatio) { //比例大于 minWidthRatio
            if(imageSize.height < maxHeight){ //图片高小于最大高
                return CGSizeMake(imageSize.height / minWidthRatio, imageSize.height);
            }
            return CGSizeMake(minWidth, minHeight);
        }
        else{
            if(imageSize.height < maxHeight){ //图片高小于最大高
                return CGSizeMake(imageSize.width, imageSize.height);
            }
            return CGSizeMake(maxHeight / ratio, maxHeight);
        }
    }
    
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
