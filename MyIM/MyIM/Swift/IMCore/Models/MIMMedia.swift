//
//  MIMMedia.swift
//  MyIM
//
//  Created by Jonathan on 16/5/31.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import Foundation
class MIMMedia {
    var remoteUrl: String? //远程地址 还未发送为nil
    var localFileName: String? // 文件名称(远程url MD5加密字符串 保证唯一性，还未发送的消息 filename为本地生成的uuid)
    var duration: UInt = 0//播放时长
    var isDownload = false //是否已经下载到本地
    
    init(remoteUrl: String, duration: UInt){
        self.remoteUrl = remoteUrl
        self.duration = duration
    }
    
    init(localFileName: String, duration: UInt){
        
    }

}

