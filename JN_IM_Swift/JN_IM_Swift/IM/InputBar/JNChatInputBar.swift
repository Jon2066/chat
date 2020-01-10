//
//  JNChatInputBar.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/10.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
import SnapKit

typealias JNChatInputBarHeightChange = (CGFloat)->()

class JNChatInputBar: UIView {
    
    //MARK: - public property -
    public var inputBarHeightChange: JNChatInputBarHeightChange?
    
    weak public var delegate: JNChatViewDelegate?
    
    public var inputBarHeight: CGFloat {
        var height = JN_BOTTOM_SAFE_SPACE
        height += self.cotentViewHeight
        return height
    }
    
    private var cotentViewHeight: CGFloat {
        if self.contentView.bounds.size.height != 0 {
            return self.contentView.bounds.size.height
        }
        return 45
    }
    
    //MARK: - public method -
    
    //MARK: - private -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView(){
        self.addSubview(self.contentView)
        self.addSubview(self.line)
        
        self.contentView.addSubview(self.leftView)
        self.contentView.addSubview(self.rightView)
        self.contentView.addSubview(self.middleView)
        
        
        self.leftView.addSubview(self.switchInput)
        
        self.middleView.addSubview(self.textView)
        
        let contentHeight = 45
        
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(contentHeight)
        }
        
        self.line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.leftView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(contentHeight)
        }
        self.rightView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(contentHeight)
        }
        self.middleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.leftView.snp.right)
            make.right.equalTo(self.rightView.snp.left)
        }
        
        self.switchInput.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(35)
        }
        
        self.textView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
        
        self.updateConstraintsIfNeeded()
    }
    
    @objc func inputAction(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    
    //MARK: - lazy load -
    lazy var contentView: UIView = {
        let temp = UIView()
        
        return temp
    }()
    lazy var leftView: UIView = {
        let temp = UIView()
        
        return temp
    }()
    
    lazy var rightView: UIView = {
        let temp = UIView()
        
        return temp
    }()
    
    lazy var middleView: UIView = {
        let temp = UIView()
        
        return temp
    }()
    
    lazy var switchInput: UIButton = {
        let temp = UIButton()
        temp.setImage(UIImage(named: "ToolViewKeyboard"), for: .normal)
        temp.setImage(UIImage(named: "ToolViewInputVoice"), for: .selected)
        temp.addTarget(self, action: #selector(inputAction(sender:)), for: .touchUpInside)
        return temp
    }()
    
    lazy var textView: UITextView = {
        let temp = UITextView()
        temp.isScrollEnabled = false
        temp.textAlignment = .center
        temp.font = JN_CHAT_SETTING.textInputFont
        temp.backgroundColor = .clear
        temp.scrollIndicatorInsets = .zero
        temp.contentInset = .zero
        temp.textContainerInset = .zero
        temp.textContainer.lineFragmentPadding = 0
        temp.contentOffset = .zero
        temp.layer.borderWidth = 0.5
        temp.layer.borderColor = UIColor.lightGray.cgColor
        temp.layer.cornerRadius = 5
        temp.layer.masksToBounds = true
        temp.returnKeyType = .send
        return temp
    }()
    
    lazy var line: UIView = {
        let temp = UIView()
        temp.backgroundColor = .lightGray
        return temp
    }()
}
