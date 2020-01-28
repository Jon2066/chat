//
//  JNChatBaseMessage.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/4.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit

//MARK: -  display model -
public class JNChatMessageDisplay {
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
            if JN_CHAT_SETTING.supportMessageType.contains(newValue) {
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

//MARK: - image message -
public class JNChatImageMessage: JNChatBaseMessage {
    public var imageUrl:String?
    public var image:UIImage? //有image的时候展示image（仅自己发送图片时用于上传 发送成功改为url 不能把大量图片放入内存）
    public var imageSize:CGSize = .zero {
        willSet{
            let ratio = newValue.height / newValue.width
            let maxWidth = JN_CHAT_SETTING.imageMessageMaxWidth
            let minWidth = JN_CHAT_SETTING.imageMessageMinWidth
            let maxHeight = JN_CHAT_SETTING.imageMessageMaxHeight
            let minHeight = JN_CHAT_SETTING.imageMessageMinHeight
            let minHeightRatio = minHeight / maxWidth
            let minWidthRatio = maxHeight / minHeight
            if newValue.equalTo(.zero) {
                self.messageContentSize = CGSize(width: maxWidth, height: maxHeight)
            }
            if ratio <= 1 {
                if ratio <= minHeightRatio {
                    if newValue.width < maxWidth{
                        self.messageContentSize = CGSize(width: newValue.width, height: newValue.width * minHeightRatio)
                    }
                    else{
                        self.messageContentSize = CGSize(width: maxWidth, height: minHeight)
                    }
                }
                else{
                    if newValue.width < maxWidth{
                        self.messageContentSize = CGSize(width: newValue.width, height: newValue.height)
                    }
                    else{
                        self.messageContentSize = CGSize(width: maxWidth, height: maxWidth * ratio)
                    }
                }
            }
            else{
                if ratio >= minWidthRatio {
                    if newValue.height < maxHeight {
                        self.messageContentSize = CGSize(width: newValue.height / minWidthRatio, height: newValue.height)
                    }
                    else{
                        self.messageContentSize = CGSize(width: minWidth, height: minHeight)
                    }
                }
                else{
                    if newValue.height < maxHeight {
                        self.messageContentSize = newValue
                    }
                    else{
                        self.messageContentSize = CGSize(width: maxHeight / ratio, height: maxHeight)
                    }
                }
            }
        }
        
    }
}
