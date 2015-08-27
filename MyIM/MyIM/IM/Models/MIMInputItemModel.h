//
//  MIMInputItemModel.h
//  MyIM
//
//  Created by Jonathan on 15/8/11.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMInputItemModel : NSObject

@property (assign, nonatomic) float     itemWidth;//item总长度
@property (strong, nonatomic) NSArray  *buttons; //item中包含一个或多个按钮

/**
 *  创建model
 *
 *  @param buttons   item中要显示的按钮 没有为nil
 *  @param itemWidth item要占用的宽度
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithButtons:(NSArray *)buttons itemWidth:(float)itemWidth;
@end
