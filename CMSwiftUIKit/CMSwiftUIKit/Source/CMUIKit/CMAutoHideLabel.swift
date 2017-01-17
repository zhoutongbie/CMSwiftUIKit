//
//  CMAutoHideLabel.swift
//  YFStore
//
//  Created by Fang on 2016/12/2.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

class CMAutoHideLabel: UILabel {
    override var text: String?{
        willSet{
            ///当值为空或者0时label自动隐藏
            if(newValue?.isEmpty)! || newValue?.toInt() == 0{
                self.isHidden = true
            }else{
                self.isHidden = false
            }
        }
    }
}
