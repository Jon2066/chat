//
//  MIMStringExtension.swift
//  MyIM
//
//  Created by Jonathan on 16/5/31.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import Foundation

extension String {
    func MD5() -> String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = ""
        for i in 0 ..< digestLen {
           hash += String(format: "%02x", result[i])
        }
        result.dealloc(digestLen)
        
        return hash
    }
}