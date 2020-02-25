//
//  JNChatAudioExtension.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2020/2/14.
//  Copyright © 2020 Jonathan. All rights reserved.
//

import Foundation
import AVFoundation

extension URL {
    public func jn_getAudioFileDuration() -> TimeInterval {
        let asset = AVURLAsset.init(url: self, options: nil)
        return CMTimeGetSeconds(asset.duration)
    }
}

extension String{
    public func jn_getLocalAudioFileDuration() -> TimeInterval {
        return URL(fileURLWithPath: self).jn_getAudioFileDuration()
    }
}
