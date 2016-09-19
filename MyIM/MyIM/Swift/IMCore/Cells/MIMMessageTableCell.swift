//
//  MIMMessageTableCell.swift
//  MyIM
//
//  Created by Jonathan on 16/6/1.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import UIKit

class MIMMessageTableCell: UITableViewCell {
    
    var style: MIMMessageCellStyle = MIMMessageCellStyle.incoming
    var atIndex: Int = 0
    var messageContentView: UIView?{
        get{
            return self.messageContentView
        }
        set{
            if newValue == nil {
                return
            }
            if self.messageContentView == nil { //view还没有设置过
                if(self.messageContentView !== newValue){
                    self.messageContentView?.removeFromSuperview()
                    self.contentView.addSubview(newValue!)
                    self.messageContentView = newValue
                }
                else{
                    //存在 并且和之前的是同一个view 不做操作
                    return;
                }
            }
            self.updateViewConstraint()
        }
    }
    var messageContentSize: CGSize?{
        get{
            return self.messageContentSize
        }
        set{
            if newValue == nil {
                return;
            }
            if self.messageContentSize != nil && CGSizeEqualToSize(self.messageContentSize!, newValue!){
                return;
            }
            
            self.messageContentSize = newValue
            self.contentMHC!.constant = self.messageContentSize!.height;
            self.contentMVC!.constant = self.messageContentSize!.width;
            self.updateConstraints()
        }
    }
    var avatar: MIMImageItem?{
        get{
            return self.avatar
        }
        set{
            if newValue == nil || self.avatar === newValue {
                return;
            }
            let previousAvatarUrl: String? = self.avatar?.thumbUrl == nil ?self.avatar?.thumbUrl:self.avatar?.url
            let avatarUrl: String? = newValue?.thumbUrl == nil ?newValue?.thumbUrl:newValue?.url
            if previousAvatarUrl != nil && avatarUrl != nil && previousAvatarUrl != avatarUrl {
                
            }
            else{
                self.avatar = newValue
                if avatarUrl == nil {
                    self.avatarButton.setImage(self.avatar?.placeHolderImage, forState: UIControlState.Normal)
                }
                else{
                    self.avatarButton.sd_setImageWithURL(NSURL.init(string: avatarUrl!), forState: UIControlState.Normal, placeholderImage: self.avatar?.placeHolderImage)
                }
            }
        }
    }
    var nickname: String?{
        get{
            return self.nickname
        }
        set{
            self.nickname = newValue
            if self.nickname != nil {
                self.nicknameHeightConstraint.constant = MIMNicknameLabelHeight
            }
            else{
                self.nicknameHeightConstraint.constant = 0.0
            }
            self.nicknameLabel.text = self.nickname
            self.updateConstraintsIfNeeded()
        }
    }
    var messageTime: String?{
        get{
            return self.messageTime
        }
        set{
            self.messageTime = newValue
            if self.messageTime != nil {
                self.timeHeightConstraint.constant = MIMTimeLabelHeight
            }
            else{
                self.timeHeightConstraint.constant = 0
            }
            self.timeLabel.text = self.messageTime
            self.updateConstraintsIfNeeded()
        }
    }
    
    var showError: Bool? {
        get{
            return self.showError
        }
        set{
            if (newValue != nil && newValue!) {
                self.setupErrorButton()
            }
            else{
                self.errorButton?.hidden = true
            }
        }
    }
    
    override var reuseIdentifier: String? {
        get {
            return self.reuseIdentifier
        }
        set{
            self.reuseIdentifier = newValue
        }
    }
    
    @IBOutlet weak private var timeLabel: UILabel!
    
    @IBOutlet weak private var avatarButton: UIButton!
    
    @IBOutlet weak private var nicknameLabel: UILabel!
    
    @IBOutlet weak private var avatarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var avatarWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var timeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var nicknameHeightConstraint: NSLayoutConstraint!
    
    private var contentMHC: NSLayoutConstraint?
    
    private var contentMVC: NSLayoutConstraint?

    private var errorButton:UIButton?
    
    private var avatarClick: ((index: Int)->())?
    
    private var errorClick: ((index: Int)->())?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func nib(style: MIMMessageCellStyle, reuseIdentifier: String) -> MIMMessageTableCell {
        let nibName: String = (style == MIMMessageCellStyle.incoming ?"MIMMessageInCell" : "MIMMessageOutCell")
        let cell: MIMMessageTableCell = (NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? MIMMessageTableCell)!
        cell.reuseIdentifier = reuseIdentifier
        cell.style = style
        return cell
    }
    
    
    func updateViewConstraint(){
        self.messageContentView?.translatesAutoresizingMaskIntoConstraints = false
        var leadingCt: NSLayoutConstraint?
        
        if self.style == MIMMessageCellStyle.outgoing {
            leadingCt = NSLayoutConstraint.init(item: self.avatarButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.messageContentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: MIMAvatarAndContentSpace)
        }
        else{
            leadingCt = NSLayoutConstraint.init(item: self.avatarButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.messageContentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -MIMAvatarAndContentSpace)
        }
        
        let topCt = NSLayoutConstraint.init(item: self.nicknameLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.messageContentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: MIMNicknameAndContentSpace)
        
        self.contentMHC = NSLayoutConstraint.init(item: self.messageContentView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 0)
        self.contentMVC = NSLayoutConstraint.init(item: self.messageContentView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0.0)
        
        self.contentView.addConstraints([leadingCt!, topCt, self.contentMHC!, self.contentMVC!])
        self.updateConstraints()

    }
    
    func setupErrorButton(){
        if self.errorButton == nil {
            self.errorButton = UIButton.init(type: UIButtonType.Custom)
            self.errorButton?.setImage(UIImage.init(named: "message_fail"), forState: UIControlState.Normal)
            self.errorButton?.addTarget(self, action: #selector(errorButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.contentView.bringSubviewToFront(self.errorButton!)

    }
    
    func errorButtonClick() {
        if self.errorClick != nil {
            self.errorClick!(index: self.atIndex)                                                                                                                                                                   
        }
    }
    
    @IBAction private func avatarButtonClick(sender: UIButton) {
        if self.avatarClick != nil {
            self.avatarClick!(index: atIndex)
        }
    }
    
    func receiveAvatarClick(click: (index: Int) ->()) {
        self.avatarClick = click
    }
    
    func receiveErrorClick(click: (index: Int) ->()) {
        self.errorClick = click
    }
}
