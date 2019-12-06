//
//  JNChatUnknowMessageCell.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/5.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit

class JNChatUnknowMessageCell: JNChatBaseMessageCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func setupCell() {
        super.setupCell()
        self.messageContent.addSubview(self.unknowLabel)
        
        self.unknowLabel.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    override func updateWithMessgae(message: JNChatBaseMessage) {
        super.updateWithMessgae(message: message)
        self.unknowLabel.text = "未知消息 请升级"
    }
    
    lazy var unknowLabel: UILabel = {
        let temp = UILabel()
        temp.textColor = .gray
        temp.textAlignment = .center
        temp.font = UIFont.systemFont(ofSize: 12)
        return temp
    }()
}
