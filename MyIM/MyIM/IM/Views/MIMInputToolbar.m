//
//  MIMInputToolbar.m
//  MyIM
//
//  Created by Jonathan on 15/8/11.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMInputToolbar.h"

@interface MIMInputToolbar ()
//views
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *rightView;


//autolayout constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftItemWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightItemWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftItemHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightItemHeightConstraint;

//自定义左右item
@property (strong, nonatomic) MIMInputItemModel *leftItem;
@property (strong, nonatomic) MIMInputItemModel *rightItem;
@property (strong, nonatomic) UIView  *middleItem;//commonView
@end

@implementation MIMInputToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    self.clipsToBounds = YES;
    self.leftItemHeightConstraint.constant  = MIM_INPUT_TOOLBAR_HEIGHT;
    self.rightItemHeightConstraint.constant = MIM_INPUT_TOOLBAR_HEIGHT;
    [self updateConstraintsIfNeeded];
}

/**
 *  加载左边按钮
 */
- (void)setLeftItems:(MIMInputItemModel *)model
{
    if (self.leftView.subviews.count) {
        for (UIView *view in self.leftView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (!model) {
        //更新约束
        self.leftItemWidthConstraint.constant  = 0;
        [self updateConstraintsIfNeeded];
        return;
    }
    self.leftItem = model;
    float leftItemWitdh = 0;
    if (self.leftItem) {
        leftItemWitdh = self.leftItem.itemWidth;
        //添加按钮
        if (self.leftItem.buttons) {
            for (UIButton *button in self.leftItem.buttons) {
                [self.leftView addSubview:button];
            }
        }
    }
    //更新约束
    self.leftItemWidthConstraint.constant  = leftItemWitdh;
    [self updateConstraintsIfNeeded];
}

/**
 *  加载右边按钮
 */
- (void)setRightItems:(MIMInputItemModel *)model
{
    if (self.rightView.subviews.count) {
        for (UIView *view in self.rightView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if (!model) {
        //更新约束
        self.rightItemWidthConstraint.constant = 0;
        [self updateConstraintsIfNeeded];
        return;
    }
    
    self.rightItem = model;
    
    float rightItemWidth = 0;
    if (self.rightItem) {
        rightItemWidth = self.rightItem.itemWidth;
        
        //添加按钮
        if(self.rightItem.buttons){
            for (UIButton *button in self.rightItem.buttons) {
                [self.rightView addSubview:button];
            }
        }
    }
    
    self.rightItemWidthConstraint.constant = rightItemWidth;
    [self updateConstraintsIfNeeded];
}


/**
 *  加载中间 输入控件
 */
- (void)setMiddelView:(UIView *)view;
{
    if (self.middleView.subviews.count) {
        for (UIView *view in self.middleView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (!view) {
        return;
    }
    self.middleItem = view;
    
    //添加中间 输入控件
    if (self.middleItem) {
        
        float width = self.middleItem.frame.origin.x;
        float height = self.middleItem.frame.origin.y;
        
        [self.middleView addSubview:self.middleItem];
        
        [self.middleItem setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        //创建约束
        NSLayoutConstraint *leadingCt = [NSLayoutConstraint constraintWithItem:self.middleItem attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.middleView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:width];
        
        NSLayoutConstraint *trailingCt = [NSLayoutConstraint constraintWithItem:self.middleItem attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.middleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-width];
        
        NSLayoutConstraint *topCt = [NSLayoutConstraint constraintWithItem:self.middleItem attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.middleView attribute:NSLayoutAttributeTop multiplier:1.0 constant:height];
        NSLayoutConstraint *bottomCt = [NSLayoutConstraint constraintWithItem:self.middleItem attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.middleView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-height];
        

        
        [self.middleView addConstraints:@[leadingCt, trailingCt, topCt, bottomCt]];
        
        [self.middleView updateConstraintsIfNeeded];
        
    }
}
@end
