//
//  MIMImagePicker.h
//  MyIM
//
//  Created by Jonathan on 15/8/28.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    MIMImagePickerTypePhotoAlbum = 0, //相册
    MIMImagePickerTypeCamera     = 1, //相机
}MIMImagePickerType;

@interface MIMImagePicker : NSObject

- (id)initWithRootViewController:(UIViewController *)controller;

- (void)showImagePickerWithType:(MIMImagePickerType)type completionBlock:(void(^)(UIImage *image))compltiion;


@end
