//
//  armDataCodec.h
//  MyIM
//
//  Created by Jonathan on 15/8/26.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#ifndef amrDataCodec_h
#define amrDataCodec_h

#import "amrCodecDefine.h"




NSData* DecodeAMRToWAVE(NSData* data);
NSData* EncodeWAVEToAMR(NSData* data, int nChannels, int nBitsPerSample);

#endif
