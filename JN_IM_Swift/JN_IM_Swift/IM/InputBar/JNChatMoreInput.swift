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
    
    private var moreInputItemDidClick: JNChatMoreInputItemDidClick?
    
    private var contentHeight: CGFloat {
        return 235
    }
    
    init(frame: CGRect, itemDidClick: @escaping JNChatMoreInputItemDidClick) {
        super.init(frame: frame)
        self.moreInputItemDidClick = itemDidClick
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(){
        
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.contentHeight)
        }
        let imageNames = ["sharemore_pic","sharemore_video"]
        let titles = ["照片","拍摄"]
        
        let itemWidth:CGFloat    = 59.0
        let itemHeight:CGFloat   = 80.0
        let itemsInLine:Int  = 4
        let itemVSpace:CGFloat   = (UIScreen.main.bounds.size.width - itemWidth * CGFloat(itemsInLine)) / (CGFloat(itemsInLine) + 1.0)
        let itemHSpace:CGFloat   = 25.0
        
        for (idx, title) in titles.enumerated() {
            let x:CGFloat = (CGFloat(idx % itemsInLine) + 1.0) * itemVSpace + itemWidth * CGFloat(idx % itemsInLine);
            let y:CGFloat = (CGFloat(idx / itemsInLine) + 1.0) * itemHSpace + itemHeight * CGFloat(idx / itemsInLine);
            let itemView = JNChatMoreInputItemView(frame:CGRect(x: x, y: y, width: itemWidth, height: itemHeight))
            let image = UIImage(named: imageNames[idx])
            itemView.type = JNChatMoreInputType(rawValue: idx)
            itemView.image = image
            itemView.title = title
            itemView.moreInputItemDidClick = self.moreInputItemDidClick
            self.scrollView.addSubview(itemView)
        }
    }
    
    
    lazy var scrollView: UIScrollView = {
        let temp = UIScrollView(frame: .zero)
        temp.showsHorizontalScrollIndicator = false
        temp.showsVerticalScrollIndicator = false
        return temp
    }()
    
}
