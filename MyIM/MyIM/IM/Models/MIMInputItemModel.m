//
//  MIMInputItemModel.m
//  MyIM
//
//  Created by Jonathan on 15/8/11.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMInputItemModel.h"

@implementation MIMInputItemModel

- (instancetype)initWithButtons:(NSArray *)buttons itemWidth:(float)itemWidth
{
    self = [super init];
    if (self) {
        _buttons   = buttons;
        _itemWidth = itemWidth;
    }
    return self;
}
@end
