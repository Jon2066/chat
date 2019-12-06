//
//  ViewController.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/2.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addChild(self.ChatVC)
        self.view.addSubview(self.ChatVC.view)
        self.ChatVC.view.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        self.testLoadTextMessage()
        self.testRevokeMessage()
        self.testUnknowMessage()
    }
    
    lazy var ChatVC:JNChatViewController = {
        let temp = JNChatViewController.init()
        return temp
    }()

    
    func testLoadTextMessage() {
        let textMessage1 = JNChatTextMessage()
        textMessage1.text = "对方发来的文本消息"
        textMessage1.messageId = JNChatTextMessage.createMessageId()
        textMessage1.ownerId = "someone"
        textMessage1.targetId = "1"
        textMessage1.owns = .others
        textMessage1.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576223085&di=7788b63ee76f12210bdb40406c8326fb&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.qqjay.com%2Ftou2%2F2018%2F1218%2F8d0dea288c054bc2ea2ee509b4c8a4bd.jpg"
        textMessage1.nickname = "someone"
        textMessage1.messageType = JNChatMessageTypeText
        textMessage1.sendTime = "2019-12-06 08-08-08"
        textMessage1.showTime = true
        textMessage1.showNickname = false
        
        let textMessage2 = JNChatTextMessage()
        textMessage2.text = "我发送的文本消息"
        textMessage2.messageId = JNChatTextMessage.createMessageId()
        textMessage2.ownerId = "1"
        textMessage2.targetId = "someone"
        textMessage2.owns = .owner
        textMessage2.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575628674987&di=e97203f07bfb9bf6fa444aa9c9f1cfcc&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201605%2F05%2F20160505174655_JZRxC.jpeg"
        textMessage2.nickname = "myself"
        textMessage2.messageType = JNChatMessageTypeText
        textMessage2.sendTime = "2019-12-06 08-09-10"
        textMessage2.showTime = false
        textMessage2.showNickname = false
        
        let textMessage3 = JNChatTextMessage()
        textMessage3.text = "对方发来的文本消息2"
        textMessage3.messageId = JNChatTextMessage.createMessageId()
        textMessage3.ownerId = "someone"
        textMessage3.targetId = "1"
        textMessage3.owns = .others
        textMessage3.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576223085&di=7788b63ee76f12210bdb40406c8326fb&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.qqjay.com%2Ftou2%2F2018%2F1218%2F8d0dea288c054bc2ea2ee509b4c8a4bd.jpg"
        textMessage3.nickname = "someone"
        textMessage3.messageType = JNChatMessageTypeText
        textMessage3.sendTime = "2019-12-06 09-09-09"
        textMessage3.showTime = true
        textMessage3.showNickname = true
        
        self.ChatVC.appendMessages(messages: [textMessage1, textMessage2, textMessage3])
    }
    
    func testRevokeMessage() {
        let textMessage1 = JNChatTextMessage()
        textMessage1.text = "对方发来的文本消息"
        textMessage1.messageId = JNChatTextMessage.createMessageId()
        textMessage1.ownerId = "someone"
        textMessage1.targetId = "1"
        textMessage1.owns = .others
        textMessage1.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576223085&di=7788b63ee76f12210bdb40406c8326fb&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.qqjay.com%2Ftou2%2F2018%2F1218%2F8d0dea288c054bc2ea2ee509b4c8a4bd.jpg"
        textMessage1.nickname = "someone"
        textMessage1.messageType = JNChatMessageTypeText
        textMessage1.sendTime = "2019-12-06 08-08-08"
        textMessage1.showTime = true
        textMessage1.showNickname = false
        textMessage1.revoke = true
        
        self.ChatVC.appendMessages(messages: [textMessage1])
    }
    
    func testUnknowMessage() {
        let textMessage1 = JNChatTextMessage()
        textMessage1.text = "对方发来的文本消息"
        textMessage1.messageId = JNChatTextMessage.createMessageId()
        textMessage1.ownerId = "someone"
        textMessage1.targetId = "1"
        textMessage1.owns = .others
        textMessage1.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576223085&di=7788b63ee76f12210bdb40406c8326fb&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.qqjay.com%2Ftou2%2F2018%2F1218%2F8d0dea288c054bc2ea2ee509b4c8a4bd.jpg"
        textMessage1.nickname = "someone"
        textMessage1.messageType = "JNCHAT_MSG:??????"
        textMessage1.sendTime = "2019-12-06 08-08-08"
        textMessage1.showTime = true
        textMessage1.showNickname = false
        
        self.ChatVC.appendMessages(messages: [textMessage1])
    }
}

