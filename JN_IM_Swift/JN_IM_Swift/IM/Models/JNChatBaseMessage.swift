//
//  JNChatBaseMessage.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/4.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
//MARK: - message type -
public typealias JNChatMessageType = String

public var JNChatMessageTypeUnknow: JNChatMessageType = "JNCHAT_MSG:UNKNOW"
public var JNChatMessageTypeText:   JNChatMessageType = "JNCHAT_MSG:TEXT"
public var JNChatMessageTypeImage:  JNChatMessageType = "JNCHAT_MSG:IMAGE"
public var JNChatMessageTypeAudio:  JNChatMessageType = "JNCHAT_MSG:AUDIO"

//MARK: -  display model -
public class JNChatMessageDisplay: NSObject{
    public var messageContentSize:CGSize = .zero
    public var showNickname:Bool = false
    public var showTime:Bool = false
    public var style: JNChatMessageStyle = .userStyle
    
    public func getTotolHeight() -> CGFloat {
        var height = JN_CHAT_SETTING.topSpace + JN_CHAT_SETTING.bottomSpace
        if self.style == .customStyle {
            height +=  self.messageContentSize.height
            if showTime {
                height += JN_CHAT_SETTING.timeLabelHeight + JN_CHAT_SETTING.tiemLabelBottomSpace
            }
            return height
        }

        height += {
            var contentHeight = self.messageContentSize.height
            if showNickname {
                contentHeight += JN_CHAT_SETTING.contentTopSpaceBaseAvatar
            }
            if contentHeight > JN_CHAT_SETTING.avatarSize.height{
                return contentHeight
            }
            return JN_CHAT_SETTING.avatarSize.height
        }()
        
        if showTime {
            height += JN_CHAT_SETTING.timeLabelHeight + JN_CHAT_SETTING.tiemLabelBottomSpace
        }
        return height
    }
}

//MARK: - base message -
public class JNChatBaseMessage: JNChatMessageDisplay {
    public var messageId:String = ""
    public var ownerId:String?   //发送者
    public var targetId:String?  //接收者
    public var owns: JNChatMessageOwns = .owner
    public var avatarUrl:String = ""
    public var nickname:String?
    private var _messageType:JNChatMessageType = JNChatMessageTypeUnknow
    public var messageType:JNChatMessageType {
        set{
            if JN_CHAT_SETTING.supportMessageType.contains(_messageType) {
                _messageType = newValue
            }
            else{
                _messageType = JNChatMessageTypeUnknow
                self.owns = .system
                self.style = .customStyle
                self.messageContentSize = JN_CHAT_SETTING.unknowMessageContentSize
            }
        }
        get{
            return _messageType
        }
    }
    public var revoke: Bool =  false {
        willSet{
            if newValue{
                self.style = .customStyle
                self.messageContentSize = JN_CHAT_SETTING.revokeMessageContentSize
            }
        }
    }
    public var sendResult: Bool =  false
    public var sendTime:String?
    
    public class func createMessageId() -> String{
        return UUID().uuidString
    }
}

//MARK: - text message -
public class JNChatTextMessage: JNChatBaseMessage {
    public var text: String = "" {
        willSet{
            var width = newValue.jn_getTextWidth(font: JN_CHAT_SETTING.textMessageFont)
            if width < JN_CHAT_SETTING.textMessageMaxWidth {
                if width < JN_CHAT_SETTING.textMessageMinWidth{
                    width = JN_CHAT_SETTING.textMessageMinWidth
                }
            }
            else{
                width = JN_CHAT_SETTING.textMessageMaxWidth
            }
            let edge = JN_CHAT_SETTING.textMessageTextEdge
            var height = newValue.jn_getTextHeight(givenWidth: width, font: JN_CHAT_SETTING.textMessageFont) + edge.top + edge.bottom
            if height < JN_CHAT_SETTING.textMessageMinHeight {
                height = JN_CHAT_SETTING.textMessageMinHeight
            }
            self.messageContentSize = CGSize(width: width + edge.left + edge.right, height: height)
        }
    }
}
