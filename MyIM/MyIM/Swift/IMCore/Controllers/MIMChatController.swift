//
//  MIMChatController.swift
//  MyIM
//
//  Created by Jonathan on 16/6/3.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import UIKit

protocol MIMChatViewDataSource {
    /**
     *  获取cell消息内容
     *  contentView可复用  nil时创建
     *  若消息类型为完全自定义(MIMMessageCellStyleOthers) 则显示完全为contentView
     */
    func chatView(messageContentView cotentView: UIView, cellStyle style: MIMMessageCellStyle, forCellAtIndex index:Int) -> UIView
    
    /**
     *  获得消息内容的显示大小  MIMMessageCellStyleOthers 只参考高度 宽度为屏宽
     */
    func chatView(messageContentViewSizeForCellAtIndex index: Int) -> CGSize
    
    /**
     *  昵称  nil则不显示
     */
    func chatView(nicknameForCellAtIndex index: Int) -> String?
    
    /**
     *  消息时间 nil则不显示
     */
    func chatView(messageTimeForCellAtIndex index: Int) -> String?
    
    
    /**
     *  头像
     */
    func chatView(avatarWithCellStyle style:MIMMessageCellStyle) -> Int
    
    /**
     *  是否显示发送错误提示
     */
    func chatView(showErrorForCellAtIndex index: Int) -> Bool
    
    /**
     *  对话cell 头像左、右或其他类型 自定义的其他类型则不必传入（头像、昵称、时间）这些参数
     */
    func chatView(cellStyleAtIndex index: Int) -> MIMMessageCellStyle
    
    /**
     *  返回消息类型标识 用于复用(messageContent 复用id)
     */
    func chatView(messageTypeReusableIdentifierAtIndex index: Int) -> String
    
    /**
     *  消息数量
     */
    func chatViewNumberOfRows() -> Int
    
}

@objc protocol MIMChatViewDelegate {
    optional func chatView(willSendMessageText text:String)
    optional func chatView(didSelectAvatarAtIndex index: Int)
    optional func chatView(shouldCheckErrorAtIndex index: Int)
    optional func chatView(didSelectCellAtIndex index: Int)
    optional func chatView(willDisplayCellWithContentView contentView: UIView, atIndex index: Int)
}

class MIMChatController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputToolbar: MIMInputToolbar!
    
    @IBOutlet weak private var toolbarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var toolbarButtomConstraint: NSLayoutConstraint!
    
    weak var delegate: MIMChatViewDelegate?
    
    var dataSource: MIMChatViewDataSource?
    
    lazy var textView:UITextView = {
        let textView:UITextView = UITextView.init(frame: CGRectMake(5, 5, 5, 5), textContainer: nil)
        textView.layer.cornerRadius = 5.0
        textView.scrollIndicatorInsets = UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0)
        textView.returnKeyType = UIReturnKeyType.Send
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.textAlignment = NSTextAlignment.Natural
        textView.contentMode = UIViewContentMode.Redraw
        textView.font = UIFont.systemFontOfSize(17.0)
        textView.enablesReturnKeyAutomatically = true
        return textView
    }()
    
    var inputToolBarHeight: CGFloat = MIMInputToolbarHeight
    
    
    class func nib() -> MIMChatController{
        return MIMChatController.init(nibName: NSStringFromClass(MIMChatController), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.textView.delegate = self
        
        self.inputToolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return nil
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
