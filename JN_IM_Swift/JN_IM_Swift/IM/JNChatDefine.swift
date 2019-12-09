//
//  JNChatDefine.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/3.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import Foundation
import UIKit



//MARK: - message type -
public typealias JNChatMessageType = String
public var JNChatMessageTypeUnknow: JNChatMessageType = "JNCHAT_MSG:UNKNOW"
public var JNChatMessageTypeText:   JNChatMessageType = "JNCHAT_MSG:TEXT"
public var JNChatMessageTypeImage:  JNChatMessageType = "JNCHAT_MSG:IMAGE"
public var JNChatMessageTypeAudio:  JNChatMessageType = "JNCHAT_MSG:AUDIO"


//MARK: - settings -
public var JN_CHAT_SETTING: JNChatSetting = JNChatSetting()


public let JN_BOTTOM_SAFE_SPACE = { () -> CGFloat in
    if #available(iOS 11.0, *) {
        return UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 0.0
    }
    return 0.0
}()

public enum JNChatMessageOwns {
    case owner  //自己发送的
    case others //别人发送的
    case system //系统发送
}
public enum JNChatMessageStyle {
    case userStyle   //带头像昵称等
    case customStyle //通用的 自定义的
}

public class JNChatSetting: NSObject {
    public var topSpace: CGFloat = 8
    public var timeLabelHeight: CGFloat = 16
    public var timeLabelFont: UIFont = UIFont.systemFont(ofSize: 13)
    public var timeLabelTextColor: UIColor = UIColor.lightGray
    public var tiemLabelBottomSpace: CGFloat = 8
    public var avatarLeftSpace: CGFloat = 8 //距离cell左边间距 自己则是右边间距
    public var avatarSize: CGSize = CGSize(width: 45, height: 45)
    public var avatarCornerRadius: CGFloat = 5
    public var nickNameFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var nickNameTextColor: UIColor = .black
    public var nickNameHeight: CGFloat = 15
    public var nickNameTopSpaceBaseAvatar: CGFloat = -3 //距离头像顶部的距离
    public var nickNameLeftSpaceBaseAvatar: CGFloat = 8 //距离头像间距 自己则是右边间距
    public var contentTopSpaceBaseAvatar: CGFloat { //内容距离头像的间距
        return self.nickNameHeight + self.nickNameTopSpaceBaseAvatar + 3
    }
    public var bottomSpace: CGFloat = 12
    
    //支持的消息类型
    public var supportMessageType:[JNChatMessageType] = [JNChatMessageTypeUnknow,
                                                         JNChatMessageTypeText,
                                                         JNChatMessageTypeImage,
                                                         JNChatMessageTypeAudio]

    //revoke message
    public var revokeMessageContentSize = CGSize(width: UIScreen.main.bounds.width, height: 30)

    //unknow message
    public var unknowMessageContentSize = CGSize(width: UIScreen.main.bounds.width, height: 30)

    //text message
    public var textMessageFont: UIFont = UIFont.systemFont(ofSize: 15)
    public var textMessageTextColor: UIColor = .black
    public var textMessageMaxWidth: CGFloat = 0.618 * UIScreen.main.bounds.size.height
    public var textMessageMinWidth: CGFloat = 30
    public var textMessageMinHeight: CGFloat = 45
    public var textMessageTextEdge: UIEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 15) //按左边给出 右边左右对换
    
    
    //image message
    public var imageMessageMaxWidth: CGFloat = UIScreen.main.bounds.size.width  * 0.4
    public var imageMessageMaxHeight: CGFloat = UIScreen.main.bounds.size.width  * 0.618
    public var imageMessageMinWidth: CGFloat = UIScreen.main.bounds.size.width * 0.1
    public var imageMessageMinHeight: CGFloat = UIScreen.main.bounds.size.width * 0.1
    public var imageMessageCornerRadius : CGFloat {
        return self.avatarCornerRadius
    }
    
}


