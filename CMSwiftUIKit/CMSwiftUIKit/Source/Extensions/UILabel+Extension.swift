//
//  UILabel+extension.swift
//  YFStore
//
//  Created by I Mac on 16/12/9.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation


extension UILabel {
    func addStrikthrough(string:String) {
        let length : Int = string.length
        let attri = NSMutableAttributedString.init(string: string)
        attri.addAttribute(NSStrikethroughStyleAttributeName, value:  NSNumber(value: 1), range: NSMakeRange(0, length))
        attri.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.lightGray, range: NSMakeRange(0, length))
        self.attributedText = attri
    }

}
