//
//  JNChatAudioPlayer.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2020/2/6.
//  Copyright © 2020 Jonathan. All rights reserved.
//

import Foundation
import AVFoundation

typealias JNChatAudioPlayCallback = (JNChatAudioPlayer, Bool)->()

class JNChatAudioPlayer: NSObject, AVAudioPlayerDelegate {

    public static let sharedAudioPlayer = JNChatAudioPlayer()
    
    override init() {
        super.init()
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    public var playCallback: JNChatAudioPlayCallback?
    
    public func play(url: URL){
        self.setAudioActive()
        self.audioPlayer?.stop()
        self.audioPlayer?.delegate = nil
        self.audioPlayer = nil
        do{
            try self.audioPlayer = AVAudioPlayer.init(contentsOf: url)
            self.audioPlayer?.delegate = self
        }
        catch{
        }
        self.audioPlayer?.play()
    }
    
    public func stop(){
        self.audioPlayer?.stop()
        self.audioPlayer?.delegate = nil
        self.audioPlayer = nil
        if self.playCallback != nil {
            self.playCallback!(self, false)
        }
    }
    
    private func setAudioActive(){
        if AVAudioSession.sharedInstance().category !=  AVAudioSession.Category.playAndRecord {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
                try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            } catch  {

            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if self.playCallback != nil {
            self.playCallback!(self, flag)
        }
    }
}
