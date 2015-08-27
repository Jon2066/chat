//
//  MIMVoiceDataConvert.m
//  MyIM
//
//  Created by Jonathan on 15/8/26.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMVoiceDataConvert.h"
#import "amrDataCodec.h"

@implementation MIMVoiceDataConvert

+ (NSData *)wavDataFromAmrFile:(NSString *)amrPath
{
    NSData *data = [NSData dataWithContentsOfFile:amrPath];
    if (!data) {
        return nil;
    }
    return DecodeAMRToWAVE(data);
}

@end
