//
//  JNChatMessageCell.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/3.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
import SDWebImage

class JNChatUserMessageCell: JNChatBaseMessageCell {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(owns: JNChatMessageOwns, reuseIdentifier: String?) {
        super.init(owns: owns, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell() {
        super.setupCell()
        self.contentView.addSubview(self.avatarButton)
        self.contentView.addSubview(self.nicknameLabel)
        
        weak var weakSelf = self
        self.avatarButton.snp.makeConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            if weakSelf!.owns == .owner {
                make.right.equalToSuperview().offset(-JN_CHAT_SETTING.avatarLeftSpace)
            }
            else if weakSelf!.owns == .others{
                make.left.equalToSuperview().offset(JN_CHAT_SETTING.avatarLeftSpace)
            }
            make.top.equalTo(weakSelf!.timeLabel.snp.bottom).offset(JN_CHAT_SETTING.tiemLabelBottomSpace)
            make.size.equalTo(JN_CHAT_SETTING.avatarSize)
        }
        self.nicknameLabel.snp.makeConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            if weakSelf!.owns == .owner{
                make.right.equalTo(weakSelf!.avatarButton.snp.left).offset(-JN_CHAT_SETTING.nickNameLeftSpaceBaseAvatar)
            }
            else if weakSelf!.owns == .others{
                make.left.equalTo(weakSelf!.avatarButton.snp.right).offset(JN_CHAT_SETTING.nickNameLeftSpaceBaseAvatar)
            }
            make.top.equalTo(weakSelf!.avatarButton.snp.top).offset(JN_CHAT_SETTING.nickNameTopSpaceBaseAvatar)
            make.height.equalTo(JN_CHAT_SETTING.nickNameHeight)
        }
        self.messageContent.snp.remakeConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            make.top.equalTo(weakSelf!.avatarButton.snp.top).offset(JN_CHAT_SETTING.contentTopSpaceBaseAvatar)
            if weakSelf!.owns == .owner{
                make.right.equalTo(weakSelf!.avatarButton.snp.left).offset(-1)
            }
            else if weakSelf!.owns == .others{
                make.left.equalTo(weakSelf!.avatarButton.snp.right).offset(1)
            }
            make.size.equalTo(weakSelf!.messageContentSize)
        }
        
        if self.owns == .owner {
            self.nicknameLabel.textAlignment = .right
        }
        else if self.owns == .others {
            self.nicknameLabel.textAlignment = .left
        }
    }
    
    public func updateContentSpaceBaseAvatar(space: CGFloat){
        weak var weakSelf = self
        self.messageContent.snp.updateConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            if weakSelf!.owns == .owner{
                make.right.equalTo(weakSelf!.avatarButton.snp.left).offset(-space)
            }
            else if weakSelf!.owns == .others{
                make.left.equalTo(weakSelf!.avatarButton.snp.right).offset(space)
            }
        }
    }
    

    override func updateWithMessgae(message: JNChatBaseMessage) {
        weak var weakSelf = self
        if self.message?.showTime != message.showTime {
            if message.showTime{
                self.avatarButton.snp.updateConstraints { (make) in
                    make.top.equalTo(weakSelf!.timeLabel.snp.bottom).offset(JN_CHAT_SETTING.tiemLabelBottomSpace)
                }
            }
            else{
                self.avatarButton.snp.updateConstraints { (make) in
                    make.top.equalTo(weakSelf!.timeLabel.snp.bottom).offset(0)
                }
            }
        }
        if self.message?.showNickname != message.showNickname {
            if message.showNickname {
                self.nicknameLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(JN_CHAT_SETTING.nickNameHeight)
                }
                self.messageContent.snp.updateConstraints { (make) in
                    make.top.equalTo(weakSelf!.avatarButton.snp.top).offset(JN_CHAT_SETTING.contentTopSpaceBaseAvatar)
                }
            }
            else{
                self.nicknameLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
                self.messageContent.snp.updateConstraints { (make) in
                    make.top.equalTo(weakSelf!.avatarButton.snp.top).offset(0)
                }
            }
        }
        super.updateWithMessgae(message: message)
        if message.showNickname{
            self.nicknameLabel.text = message.nickname
        }
        else{
            self.nicknameLabel.text = nil
        }
        self.avatarButton.sd_setImage(with: URL(string: message.avatarUrl), for: .normal, completed: nil)
    }
    
    lazy var avatarButton: UIButton = {
        let temp = UIButton(type: .custom)
        temp.layer.cornerRadius = JN_CHAT_SETTING.avatarCornerRadius
        temp.layer.masksToBounds = true
        return temp
    }()
    

    
    lazy var nicknameLabel: UILabel = {
        let temp = UILabel()
        temp.font = JN_CHAT_SETTING.nickNameFont
        temp.textColor = JN_CHAT_SETTING.nickNameTextColor
        return temp
    }()
}
