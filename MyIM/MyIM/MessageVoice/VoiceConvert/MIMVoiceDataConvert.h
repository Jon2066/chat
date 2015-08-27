//
//  MIMVoiceDataConvert.h
//  MyIM
//
//  Created by Jonathan on 15/8/26.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMVoiceDataConvert : NSObject

+ (NSData *)wavDataFromAmrFile:(NSString *)amrPath;

@end
