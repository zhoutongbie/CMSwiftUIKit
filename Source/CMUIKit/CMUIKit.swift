//
//  CMLabel.swift
//  YFStore
//
//  Created by Fang on 2016/12/1.
//  Copyright © 2016年 yfdyf. All rights reserved.
//


import UIKit
import EZSwiftExtensions

class CMUIKit {
    //MARK:自定义topbar
    class func topMenuBar(cotentArray:Array<String>?,
                          fontBtn:CGFloat = 13,
                          textColorBtn:UIColor = UIColor.darkGray,
                          textColorSeledBtn:UIColor = CMDefaultTheme.theme.themeColor,
                          bottomViewColor:UIColor = CMDefaultTheme.theme.themeColor,
                          BGColor:UIColor = UIColor.white) -> CMTopMenuBar{
        let topMenuBar = CMTopMenuBar.init(contentArray: cotentArray!)
        topMenuBar.fontBtn = fontBtn
        topMenuBar.textColorBtn = textColorBtn
        topMenuBar.textColorSeledBtn = textColorSeledBtn
        topMenuBar.bottomViewColor = bottomViewColor
        topMenuBar.backgroundColor = BGColor
        return topMenuBar
    }
    //MARK: UILabel
    class func label(textColor:UIColor,fontSize:CGFloat) -> UILabel {
        return CMUIKit.label(backgroundColor:.clear,textColor:textColor,textAlignment:.left,numberOfLines:1,text:"",fontSize:fontSize)
    }

    class func label(backgroundColor:UIColor = .clear,
                     textColor:UIColor = .darkGray,
                     textAlignment:NSTextAlignment = .left,
                     numberOfLines:Int = 1,
                     text:String,
                     fontSize:CGFloat) -> UILabel {
        let label:UILabel = UILabel()
        label.backgroundColor = backgroundColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    //MARK:UIButton(上下都是文字)
    class func subtitleButton(title:String? = nil,
                        titleColor:UIColor = .darkGray,
                        titleFontSize:CGFloat = 15,
                        titleAlignment:NSTextAlignment = .center,
                        subtitle:String? = nil,
                        subtitleColor:UIColor = .lightGray,
                        subtitleFontSize:CGFloat = 13,
                        subtitleAlignment:NSTextAlignment = .center) -> CMSubtitleButton {
        let button = CMSubtitleButton()
        if let title = title {
            button.primaryLabel.text = title
        }
        button.primaryLabel.textColor = titleColor
        button.primaryLabel.font = UIFont.systemFont(ofSize: titleFontSize)
        button.primaryLabel.textAlignment = titleAlignment

        if let subtitle = subtitle {
            button.subtitleLabel.text = subtitle
        }
        button.subtitleLabel.textColor = subtitleColor
        button.subtitleLabel.font = UIFont.systemFont(ofSize: subtitleFontSize)
        button.subtitleLabel.textAlignment = subtitleAlignment
        return button
    }
    //MARK:UIButton(圆角)
    class func filletButton(title:String? = nil,
                            backgroundColor:UIColor = UIColor.init(r: 245, g: 166, b: 35),
                            font:CGFloat = 15,
                            textColor:UIColor = UIColor.white,
                            masksToBounds:Bool = true,
                            cornerRadius:CGFloat = 17,
                            borderColor:UIColor = UIColor.white
        ) -> UIButton {
        let button = UIButton.init(type: UIButtonType.custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: font)
        button.layer.masksToBounds = masksToBounds
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor.cgColor
        return button
    }
    
    //MARK:分割线
    class func cuttingLine(backgroundColor:UIColor = CMDefaultTheme.theme.defaultBoundaryColor,
                           height:CGFloat = 0.5) -> UIView {
        let line = UIView()
        line.backgroundColor = backgroundColor
        line.size.height = height
        return line
    }
}








