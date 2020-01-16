//
//  JNChatInputBar.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/10.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit
import SnapKit

typealias JNChatInputBarHeightChange = (CGFloat, JNChatInputBar)->()

private var jnChat_textViewInitHeight: CGFloat = 35.0

class JNChatInputBar: UIView, UITextViewDelegate {
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.textView.removeObserver(self, forKeyPath: "contentSize")
    }
    //MARK: - public property -
    public var inputBarHeightChange: JNChatInputBarHeightChange?
    
    weak public var delegate: JNChatViewDelegate?
    
    public var inputBarHeight: CGFloat {
        var height = self.keyboardHeight
        if height == 0.0 {
            height = JN_BOTTOM_SAFE_SPACE
        }
        height += self.contentViewHeight
        return height
    }
    
    private var contentViewHeight: CGFloat {
        return (self.textViewHeight + 10)
    }
    
    //MARK: - public method -
    public func hideKeyboard(){
        self.textView.resignFirstResponder()
    }
    //MARK: - private -
    private var textViewHeight:CGFloat = jnChat_textViewInitHeight
    private var keyboardHeight:CGFloat = 0.0
    private let textContainerInset = UIEdgeInsets(top: floor((jnChat_textViewInitHeight - JN_CHAT_SETTING.textInputFont.lineHeight) / 2.0), left:0, bottom: 0, right: 0)
    private var textViewContentHeight: CGFloat = 0.0
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
        
        let contentHeight = self.contentViewHeight;
        
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
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(self.textViewHeight)
        }
        self.layoutIfNeeded()
    
        self.regKeyboardNoti()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    @objc func inputAction(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    //MARK: - keyboard -
    private func regKeyboardNoti(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
//    @objc func keyboardWillShow(noti:Notification){
//
//    }
    @objc func keyboardWillHide(noti:Notification){
        if self.keyboardHeight == 0.0 {
            return
        }
        self.keyboardHeight = 0.0;
        if (self.inputBarHeightChange != nil) {
            self.inputBarHeightChange!(self.inputBarHeight, self)
        }
    }
    @objc func keyboardWillChangeFrame(noti:Notification){
        let rect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if self.keyboardHeight == rect.size.height {
            return
        }
        self.keyboardHeight = rect.size.height
        if (self.inputBarHeightChange != nil) {
            self.inputBarHeightChange!(self.inputBarHeight, self)
        }
    }
    
    //MARK: - textview delegate -
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.delegate?.jnChatViewSendText(text: textView.text)
            textView.text = ""
            self.updateTextChangeWithTextHeight(height: 0.0)
            return false
        }
        return true
    }
        
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.bounds.size.width, height:JN_CHAT_SETTING.textInputMaxHeight))
        self.updateTextChangeWithTextHeight(height: size.height)
    }
    
    private func updateTextChangeWithTextHeight(height: CGFloat){
        guard self.textViewContentHeight != height else {
            return
        }
        self.textViewContentHeight = height
        self.textViewHeight = height + self.textContainerInset.top + self.textContainerInset.bottom
        if self.textViewHeight < jnChat_textViewInitHeight{
            self.textViewHeight = jnChat_textViewInitHeight
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, options: AnimationOptions.layoutSubviews, animations: {
           self.contentView.snp.updateConstraints { (make) in
                 make.height.equalTo(self.contentViewHeight)
          }
          if (self.inputBarHeightChange != nil) {
              self.inputBarHeightChange!(self.inputBarHeight, self)
          }
        }, completion: nil)
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
        temp.font = JN_CHAT_SETTING.textInputFont
        temp.textAlignment = .natural
        temp.backgroundColor = .clear
        temp.scrollIndicatorInsets = .zero
        temp.contentInset = .zero//self.textInputContentInset
        temp.textContainerInset = self.textContainerInset
//        temp.textContainer.lineFragmentPadding = 0
//        temp.contentOffset = .zero
        temp.layer.borderWidth = 0.5
        temp.layer.borderColor = UIColor.lightGray.cgColor
        temp.layer.cornerRadius = 5
        temp.layer.masksToBounds = true
        temp.returnKeyType = .send
        temp.delegate = self
        temp.showsHorizontalScrollIndicator = false
        temp.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            temp.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            
        }
        return temp
    }()
    
    lazy var line: UIView = {
        let temp = UIView()
        temp.backgroundColor = .lightGray
        return temp
    }()
}
