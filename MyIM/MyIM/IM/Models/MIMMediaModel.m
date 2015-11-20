//
//  MIMMediaModel.m
//  XianDanJiaSales
//
//  Created by Jonathan on 15/9/7.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import "MIMMediaModel.h"
#import "MIMVoiceRecorder.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MIMMediaModel

- (instancetype)initWithRemoteUrl:(NSString *)remoteUrl duration:(NSInteger)duration
{
    self = [super init];
    if (self) {
        _remoteUrl     = remoteUrl;
        _localFileName = [self md5HexDigest:remoteUrl];
        _isDownload    = [MIMVoiceRecorder fileExistWithFileName:_localFileName];
        _duration      = duration;
    }
    return self;
}

- (instancetype)initWithLocalFileName:(NSString *)localFileName duration:(NSInteger)duration
{
    self = [super init];
    if (self) {
        _remoteUrl      = nil;
        _localFileName  = localFileName;
        _isDownload     = YES;
        _duration       = duration;
    }
    return self;
}

/**
 *  MD5加密
 */
- (NSString *)md5HexDigest:(NSString *)input
{
    
    if(self == nil || [input length] == 0)
        return nil;
    
    const char *value = [input UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    return outputString;
}

@end
