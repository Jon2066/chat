//
//  MIMMessageImageView.h
//  MyIM
//
//  Created by Jonathan on 15/8/19.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIMDefine.h"

#import "MIMImageModel.h"

@interface MIMMessageImageView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@property (strong, nonatomic, readonly) UIImage *messageImage;

@property (assign, nonatomic, readonly) NSInteger index;
- (instancetype)initFromNib;

/**
 *  通过image加载view //用于自己发送的image先添加在view中
 */
- (void)loadViewWithImage:(UIImage *)image messageCellStyle:(MIMMessageCellStyle)style atIndex:(NSInteger)index;

/**
 *  通过url加载view
 */
- (void)loadViewWithImageUrl:(NSString *)url messageCellStyle:(MIMMessageCellStyle)style atIndex:(NSInteger)index;;

/**
 *  接收image点击操作
 */
- (void)receiveImageTapWithBlock:(void(^)(MIMMessageImageView *messageImageView))block;


/**
 *  通过图片大小计算显示大小
 */
+ (CGSize)getImageViewSizeWithImageSize:(CGSize )imageSize;


@end
