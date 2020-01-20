//
//  JNChatMoreInput.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2020/1/16.
//  Copyright © 2020 Jonathan. All rights reserved.
//

import Foundation
import UIKit

class JNChatMoreInputView: UIView {
    
    public var viewHeight: CGFloat {
        return  self.contentHeight + JN_BOTTOM_SAFE_SPACE
    }
    
    private var contentHeight: CGFloat {
        return 220
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(){
        self.setupSubViews()
        
    }
    
    
    private func setupSubViews(){
        self.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.contentHeight)
        } 
    }
    
    lazy var scrollView: UIScrollView = {
        let temp = UIScrollView(frame: .zero)
        temp.showsHorizontalScrollIndicator = false
        temp.showsVerticalScrollIndicator = false
        return temp
    }()
    
}
