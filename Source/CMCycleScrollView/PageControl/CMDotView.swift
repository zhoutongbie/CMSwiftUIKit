//
//  TADotView.swift
//  YFStore
//
//  Created by Fang on 2016/12/20.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

class CMDotView: CMAbstractDotView {

    override init() {
        super.init()
        initialization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialization()  {
        self.backgroundColor = .clear
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor  = UIColor.white.cgColor
        self.layer.borderWidth  = 2
    }
    
    override func changeActivityState(active: Bool) {
        if active{
            self.backgroundColor = .white
        }else{
            self.backgroundColor = .clear
        }
    }
    
}
