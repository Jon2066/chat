//
//  JNChatTextMessageCell.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/4.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
import SnapKit

class JNChatTextMessageCell: JNChatUserMessageCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell() {
        super.setupCell()
        self.messageContent.addSubview(self.backgroundImageView)
        self.messageContent.addSubview(self.textView)
        
        weak var weakSelf = self

        self.backgroundImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        self.textView.snp.makeConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            let edge = JN_CHAT_SETTING.textMessageTextEdge
            make.centerY.equalToSuperview()
            if weakSelf!.owns == .others{
                make.left.equalToSuperview().offset(edge.left - 1)
                make.right.equalToSuperview().offset(-edge.right + 1)
            }
            else{
                make.left.equalToSuperview().offset(edge.right - 1)
                make.right.equalToSuperview().offset(-edge.left + 1)
            }
        }
    }
    
    override func updateWithMessgae(message: JNChatBaseMessage) {
        super.updateWithMessgae(message: message)
        self.textView.attributedText = NSAttributedString(string: (message as! JNChatTextMessage).text, attributes: [NSAttributedString.Key.font:JN_CHAT_SETTING.textMessageFont,
                                                                                                                     NSAttributedString.Key.foregroundColor:JN_CHAT_SETTING.textMessageTextColor])
    }
    
    public lazy var textView: UITextView = {
        let temp = UITextView()
        temp.isEditable = false
        temp.isScrollEnabled = false
        temp.textAlignment = .center
        temp.font = JN_CHAT_SETTING.textMessageFont
        temp.backgroundColor = .clear
        temp.scrollIndicatorInsets = .zero
        temp.contentInset = .zero
        temp.textContainerInset = .zero
        temp.textContainer.lineFragmentPadding = 0
        temp.contentOffset = .zero
        return temp
    }()
    
    public lazy var backgroundImageView: UIImageView = {
        let temp = UIImageView()
        if self.owns == .owner {
            temp.image = UIImage(named: "chatto_bg_normal")?.resizableImage(withCapInsets: UIEdgeInsets(top: 35, left: 10, bottom: 10, right: 22))
        }
        else{
            temp.image = UIImage(named: "chatfrom_bg_normal")?.resizableImage(withCapInsets: UIEdgeInsets(top: 35, left: 22, bottom: 10, right: 10))
        }
        return temp
    }()
}
