//
//  JNChatRevokeMessageCell.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/6.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit

class JNChatRevokeMessageCell: JNChatBaseMessageCell {


    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell() {
        super.setupCell()
        self.messageContent.addSubview(self.revokeLabel)
        
        self.revokeLabel.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    override func updateWithMessgae(message: JNChatBaseMessage) {
        super.updateWithMessgae(message: message)
        if message.owns == .owner {
            self.revokeLabel.text = "你撤回了一条消息"
        }
        else{
            self.revokeLabel.text = "对方撤回了一条消息"
        }
    }
    
    lazy var revokeLabel: UILabel = {
        let temp = UILabel()
        temp.textColor = .gray
        temp.textAlignment = .center
        temp.font = UIFont.systemFont(ofSize: 12)
        return temp
    }()
}
