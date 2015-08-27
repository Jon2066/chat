//
//  MIMItemActionSheetView.h
//  MyIM
//
//  Created by Jonathan on 15/8/27.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIMShareMoreItemView.h"


@interface MIMShareMoreView : UIView

- (instancetype)initWithFrame:(CGRect)frame itemClick:(MIMShareMoreItemClick)itemClickBlock;

@end
