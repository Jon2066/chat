//
//  MIMImageModel.h
//  MyIM
//
//  Created by Jonathan on 15/8/14.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface MIMImageModel : NSObject

@property (strong, nonatomic) NSURL   *thumbUrl; //缩略图 （优先使用）
@property (strong, nonatomic) NSURL   *imageUrl; //图片地址
@property (strong, nonatomic) UIImage *placeHolderImage;//占位图

@property (assign, nonatomic) CGSize   imageSize; //图片消息 用于布局

- (instancetype)initWithThumbUrl:(NSURL *)tbUrl imageUrl:(NSURL *)imUrl placeHolderImage:(UIImage *)image;

- (instancetype)initWithThumbUrl:(NSURL *)tbUrl imageUrl:(NSURL *)imUrl size:(CGSize)imageSize placeHolderImage:(UIImage *)image;

@end
