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

@property (strong, nonatomic) NSString   *thumbUrl; //缩略图 （优先使用）
@property (strong, nonatomic) NSString   *imageUrl; //图片地址
@property (strong, nonatomic) UIImage *placeHolderImage;//占位图

@property (assign, nonatomic) CGSize   imageSize; //图片消息 用于布局

- (instancetype)initWithThumbUrl:(NSString *)tbUrl imageUrl:(NSString *)imUrl placeHolderImage:(UIImage *)image;

- (instancetype)initWithThumbUrl:(NSString *)tbUrl imageUrl:(NSString *)imUrl size:(CGSize)imageSize placeHolderImage:(UIImage *)image;


+ (CGSize)getUploadSizeWithOriginSize:(CGSize)imageSize;

+ (CGSize)getMessageThumbImageSize:(CGSize)imageSize;
@end
