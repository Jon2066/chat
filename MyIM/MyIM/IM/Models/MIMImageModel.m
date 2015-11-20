//
//  MIMImageModel.m
//  MyIM
//
//  Created by Jonathan on 15/8/14.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMImageModel.h"
#import "MIMDefine.h"

@implementation MIMImageModel
- (instancetype)initWithThumbUrl:(NSString *)tbUrl imageUrl:(NSString *)imUrl placeHolderImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _thumbUrl         = tbUrl;
        _imageUrl         = imUrl;
        _placeHolderImage = image;
    }
    return self;
}

- (instancetype)initWithThumbUrl:(NSString *)tbUrl imageUrl:(NSString *)imUrl size:(CGSize)imageSize placeHolderImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _thumbUrl         = tbUrl;
        _imageUrl         = imUrl;
        _placeHolderImage = image;
        _imageSize        = imageSize;
    }
    return self;
}

+ (CGSize)getUploadSizeWithOriginSize:(CGSize)imageSize
{
    //  处理 图片显示大小
    CGFloat ratio           = imageSize.height / imageSize.width; //高宽比
    CGFloat maxWidth        = 1080;
    CGFloat maxHeight       = 1920;
    if (ratio <= 1) {//宽大于高
        if(imageSize.width < maxWidth){ //图片宽小于最大宽
            return CGSizeMake(imageSize.width, imageSize.height);
        }
        return CGSizeMake(maxWidth, maxWidth * ratio);
    }
    else{ //高大于宽
        if(imageSize.height < maxHeight){ //图片高小于最大高
            return CGSizeMake(imageSize.width, imageSize.height);
        }
        return CGSizeMake(maxHeight / ratio, maxHeight);
    }
    return CGSizeMake(540, 540);
}


+ (CGSize)getMessageThumbImageSize:(CGSize)imageSize
{
    //  处理 图片显示大小
    CGFloat ratio           = imageSize.height / imageSize.width; //高宽比
    CGFloat maxWidth        = 540;
    CGFloat maxHeight       = 540;
    if (ratio <= 1) {//宽大于高
        if(imageSize.width < maxWidth){ //图片宽小于最大宽
            return CGSizeMake(imageSize.width, imageSize.height);
        }
        return CGSizeMake(maxWidth, maxWidth * ratio);
    }
    else{ //高大于宽
        if(imageSize.height < maxHeight){ //图片高小于最大高
            return CGSizeMake(imageSize.width, imageSize.height);
        }
        return CGSizeMake(maxHeight / ratio, maxHeight);
    }
    return CGSizeMake(540, 540);
}

@end
