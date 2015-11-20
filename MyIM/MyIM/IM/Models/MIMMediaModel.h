//
//  MIMMediaModel.h
//  XianDanJiaSales
//
//  Created by Jonathan on 15/9/7.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMMediaModel : NSObject
@property (strong, nonatomic) NSString *remoteUrl; //远程地址 还未发送为nil
@property (strong, nonatomic) NSString *localFileName; // 文件名称(远程url MD5加密字符串 保证唯一性，还未发送的消息 filename为本地生成的uuid)
@property (assign, nonatomic) NSInteger duration; //播放时长

@property (assign, nonatomic) BOOL      isDownload;//是否已经下载在本地

//@property (assign, nonatomic) BOOL      
/**
 *  通过远程地址创建
 *  本地存储文件名 通过MD5加密生成
 */
- (instancetype)initWithRemoteUrl:(NSString *)remoteUrl duration:(NSInteger)duration;

/**
 *  本地录音还未发送到服务器
 */
- (instancetype)initWithLocalFileName:(NSString *)localFileName duration:(NSInteger)duration;

@end
