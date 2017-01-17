//
//  UIColor+Initialize.swift
//  SwiftTemple
//
//  Created by Fang on 2016/10/21.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

// MARK: -
// MARK: Initialize Extends UIColor
// MARK: -
extension UIColor {
  // MARK: -> Class methods
    // 颜色rgb
    public class func UIColorMake(_ red:CGFloat,_ green:CGFloat,_ blue:CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
    // 颜色rgb 带透明度
    public class func UIColorMake(_ red:CGFloat,_ green:CGFloat,_ blue:CGFloat,_ alpha:CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
  // MARK: -> Init methods
  
  // MARK: -> Public methods
}
