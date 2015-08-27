//
//  MIMInputToolbar.h
//  MyIM
//
//  Created by Jonathan on 15/8/11.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "MIMDefine.h"

#import "MIMInputItemModel.h"


/**
 *  输入toolbar  
 *  中间输入框随着toolbar高度变化  
 *  两边按钮的载体view 固定为bar高度
 */

@interface MIMInputToolbar : UIView

/**
 *  加载左边item
 */
- (void)setLeftItems:(MIMInputItemModel *)model;

/**
 *  加载右边item
 */
- (void)setRightItems:(MIMInputItemModel *)model;


/**
 *  加载中间输入控件
 */
- (void)setMiddelView:(UIView *)view;

@end
