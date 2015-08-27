//
//  MIMItemActionSheetView.m
//  MyIM
//
//  Created by Jonathan on 15/8/27.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMShareMoreView.h"

@interface MIMShareMoreView ()

@property (strong, nonatomic) NSArray *imageNames;
@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) MIMShareMoreItemClick itemClickBlock;
@end

@implementation MIMShareMoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame itemClick:(MIMShareMoreItemClick)itemClickBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemClickBlock = itemClickBlock;
        [self setup];
    }
    return self;
}


/**
 *  先只支持一页
 */
- (void)setup
{
    self.imageNames = @[@"sharemore_pic",@"sharemore_video"];
    self.titles = @[@"照片",@"拍摄"];
    
    CGFloat   itemWidth    = 59.0f;
    CGFloat   itemHeight   = 80.0f;
    NSInteger itemsInLine  = 4;
    CGFloat   itemVSpace   = (self.frame.size.width - itemWidth * itemsInLine) / (itemsInLine + 1.0);
    CGFloat   itemHSpace   = 6.0f;
    for (NSInteger i = 0; i < self.imageNames.count; i++) {
        UIImage *image  = [UIImage imageNamed:self.imageNames[i]];
        NSString *title = self.titles[i];
        MIMShareMoreItemView *itemView = [[MIMShareMoreItemView alloc] initFromNibWithItemType:(MIMItemType)i image:image title:title];
        [itemView receiveItemClick:self.itemClickBlock];
        CGFloat x = (i % itemsInLine + 1.0) * itemVSpace + itemWidth * (i % itemsInLine);
        CGFloat y = (i / itemsInLine + 1.0) * itemHSpace + itemHeight* (i / itemsInLine);
        itemView.frame = CGRectMake(x, y, itemWidth, itemHeight);
        
        [self addSubview:itemView];
    }
}

@end
