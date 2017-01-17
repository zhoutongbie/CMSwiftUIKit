//
//  UIView+Extension.swift
//  YFStore
//
//  Created by Fang on 2016/11/29.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    var cm_height : CGFloat {
        set{
            var temp = self.frame
            temp.size.height = cm_height
            self.frame = temp
        }
        get{
            return self.frame.size.height
        }
    }
    var cm_width : CGFloat {
        set{
            var temp = self.frame
            temp.size.width = cm_width
            self.frame = temp
        }
        get{
            return self.frame.size.width
        }
    }
    var cm_y : CGFloat{
        set{
            var temp = self.frame
            temp.origin.y = cm_y
            self.frame = temp
        }
        get{
            return self.frame.origin.y
        }
    }
    var cm_x : CGFloat{
        set{
            var temp = self.frame
            temp.origin.x = cm_x
            self.frame = temp
        }
        get{
            return self.frame.origin.x
        }
    }

}
