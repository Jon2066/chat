//
//  MIMInputItem.swift
//  MyIM
//
//  Created by Jonathan on 16/5/31.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import Foundation
import UIKit
class MIMInputItem {
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    var buttons :[UIButton]
    
    init(buttons: [UIButton], width: CGFloat, height: CGFloat){
        self.buttons = buttons
        self.width = width;
        self.height = height
    }
}