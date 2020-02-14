//
//  JNChatViewDelegate.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/5.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import Foundation
import UIKit

protocol JNChatViewDelegate: class {
    func jnChatViewDidClickImage(imageView: UIImageView, message: JNChatImageMessage)

    func jnChatViewWillSendText(text: String)
    
    func jnChatViewWillSendImage(image: UIImage)
    
    func jnChatViewWillSendAudio(filePath: String)
}
