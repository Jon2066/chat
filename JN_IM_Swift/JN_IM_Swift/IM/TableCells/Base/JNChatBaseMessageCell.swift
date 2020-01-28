//
//  JNChatCustomCell.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/3.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit

class JNChatBaseMessageCell: UITableViewCell {
    
    weak var chatController: JNChatViewController?

    var owns: JNChatMessageOwns = .owner

    var messageContentSize: CGSize = CGSize(width: 100, height: 100)

    public var message:JNChatBaseMessage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    required init(owns: JNChatMessageOwns,reuseIdentifier: String?) {
        self.owns = owns
        super.init(style: CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.messageContent)

        weak var weakSelf = self
        self.timeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(JN_CHAT_SETTING.topSpace)
            make.left.right.equalToSuperview()
            make.height.equalTo(JN_CHAT_SETTING.timeLabelHeight)
        }
        self.messageContent.snp.makeConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            make.top.equalTo(weakSelf!.timeLabel.snp.bottom).offset(JN_CHAT_SETTING.tiemLabelBottomSpace)
            make.size.equalTo(weakSelf!.messageContentSize)
        }
    }
    
    private func updateMessageContentSize(size:CGSize) {
        if !size.equalTo(self.messageContentSize) {
            self.messageContentSize = size
            self.messageContent.snp.updateConstraints { (make) in
                make.size.equalTo(size)
            }
        }
    }
    
    public func updateWithMessgae(message: JNChatBaseMessage){
        if self.message?.showTime != message.showTime {
            weak var weakSelf = self
            if message.showTime{
                self.timeLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(JN_CHAT_SETTING.timeLabelHeight)
                }
                if message.style == .customStyle {
                    self.messageContent.snp.updateConstraints { (make) in
                        make.top.equalTo(weakSelf!.timeLabel.snp.bottom).offset(JN_CHAT_SETTING.tiemLabelBottomSpace)
                    }
                }
            }
            else{
                self.timeLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
                if message.style == .customStyle {
                    self.messageContent.snp.updateConstraints { (make) in
                        make.top.equalTo(weakSelf!.timeLabel.snp.bottom).offset(0)
                    }
                }
            }
        }
        if message.showTime {
            self.timeLabel.text = message.sendTime
        }
        else{
            self.timeLabel.text = nil
        }
        self.message = message
        self.updateMessageContentSize(size: message.messageContentSize)
    }

    lazy var timeLabel: UILabel = {
        let temp = UILabel()
        temp.font = JN_CHAT_SETTING.timeLabelFont
        temp.textColor = JN_CHAT_SETTING.timeLabelTextColor
        temp.textAlignment = .center
        return temp
    }()
    
    lazy var messageContent: UIView = {
        let temp = UIView()
        return temp
    }()
}
