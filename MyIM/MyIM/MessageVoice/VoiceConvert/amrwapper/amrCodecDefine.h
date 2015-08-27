//
//  amrCodecDefine.h
//  MyIM
//
//  Created by Jonathan on 15/8/26.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#ifndef MyIM_amrCodecDefine_h
#define MyIM_amrCodecDefine_h

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "interf_dec.h"
#include "interf_enc.h"

#define AMR_MAGIC_NUMBER "#!AMR\n"

#define PCM_FRAME_SIZE 160 // 8khz 8000*0.02=160
#define MAX_AMR_FRAME_SIZE 32
#define AMR_FRAME_COUNT_PER_SECOND 50

typedef struct
{
    char chChunkID[4];
    int nChunkSize;
}XCHUNKHEADER;

typedef struct
{
    short nFormatTag;
    short nChannels;
    int nSamplesPerSec;
    int nAvgBytesPerSec;
    short nBlockAlign;
    short nBitsPerSample;
}WAVEFORMAT;

typedef struct
{
    short nFormatTag;
    short nChannels;
    int nSamplesPerSec;
    int nAvgBytesPerSec;
    short nBlockAlign;
    short nBitsPerSample;
    short nExSize;
}WAVEFORMATX;

typedef struct
{
    char chRiffID[4];
    int nRiffSize;
    char chRiffFormat[4];
}RIFFHEADER;

typedef struct
{
    char chFmtID[4];
    int nFmtSize;
    WAVEFORMAT wf;
}FMTBLOCK;



#endif
