//
//  ViewController.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/2.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController,JNChatViewDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addChild(self.ChatVC)
        self.view.addSubview(self.ChatVC.view)
        self.ChatVC.view.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(JN_TOP_SAFE_SPACE)
        }
        self.view.updateConstraintsIfNeeded()
        
        var msgs: [JNChatBaseMessage] = []
        msgs.append(contentsOf: self.testLoadTextMessage())
        msgs.append(contentsOf: self.testRevokeMessage())
        msgs.append(contentsOf: self.testUnknowMessage())
        msgs.append(contentsOf: self.testImageMessage())
        msgs.append(contentsOf: self.testLoadTextMessage())

        self.ChatVC.loadWithMessages(messages: msgs)
        
        self.ChatVC.scrollToBottom(animated: false)
    }
    
    
    lazy var ChatVC:JNChatViewController = {
        let temp = JNChatViewController.init()
        temp.delegate = self
        return temp
    }()

    //MARK: - delegate -
    
    func jnChatViewDidClickImage(imageView: UIImageView, message: JNChatImageMessage) {
        
    }
    
    func jnChatViewSendText(text: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let textMessage = JNChatTextMessage()
        textMessage.text = text
        textMessage.messageId = JNChatTextMessage.createMessageId()
        textMessage.ownerId = "1"
        textMessage.targetId = "someone"
        textMessage.owns = .owner
        textMessage.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575628674987&di=e97203f07bfb9bf6fa444aa9c9f1cfcc&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201605%2F05%2F20160505174655_JZRxC.jpeg"
        textMessage.nickname = "myself"
        textMessage.messageType = JNChatMessageTypeText
        textMessage.sendTime = dateFormatter.string(from: Date.init())
        textMessage.showTime = arc4random()%2 == 0
        textMessage.showNickname = arc4random()%2 == 0
        self.ChatVC.appendMessages(messages: [textMessage])
        self.ChatVC.scrollToBottom(animated: true)
    }
    
    func jnChatViewWillSendImage(image: UIImage) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let imageMessage = JNChatImageMessage()
        imageMessage.image = image
        imageMessage.imageSize = image.size
        imageMessage.messageId = JNChatImageMessage.createMessageId()
        imageMessage.ownerId = "1"
        imageMessage.targetId = "someone"
        imageMessage.owns = .owner
        imageMessage.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575628674987&di=e97203f07bfb9bf6fa444aa9c9f1cfcc&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201605%2F05%2F20160505174655_JZRxC.jpeg"
        imageMessage.nickname = "myself"
        imageMessage.messageType = JNChatMessageTypeImage
        imageMessage.sendTime = dateFormatter.string(from: Date.init())
        imageMessage.showTime = arc4random()%2 == 0
        imageMessage.showNickname = arc4random()%2 == 0
        self.ChatVC.appendMessages(messages: [imageMessage])
        self.ChatVC.scrollToBottom(animated: true)
    }
    
    //MARK: - test -
    
    func testLoadTextMessage() -> [JNChatBaseMessage]{
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
        
        return [textMessage1, textMessage2, textMessage3]
    }
    
    func testRevokeMessage() -> [JNChatBaseMessage]{
        let textMessage1 = JNChatTextMessage()
        textMessage1.text = "对方发来的文本消息"
        textMessage1.messageId = JNChatTextMessage.createMessageId()
        textMessage1.ownerId = "someone"
        textMessage1.targetId = "1"
        textMessage1.owns = .others
        textMessage1.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576223085&di=7788b63ee76f12210bdb40406c8326fb&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.qqjay.com%2Ftou2%2F2018%2F1218%2F8d0dea288c054bc2ea2ee509b4c8a4bd.jpg"
        textMessage1.nickname = "someone"
        textMessage1.messageType = JNChatMessageTypeText
        textMessage1.sendTime = "2019-12-06 10-08-08"
        textMessage1.showTime = true
        textMessage1.showNickname = false
        textMessage1.revoke = true
        
        return [textMessage1]
    }
    
    func testUnknowMessage() -> [JNChatBaseMessage] {
        let textMessage1 = JNChatTextMessage()
        textMessage1.text = "对方发来的文本消息"
        textMessage1.messageId = JNChatTextMessage.createMessageId()
        textMessage1.ownerId = "someone"
        textMessage1.targetId = "1"
        textMessage1.owns = .others
        textMessage1.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576223085&di=7788b63ee76f12210bdb40406c8326fb&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.qqjay.com%2Ftou2%2F2018%2F1218%2F8d0dea288c054bc2ea2ee509b4c8a4bd.jpg"
        textMessage1.nickname = "someone"
        textMessage1.messageType = "JNCHAT_MSG:??????"
        textMessage1.sendTime = "2019-12-06 11-08-08"
        textMessage1.showTime = true
        textMessage1.showNickname = false
        
       return [textMessage1]
    }
    
    func testImageMessage() -> [JNChatBaseMessage]{
        let imageMesage = JNChatImageMessage()
        imageMesage.messageId = JNChatTextMessage.createMessageId()
        imageMesage.ownerId = "someone"
        imageMesage.targetId = "1"
        imageMesage.owns = .others
        imageMesage.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576223085&di=7788b63ee76f12210bdb40406c8326fb&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.qqjay.com%2Ftou2%2F2018%2F1218%2F8d0dea288c054bc2ea2ee509b4c8a4bd.jpg"
        imageMesage.nickname = "someone"
        imageMesage.messageType = JNChatMessageTypeImage
        imageMesage.sendTime = "2019-12-06 12-08-08"
        imageMesage.showTime = true
        imageMesage.showNickname = true
        
        imageMesage.imageUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575887449027&di=9a8e3f9b192abe96e4f142ed62b17dbf&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Ff603918fa0ec08fa3139e00153ee3d6d55fbda5f.jpg"
        imageMesage.imageSize = CGSize(width: 1280.0 / UIScreen.main.scale, height: 1280.0 / UIScreen.main.scale)
        
        
        let imageMesage2 = JNChatImageMessage()
        imageMesage2.messageId = JNChatTextMessage.createMessageId()
        imageMesage2.ownerId = "someone"
        imageMesage2.targetId = "1"
        imageMesage2.owns = .owner
        imageMesage2.avatarUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575628674987&di=e97203f07bfb9bf6fa444aa9c9f1cfcc&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201605%2F05%2F20160505174655_JZRxC.jpeg"
        imageMesage2.nickname = "someone"
        imageMesage2.messageType = JNChatMessageTypeImage
        imageMesage2.sendTime = "2019-12-06 13-08-08"
        imageMesage2.showTime = false
        imageMesage2.showNickname = false

        imageMesage2.imageUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575888775853&di=d393a6ea9810f383c07d2409cf11e3cb&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201302%2F19%2F133254fnqfrrqegrbqgk8z.jpg"
        imageMesage2.imageSize = CGSize(width: 720.0 / UIScreen.main.scale, height: 1280.0 / UIScreen.main.scale)
        
        return [imageMesage, imageMesage2]

    }
}

