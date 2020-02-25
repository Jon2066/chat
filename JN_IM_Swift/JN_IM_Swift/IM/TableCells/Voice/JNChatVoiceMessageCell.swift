//
//  JNChatVoiceMessageCell.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2020/2/20.
//  Copyright © 2020 Jonathan. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

class JNChatVoiceMessageCell: JNChatUserMessageCell {

    private var voiceMessage: JNChatVoiceMessage?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell() {
        super.setupCell()
        self.messageContent.addSubview(self.backgroundButton)
        self.backgroundButton.addSubview(self.durationLabel)
        self.backgroundButton.addSubview(self.voiceImageView)
        weak var weakSelf = self

        self.backgroundButton.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.voiceImageView.snp.makeConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 14.5, height: 16.5))

            if weakSelf!.owns == .others {
                make.left.equalToSuperview().offset(13)
            }
            else{
                make.right.equalToSuperview().offset(-13)
            }
        }
        
        self.durationLabel.snp.makeConstraints { (make) in
            guard (weakSelf != nil) else{
                return
            }
            make.top.bottom.equalToSuperview()
            if weakSelf!.owns == .others {
                make.right.equalToSuperview().offset(-3)
                make.left.equalToSuperview()
            }
            else{
                make.left.equalToSuperview().offset(3)
                make.right.equalToSuperview()
            }
            
        }
    }
    
    override func updateWithMessgae(message: JNChatBaseMessage) {
        super.updateWithMessgae(message: message)
        self.voiceMessage = (message as! JNChatVoiceMessage)
        self.durationLabel.text = "\(ceil(self.voiceMessage!.duation))\""
    }
    
    @objc func playClick(sender: UIButton){
        JNChatAudioPlayer.sharedAudioPlayer.stop()
        JNChatAudioPlayer.sharedAudioPlayer.playCallback = {(player: JNChatAudioPlayer, success:Bool)
            in
            self.voiceImageView.stopAnimating()
        }
        JNChatAudioPlayer.sharedAudioPlayer.play(url: self.voiceMessage!.fileUrl!)
        self.voiceImageView.startAnimating()
    }
    
    public lazy var voiceImageView: UIImageView = {
        let temp = UIImageView()
        if self.owns == .owner {
            temp.animationImages = [UIImage(named: "chatto_voice1")!,
                                    UIImage(named: "chatto_voice2")!,
                                    UIImage(named: "chatto_voice3")!]
            temp.image = UIImage(named: "chatto_voice3")
            
        }
        else{
            temp.animationImages = [UIImage(named: "chatfrom_voice1")!,
                                    UIImage(named: "chatfrom_voice2")!,
                                    UIImage(named: "chatfrom_voice3")!]
            temp.image = UIImage(named: "chatfrom_voice3")
        }
        temp.animationDuration = 0.5
        return temp
    }()
    
    public lazy var backgroundButton: UIButton = {
        let temp = UIButton(type: .custom)
        if self.owns == .owner {
            let image = UIImage(named: "chatto_bg_normal")?.resizableImage(withCapInsets: UIEdgeInsets(top: 35, left: 10, bottom: 10, right: 22))
            temp.setImage(image, for: .normal)
        }
        else{
            let image = UIImage(named: "chatfrom_bg_normal")?.resizableImage(withCapInsets: UIEdgeInsets(top: 35, left: 22, bottom: 10, right: 10))
            temp.setImage(image, for: .normal)
        }
        temp.addTarget(self, action: #selector(playClick(sender:)), for: .touchUpInside)
        return temp
    }()
    
    public lazy var durationLabel: UILabel = {
        let temp = UILabel()
        temp.font = JN_CHAT_SETTING.textMessageFont
        temp.backgroundColor = .clear
        if self.owns == .owner {
            temp.textAlignment = .left
        }
        else{
            temp.textAlignment = .right
        }
        return temp
    }()
}


