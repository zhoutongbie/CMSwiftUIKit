//
//  CMAbstractDotView.swift
//  YFStore
//
//  Created by Fang on 2016/12/20.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

class CMAbstractDotView: UIView {

    init() {
        fatalError("You must override init")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func changeActivityState(active:Bool) {
        fatalError("You must override changeActivityState")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
