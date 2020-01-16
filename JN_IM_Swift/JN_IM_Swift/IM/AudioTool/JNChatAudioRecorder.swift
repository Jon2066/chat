//
//  JNChatAudioRecorder.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2020/1/16.
//  Copyright © 2020 Jonathan. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

///Bool 是否完成录音
typealias JNChatAudioRecordFinishCallBack = (JNChatAudioRecorder, Bool)->()

///返回录音音量 0.0 - 1.0
typealias JNChatAudioRecordAveragePowerCallBack = (Double)->()

class JNChatAudioRecorder:NSObject, AVAudioRecorderDelegate {
    /// 采样率 默认16000
    public var sampleRate: Double = 16000
    
    /// 输出格式 默认 kAudioFormatMPEG4AAC
    public var format: AudioFormatID =  kAudioFormatMPEG4AAC
    
    /// 位数 8, 16, 24, 32  默认16
    public var bits: Int = 16
    
    /// 通道 默认单通道 1
    public var numberOfChannels: Int = 1
    
    ///是否要检测音量 默认NO 可以中途设置
    public var updateMeters: Bool = false{
        willSet{
            if (newValue && (self.recorder?.isRecording ?? false)) {
                self.startTimer()
            }
            else{
                self.timer?.invalidate()
            }
        }
    }
    
    /// 当前录制时长
    public var currentTime: TimeInterval = 0.0
    
    ///最大录制时长
    public var maxRecordTime: TimeInterval = 60.0
    
    private var _filePath: String?
    /// 录音文件保存路径
    public var filePath: String? {
        get{
            return _filePath
        }
    }
    
    private var _recorder: AVAudioRecorder?
    
    public var recorder: AVAudioRecorder? {
        get{
            return _recorder
        }
    }
    
    /// 录制完成回调
    public var recordDidFinish: JNChatAudioRecordFinishCallBack?
    
    ///返回录音音量 0.0 - 1.0
    public var recordAveragePower: JNChatAudioRecordAveragePowerCallBack?
    
    weak private var timer:Timer?
    
    ///开始录制 设置属性需要在开始之前
    ///filePath 文件路径必须先创建
    public func startRecord(filePath: String, maxRecordTime: TimeInterval){
        self._filePath = filePath
        self.maxRecordTime = maxRecordTime
        self.stopRecord()
        if AVAudioSession.sharedInstance().category == AVAudioSession.Category.playAndRecord {
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            }
            catch {
                
            }
        }
        do{
            try self._recorder = AVAudioRecorder.init(url: NSURL.fileURL(withPath: filePath), settings: self.getAudioRecordSetting())
        }
        catch{
            
        }
        self._recorder?.isMeteringEnabled = true
        self._recorder?.delegate = self

        self._recorder?.prepareToRecord()
        
        self._recorder?.record(forDuration: maxRecordTime)
        
        if self.updateMeters {
            self.startTimer()
        }
    }
    
    public func stopRecord(){
        self.recorder?.stop()
        self.timer?.invalidate()
    }
    
    private func getAudioRecordSetting() -> [String:Any]{
        return [
            AVSampleRateKey        : self.sampleRate,  //采样率 8k
            AVFormatIDKey          : self.format,
            AVLinearPCMBitDepthKey : self.bits, //采样位数
            AVNumberOfChannelsKey  : self.numberOfChannels
        ]
    }
    
    private func startTimer(){
        weak var weakSelf = self
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            guard weakSelf != nil else{
                timer.invalidate()
                return
            }
            weakSelf?.recorder?.updateMeters()
            if let power = weakSelf?.recorder?.averagePower(forChannel: 0){
                var power1 = power + 50.0
                if power1 < 0 {
                    power1 = 0
                }
                let progress = power1 / 50.0
                if weakSelf?.recordAveragePower != nil {
                    weakSelf!.recordAveragePower!(Double(progress))
                }
            }
        })
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if recorder == self.recorder {
            if self.recordDidFinish != nil {
                self.recordDidFinish!(self, flag)
            }
        }
    }
}
