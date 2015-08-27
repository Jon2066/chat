//
//  MIMImageModel.m
//  MyIM
//
//  Created by Jonathan on 15/8/14.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMImageModel.h"

@implementation MIMImageModel
- (instancetype)initWithThumbUrl:(NSURL *)tbUrl imageUrl:(NSURL *)imUrl placeHolderImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _thumbUrl         = tbUrl;
        _imageUrl         = imUrl;
        _placeHolderImage = image;
    }
    return self;
}

- (instancetype)initWithThumbUrl:(NSURL *)tbUrl imageUrl:(NSURL *)imUrl size:(CGSize)imageSize placeHolderImage:(UIImage *)image
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

@end
