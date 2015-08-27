//
//  MIMVoiceFileConvert.m
//  MyIM
//
//  Created by Jonathan on 15/8/26.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "MIMVoiceFileConvert.h"
#import "amrFileCodec.h"

@implementation MIMVoiceFileConvert

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath{
    
    if (! DecodeAMRFileToWAVEFile([_amrPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return 0;
    
    return 1;
}

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath{
    
    if (EncodeWAVEFileToAMRFile([_wavPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return 0;
    
    return 1;
}

@end
