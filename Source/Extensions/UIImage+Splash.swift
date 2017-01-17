//
//  UIImage+Splash.swift
//  SwiftTemple
//
//  Created by Fang on 2016/11/4.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    //MARK:获取与当前设备匹配的启动图片
    public class func launchImage() -> UIImage {
        var lauchImage      : UIImage!
        var viewOrientation : String!
        let viewSize        = UIScreen.main.bounds.size
        let orientation     = UIApplication.shared.statusBarOrientation
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            viewOrientation = "Landscape"
        } else {
            
            viewOrientation = "Portrait"
        }
        
        let imagesInfoArray = Bundle.main.infoDictionary!["UILaunchImages"]
        for dict : Dictionary <String, String> in imagesInfoArray as! Array {
            let imageSize = CGSizeFromString(dict["UILaunchImageSize"]!)
            if imageSize.equalTo(viewSize) && viewOrientation == dict["UILaunchImageOrientation"]! as String {
                
                lauchImage = UIImage(named: dict["UILaunchImageName"]!)
            }
        }
        
        return lauchImage
    }
}
