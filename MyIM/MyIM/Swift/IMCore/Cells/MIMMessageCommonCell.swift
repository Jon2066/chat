//
//  MIMMessageCommonCell.swift
//  MyIM
//
//  Created by Jonathan on 16/6/2.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import UIKit

class MIMMessageCommonCell: UITableViewCell {

    
    var messageContentView: UIView?{
        get{
            return self.messageContentView
        }
        set{
            if self.messageContentView === newValue {
                return
            }
            
            self.messageContentView?.removeFromSuperview()

            if newValue != nil {
                self.messageContentView = newValue
                self.contentView.addSubview(self.messageContentView!)
                //添加约束
                self.messageContentView?.translatesAutoresizingMaskIntoConstraints = false
                let leadingCt = NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.messageContentView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
                let trailingCt = NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.messageContentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
                let topCt = NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.messageContentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
                let bottomCt = NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.messageContentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
                
                self.contentView.addConstraints([leadingCt, trailingCt, topCt, bottomCt])
                self.contentView.updateConstraintsIfNeeded()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
