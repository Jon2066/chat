//
//  MIMDefine.swift
//  MyIM
//
//  Created by Jonathan on 16/5/31.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import Foundation
import UIKit
enum MIMMessageCellStyle: Int {
    case others = 0
    case incoming
    case outgoing
}

let MIMTimeLabelHeight: CGFloat            = 36.0   //时间高度
let MIMNicknameLabelHeight: CGFloat        = 24.0   //昵称高度
let MIMAvatarAndContentSpace: CGFloat      = 10.0   //内容与头像的距离
let MIMNicknameAndContentSpace: CGFloat    = 0.0    //昵称与内容的距离
let MIMAvatarSize                          = (width: 20, height: 30) //头像大小
let MIMBottomSpace: CGFloat                = 15.0   //内容与Cell底部的间距

//toolbar 定义
let MIMInputToolbarHeight: CGFloat         = 50.0   //输入toolb默认高度 也是两边按钮的高度

//消息定义
//文本消息
let MIMMessageMaxTextWidth: CGFloat        =  UIScreen.mainScreen().bounds.size.width * 0.618  //文本消息最大宽度为屏幕比例的多少
let MIMMessageTextEdge                     =  (top: 8.0, left: 15.0, bottom: 8.0, right: 18.0) //文本四周边距（按右边给出 左边消息左右调换）
let MIMMessageTextFont                     =  UIFont.systemFontOfSize(17.0)//文本消息文字大小

//图片消息
let MIMMessgeMaxImageWidth: CGFloat        = UIScreen.mainScreen().bounds.size.width * 0.4   //图片最宽为屏幕0.4
let MIMMessaeMaxImageHeight: CGFloat       = UIScreen.mainScreen().bounds.size.width * 0.4  //图片最宽为屏幕0.618
let MIMMessageMinImageWidth: CGFloat       = UIScreen.mainScreen().bounds.size.width * 0.1   //图片最小宽度
let MIMMessgeMinImageHeight: CGFloat       = UIScreen.mainScreen().bounds.size.width * 0.1  //图片最小高度

//语音消息
let MIMMessageMaxVoiceWidth: CGFloat       = UIScreen.mainScreen().bounds.size.width * 0.55
let MIMMessageMinVoiceWidth: CGFloat       = 75.0
let MIMMessageMaxRecorderTime: Int         = 60   //最长录音时间 60秒
        