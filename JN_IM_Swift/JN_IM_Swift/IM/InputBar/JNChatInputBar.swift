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

enum JNChatInputStyle {
    case none
    case text
    case voice
    case more
}

private var jnChat_textViewInitHeight: CGFloat = 35.0

class JNChatInputBar: UIView, UITextViewDelegate {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - public property -
    public var inputBarHeightChange: JNChatInputBarHeightChange?
    
    weak public var delegate: JNChatViewDelegate?
    
    weak public var rootController: UIViewController?
    
    public var inputBarHeight: CGFloat {
        var height = self.keyboardHeight
        if height == 0.0 {
            height = JN_BOTTOM_SAFE_SPACE
        }
        if self.inputStyle == .more {
            height += self.moreInputView.viewHeight
        }
        height += self.toolBarHeight
        return height
    }
    
    //MARK: - public method -
    public func takeBackInputBar(){
        guard self.inputStyle != .none else {
            return
        }
        if self.inputStyle == .text {
            self.inputStyle = .none
            self.textView.resignFirstResponder()
        }
        else{
            self.inputStyle = .none
            self.updateContentHeightAnimated(animated: true)
        }
        
    }
    //MARK: - private -
    private var textViewHeight:CGFloat = jnChat_textViewInitHeight
    private var keyboardHeight:CGFloat = 0.0
    private let textContainerInset = UIEdgeInsets(top: floor((jnChat_textViewInitHeight - JN_CHAT_SETTING.textInputFont.lineHeight) / 2.0), left:0, bottom: 0, right: 0)
    private var textViewContentHeight: CGFloat = 0.0
    
    private var imagePicker: JNChatImagePicker?
    private var audioRecordComplete: Bool = false
    
    private var toolBarHeight: CGFloat {
        var height: CGFloat = 10.0
        if self.inputStyle == .voice || self.inputStyle == .none{
            height += jnChat_textViewInitHeight
        }
        else{
            height += self.textViewHeight
        }
        return height
    }
    private var inputStyle: JNChatInputStyle = .none

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView(){
        self.addSubview(self.toolBarView)
        self.addSubview(self.line)
        self.addSubview(self.moreInputView)

        self.toolBarView.addSubview(self.leftView)
        self.toolBarView.addSubview(self.rightView)
        self.toolBarView.addSubview(self.middleView)
        
        self.moreInputView.isHidden = true
        self.voiceInput.isHidden = true
        
        self.leftView.addSubview(self.switchInput)
        
        self.middleView.addSubview(self.textView)
        self.middleView.addSubview(self.voiceInput)
        
        self.rightView.addSubview(self.addInput)
        
        let toolbarHeight = self.toolBarHeight;
        
        self.toolBarView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(self.toolBarHeight)
        }
        
        self.line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.leftView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(toolbarHeight)
        }
        self.rightView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(toolbarHeight)
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
        
        self.voiceInput.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
        }

    
        self.addInput.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(35)
        }
        
        self.moreInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.toolBarView.snp.bottom)
            make.height.equalTo(self.moreInputView.viewHeight)
        }
        
        
        self.layoutIfNeeded()
    
        self.regKeyboardNoti()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - private method -
    private func updateContentHeightAnimated(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: AnimationOptions.layoutSubviews, animations: {
                self.toolBarView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.toolBarHeight)
                }
                if (self.inputBarHeightChange != nil) {
                    self.inputBarHeightChange!(self.inputBarHeight, self)
                }
            }, completion: nil)
        }
        else{
            self.toolBarView.snp.updateConstraints { (make) in
                make.height.equalTo(self.toolBarHeight)
            }
            if (self.inputBarHeightChange != nil) {
                self.inputBarHeightChange!(self.inputBarHeight, self)
            }
        }

    }
    
    //MARK: - button event -
    @objc func inputAction(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            self.inputStyle = .text
            self.textView.isHidden = false
            self.voiceInput.isHidden = true
            self.textView.becomeFirstResponder()
        }
        else{
            sender.isSelected = true
            self.inputStyle = .voice
            self.textView.isHidden = true
            self.voiceInput.isHidden = false
            self.textView.resignFirstResponder()
        }
        self.updateContentHeightAnimated(animated: true)
    }
    @objc func moreInputAction(sender: UIButton){
        let previous = self.inputStyle
        self.inputStyle = .more
        self.moreInputView.isHidden = false
        if previous == .text {
            self.textView.resignFirstResponder()
        }
        else{
            self.updateContentHeightAnimated(animated: true)
        }
    }
    
    @objc func voiceInputTouchDown(sender: UIButton){
        sender.setTitle("松开 结束", for: .normal)
        let fileName =  UUID().uuidString
        let path = JN_CHAT_SETTING.voiceFileSavePath + "/" + fileName + ".aac"
        self.audioRecorder.startRecord(filePath: path, maxRecordTime: JN_CHAT_SETTING.voiceMaxRecordDuration)
    }
    
    @objc func voiceInputTouchUpInside(sender: UIButton){
        sender.setTitle("按住 说话", for: .normal)
        self.audioRecordComplete = true
        self.audioRecorder.stopRecord()
    }
    
    @objc func voiceInputTouchOutside(sender: UIButton){
        sender.setTitle("按住 说话", for: .normal)
        self.audioRecordComplete = false
        self.audioRecorder.stopRecord()
    }
    
    //MARK: - keyboard -
    private func regKeyboardNoti(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
//    @objc func keyboardWillShow(noti:Notification){
//        self.inputStyle = .text
//    }
    @objc func keyboardWillHide(noti:Notification){
        if self.keyboardHeight == 0.0 {
            return
        }
        self.keyboardHeight = 0.0;
        self.updateContentHeightAnimated(animated: true)
    }
    @objc func keyboardWillChangeFrame(noti:Notification){
        let rect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if self.keyboardHeight == rect.size.height {
            return
        }
        self.keyboardHeight = rect.size.height
        self.updateContentHeightAnimated(animated: false)
    }
    
    //MARK: - textview delegate -
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if(textView.text == "" || textView.text.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
                return false
            }
            self.delegate?.jnChatViewWillSendText(text: textView.text)
            textView.text = ""
            self.updateTextChangeWithTextHeight(height: 0.0)
            return false
        }
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.inputStyle = .text
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
        self.updateContentHeightAnimated(animated: true)
    }
    
    
    private func moreInputAction(type:JNChatMoreInputType){
        if self.rootController != nil {
            weak var weakSelf = self
            if type == .image {
                self.imagePicker = JNChatImagePicker(rootController: self.rootController!)
                self.imagePicker?.showImagePicker(type: .photo, completion: { (image: UIImage) in
                    weakSelf?.delegate?.jnChatViewWillSendImage(image: image)
                })
            }
            else if type == .carema{
                self.imagePicker = JNChatImagePicker(rootController: self.rootController!)
                self.imagePicker?.showImagePicker(type: .camera, completion: { (image: UIImage) in
                    weakSelf?.delegate?.jnChatViewWillSendImage(image: image)
                })
            }
        }

    }
    
    //MARK: - lazy load -
    lazy var toolBarView: UIView = {
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
        temp.setImage(UIImage(named: "ToolViewKeyboard"), for: .selected)
        temp.setImage(UIImage(named: "ToolViewInputVoice"), for: .normal)
        temp.addTarget(self, action: #selector(inputAction(sender:)), for: .touchUpInside)
        return temp
    }()
    
    lazy var addInput: UIButton = {
        let temp = UIButton()
        temp.setImage(UIImage(named: "TypeSelectorBtn_Black"), for: .normal)
        temp.addTarget(self, action: #selector(moreInputAction(sender:)), for: .touchUpInside)
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
    
    lazy var moreInputView: JNChatMoreInputView = {
        weak var weakSelf = self
        let temp  = JNChatMoreInputView(frame:.zero, itemDidClick: { (type: JNChatMoreInputType) in
            weakSelf?.moreInputAction(type: type)
        })
        return temp
    }()
    
    lazy var voiceInput: UIButton = {
        let temp = UIButton(type: UIButton.ButtonType.custom)
        temp.frame = .zero
        temp.layer.borderWidth = 0.5
        temp.layer.borderColor = UIColor.lightGray.cgColor
        temp.layer.cornerRadius = 5
        temp.layer.masksToBounds = true
        temp.setTitle("按住 说话", for: .normal)
        temp.addTarget(self, action: #selector(voiceInputTouchDown(sender:)), for: .touchDown)
        temp.addTarget(self, action: #selector(voiceInputTouchUpInside(sender:)), for: .touchUpInside)
        temp.addTarget(self, action: #selector(voiceInputTouchOutside(sender:)), for: .touchUpOutside)
        temp.setTitleColor(.black, for: .normal)
        temp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return temp
    }()
    
    lazy var audioRecorder: JNChatAudioRecorder = {
        let temp = JNChatAudioRecorder()
        weak var weakSelf = self
        temp.recordDidFinish = { (recorder:JNChatAudioRecorder, finish:Bool) in
            if finish && (weakSelf?.audioRecordComplete ?? false) {
                weakSelf?.delegate?.jnChatViewWillSendAudio(filePath: recorder.filePath ?? "")
            }
        }
        return temp
    }()
}
