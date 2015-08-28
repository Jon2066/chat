//
//  MIMImagePicker.m
//  MyIM
//
//  Created by Jonathan on 15/8/28.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMImagePicker.h"

typedef void(^MIMImagePickerCompletion)(UIImage *image);

@interface MIMImagePicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) UIViewController *rootViewController;

@property (strong, nonatomic) MIMImagePickerCompletion pickerCompletion;

@property (assign, nonatomic) MIMImagePickerType type;

@end

@implementation MIMImagePicker

- (id)initWithRootViewController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        _rootViewController = controller;
    }
    return self;
}


- (void)showImagePickerWithType:(MIMImagePickerType)type completionBlock:(void(^)(UIImage *image))compltiion
{
    self.type = type;
    self.pickerCompletion = compltiion;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if (type == MIMImagePickerTypePhotoAlbum) {
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else if(type == MIMImagePickerTypeCamera){
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1 得到原始图片
    UIImage *originImage = info[@"UIImagePickerControllerOriginalImage"];
    //2 拍照之后，保存图片到相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(originImage, nil, nil, NULL);
    }
    if (self.pickerCompletion) {
        self.pickerCompletion(originImage);
    }
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.pickerCompletion) {
        self.pickerCompletion(nil);
    }
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
