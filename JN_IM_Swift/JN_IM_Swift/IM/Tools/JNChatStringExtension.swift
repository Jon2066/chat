//
//  JNChatTextSize.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/5.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    public func jn_getTextHeight(givenWidth:CGFloat, font:UIFont) -> CGFloat {
        return (self as NSString).boundingRect(with: CGSize(width: givenWidth, height: CGFloat(MAXFLOAT)), options:NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesFontLeading.rawValue) | UInt8(NSStringDrawingOptions.truncatesLastVisibleLine.rawValue) | UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue))), attributes: [NSAttributedString.Key.font:font], context: nil).size.height
    }
    
    public func jn_getTextWidth(font:UIFont) -> CGFloat {
        return (self as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options:NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesFontLeading.rawValue) | UInt8(NSStringDrawingOptions.truncatesLastVisibleLine.rawValue) | UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue))), attributes: [NSAttributedString.Key.font:font], context: nil).size.width
    }
}
