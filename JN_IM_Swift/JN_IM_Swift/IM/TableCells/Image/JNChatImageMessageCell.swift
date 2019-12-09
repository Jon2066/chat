//
//  JNChatImageMessageCell.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/5.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
import SDWebImage

class JNChatImageMessageCell: JNChatUserMessageCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell() {
        super.setupCell()
        self.messageContent.addSubview(self.contentImageView)
        
        self.updateContentSpaceBaseAvatar(space: 5)
        
        self.contentImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
    override func updateWithMessgae(message: JNChatBaseMessage) {
        super.updateWithMessgae(message: message)
        let msg = message as! JNChatImageMessage
        if msg.image != nil {
            self.contentImageView.image = msg.image
        }
        else{
            if msg.imageUrl != nil{
                self.contentImageView.sd_setImage(with: URL(string: msg.imageUrl!), completed: nil)
            }
            else{
                self.contentImageView.image = nil
            }
        }
    }
    
    @objc func contentImageViewTap(tap: UITapGestureRecognizer){
        if self.delegate != nil {
            self.delegate?.jnChatViewDidClickImage(imageView: self.contentImageView, message: self.message! as! JNChatImageMessage)
        }
    }
    
    lazy var contentImageView: UIImageView  = {
        let temp = UIImageView()
        temp.layer.cornerRadius = JN_CHAT_SETTING.imageMessageCornerRadius
        temp.layer.masksToBounds = true
        temp.contentMode = .scaleAspectFill
        temp.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(contentImageViewTap(tap:)))
        temp.addGestureRecognizer(tap)
        return temp
    }()
}
