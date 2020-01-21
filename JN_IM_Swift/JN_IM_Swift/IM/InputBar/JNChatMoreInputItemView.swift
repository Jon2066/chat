//
//  JNChatMoreInputItemView.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2020/1/21.
//  Copyright © 2020 Jonathan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum JNChatMoreInputType: Int {
    case image = 0
    case carema = 1
}

typealias JNChatMoreInputItemDidClick = (JNChatMoreInputType)->()

class JNChatMoreInputItemView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var type: JNChatMoreInputType?
    
    public var image:UIImage? {
        willSet{
            self.itemImageButton.setImage(newValue, for: .normal)
        }
    }
    
    public var title:String? {
        willSet{
            self.itemTitleLabel.text = newValue
        }
    }
    
    public var moreInputItemDidClick: JNChatMoreInputItemDidClick?
    
    //MARK: - private -
    func setupSubviews()  {
        self.addSubview(self.itemImageButton)
        self.addSubview(self.itemTitleLabel)
        
        self.itemImageButton.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 59, height: 59))
        }
        
        self.itemTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.itemImageButton.snp.bottom).offset(0)
            make.left.right.equalTo(0)
        }
    }
    
    @objc func itemDidClick(sender: UIButton){
        guard self.type != nil else {
            return
        }
        if self.moreInputItemDidClick != nil {
            self.moreInputItemDidClick!(self.type!)
        }
    }
    
    lazy var itemImageButton: UIButton = {
        let temp = UIButton(type: .custom)
        temp.addTarget(self, action: #selector(itemDidClick(sender:)), for: .touchUpInside)
        return temp
    }()
    
    lazy var itemTitleLabel: UILabel = {
        let temp = UILabel()
        temp.font = JN_CHAT_SETTING.moreInputItemTitleFont
        temp.textColor = JN_CHAT_SETTING.moreInputItemTitleColor
        temp.textAlignment = .center
        return temp
    }()
}
