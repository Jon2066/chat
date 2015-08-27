//
//  MIMShareMoreItemView.h
//  MyIM
//
//  Created by Jonathan on 15/8/27.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MIMItemTypePicture   = 0,
    MIMItemTypeTakePhoto = 1,
}MIMItemType;

@class MIMShareMoreItemView;
typedef void(^MIMShareMoreItemClick)(MIMShareMoreItemView *itemView);


@interface MIMShareMoreItemView : UIView

@property (strong, nonatomic) UIImage    *image;
@property (strong, nonatomic) NSString   *title;
@property (assign, nonatomic) MIMItemType itemType;

- (instancetype)initFromNibWithItemType:(MIMItemType)type image:(UIImage *)image title:(NSString *)title;

- (void)receiveItemClick:(MIMShareMoreItemClick)itemClickBlock;
@end
