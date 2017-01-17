//
//  CMDefaultTheme.swift
//  CMSwiftUIKit
//
//  Created by Fang on 2017/1/17.
//  Copyright © 2017年 yfdyf. All rights reserved.
//

import Foundation

class CMDefaultTheme {
    static let theme = CMDefaultTheme() // Singleton
    
    /// 主题颜色
    private var _themeColor = UIColor.init(r: 0, g: 197, b: 153)
    var themeColor:UIColor{
        set { _themeColor = newValue }
        get { return _themeColor }
    }
    
    /// 主文字颜色
    private var _defaultTextColor = UIColor.init(r: 51, g: 51, b: 51)
    var defaultTextColor:UIColor{
        set { _defaultTextColor = newValue }
        get { return _defaultTextColor }
    }
    
    /// 视图默认背景
    private var _defaultBackgroundColor = UIColor.init(r: 240, g: 240, b: 240)
    var defaultBackgroundColor:UIColor{
        set { _defaultBackgroundColor = newValue }
        get { return _defaultBackgroundColor }
    }

    /// 标题颜色
    private var _defaultTitleColor = UIColor.init(r: 72, g: 72, b: 72)
    var defaultTitleColor:UIColor{
        set { _defaultTitleColor = newValue }
        get { return _defaultTitleColor }
    }

    /// 导航栏颜色
    private var _defaultNavbarColor = UIColor.init(r: 72, g: 72, b: 72)
    var defaultNavbarColor:UIColor{
        set { _defaultNavbarColor = newValue }
        get { return _defaultNavbarColor }
    }

    /// 分割线
    private var _defaultBoundaryColor = UIColor.init(r: 221, g: 221, b: 221)
    var defaultBoundaryColor:UIColor{
        set { _defaultBoundaryColor = newValue }
        get { return _defaultBoundaryColor }
    }


}
