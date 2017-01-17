
//
//  CustomTopTabBar.swift
//  YFStore
//
//  Created by I Mac on 16/12/8.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit
import RxSwift
import EZSwiftExtensions

class CMTopMenuBar: UIView {
    var lastBtn = UIButton()
    var fontBtn : CGFloat?
    var textColorBtn : UIColor?
    var textColorSeledBtn : UIColor?
    var bottomViewColor : UIColor?
    
    var selectedIndex : Int{
        didSet{
            self.buttonClick.onNext(selectedIndex)
        }
    }
    
    var array = Array<String>.init()
    private let btnW : CGFloat
    public let buttonClick:PublishSubject<Int> = PublishSubject()
    
    init(contentArray:Array<String>){
        selectedIndex = 0
        self.array = contentArray
        btnW = ez.screenWidth / CGFloat(array.count)
        super.init(frame:CGRect.zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createTopButton()
        addSubview(bottomLab)
        addSubview(lineView)
        
        bottomLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-1)
            make.width.equalTo(btnW)
            make.height.equalTo(3)
            make.left.equalTo(self).offset(CGFloat(selectedIndex)*btnW)
        }
        lineView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func createTopButton() {
        for i in 0..<array.count {
            let button = UIButton(type: UIButtonType.custom)
            button.frame = CGRect(x: btnW * CGFloat(i), y: 0, width: btnW, height: self.frame.size.height)
            button.setTitle(array[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontBtn!)
            button.setTitleColor(textColorBtn!, for: .normal)
            button.setTitleColor(textColorSeledBtn!, for: .selected)
            button.tag = i+1
            button.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
            if i==selectedIndex {
                lastBtn = button
                button.isSelected = true;
            }
            addSubview(button)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK:----属性----
    lazy var lineView : UIView = {
       let lineView = UIView()
        lineView.backgroundColor = CMDefaultTheme.theme.defaultBoundaryColor
        return lineView
    }()
    lazy var bottomLab : UILabel = {
        let bottomLab = UILabel()
        bottomLab.backgroundColor = self.bottomViewColor!
        return bottomLab
    }()
}
extension CMTopMenuBar{
    func buttonTap(sender:UIButton) {
        lastBtn.isSelected = false
        sender.isSelected = true
        lastBtn = sender
        self.buttonClick.onNext(sender.tag-1)
        UIView.animate(withDuration: 0.1, animations: {
            self.bottomLab.center = CGPoint(x:sender.center.x, y:sender.center.y+sender.size.height/2-2.5);
        }, completion:{ _ in
            
        })
    }
}
