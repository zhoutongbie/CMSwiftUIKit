//
//  CMEvaluationToolView.swift
//  YFStore
//
//  Created by I Mac on 16/12/30.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit


class CMEvaluationToolView: UIView {
    var kSpace : CGFloat = 0               //各个item的间距
    let itemWidth : CGFloat = 18           //item宽度
    let itemHeight : CGFloat = 17          //item高度
    let itemNum : CGFloat = 5              //item的个数
    private var _canClick : Bool = true    //是否支持点击
    private var _starShineCount : Int = 0  //点亮星个数
    private var normalImage: UIImage
    private var selectedImage: UIImage
    
    var canClick : Bool{
        set{
            _canClick = newValue
            item1.isUserInteractionEnabled = _canClick
            item2.isUserInteractionEnabled = _canClick
            item3.isUserInteractionEnabled = _canClick
            item4.isUserInteractionEnabled = _canClick
            item5.isUserInteractionEnabled = _canClick
        }get{
            return _canClick
        }
    }
    var starShineCount : Int{
        set{
            _starShineCount = newValue
            starShineCount(count: _starShineCount)
        }get{
            return _starShineCount
        }
    }
    init(normalImage:UIImage,selectedImage: UIImage) {
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        super.init(frame:CGRect.zero)
        self.backgroundColor = .white
        addSubview(item1)
        addSubview(item2)
        addSubview(item3)
        addSubview(item4)
        addSubview(item5)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        kSpace = (self.frame.size.width - itemWidth * itemNum) / (itemNum - 1)
        item1.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        }
        item2.snp.makeConstraints { (make) in
            make.left.equalTo(item1.snp.right).offset(kSpace)
            make.centerY.equalTo(item1.snp.centerY)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        }
        item3.snp.makeConstraints { (make) in
            make.left.equalTo(item2.snp.right).offset(kSpace)
            make.centerY.equalTo(item1.snp.centerY)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        }
        item4.snp.makeConstraints { (make) in
            make.left.equalTo(item3.snp.right).offset(kSpace)
            make.centerY.equalTo(item1.snp.centerY)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        }
        item5.snp.makeConstraints { (make) in
            make.left.equalTo(item4.snp.right).offset(kSpace)
            make.centerY.equalTo(item1.snp.centerY)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        }
        
    }
    func buttonTap(sender:UIButton) {
        starShineCount(count: sender.tag )
    }
    private func isStarShineItemImage(isStarShine:Bool , item:UIButton){
        item.setImage(isStarShine ? self.selectedImage : self.normalImage, for: .normal)
    }
    private func starShineCount(count: Int) {
        switch count {
        case 0:
            isStarShineItemImage(isStarShine: false, item: item1)
            isStarShineItemImage(isStarShine: false, item: item2)
            isStarShineItemImage(isStarShine: false, item: item3)
            isStarShineItemImage(isStarShine: false, item: item4)
            isStarShineItemImage(isStarShine: false, item: item5)
            break
        case 1:
            isStarShineItemImage(isStarShine: true, item: item1)
            isStarShineItemImage(isStarShine: false, item: item2)
            isStarShineItemImage(isStarShine: false, item: item3)
            isStarShineItemImage(isStarShine: false, item: item4)
            isStarShineItemImage(isStarShine: false, item: item5)
            break
        case 2:
            isStarShineItemImage(isStarShine: true, item: item1)
            isStarShineItemImage(isStarShine: true, item: item2)
            isStarShineItemImage(isStarShine: false, item: item3)
            isStarShineItemImage(isStarShine: false, item: item4)
            isStarShineItemImage(isStarShine: false, item: item5)
            break
        case 3:
            isStarShineItemImage(isStarShine: true, item: item1)
            isStarShineItemImage(isStarShine: true, item: item2)
            isStarShineItemImage(isStarShine: true, item: item3)
            isStarShineItemImage(isStarShine: false, item: item4)
            isStarShineItemImage(isStarShine: false, item: item5)
            break
        case 4:
            isStarShineItemImage(isStarShine: true, item: item1)
            isStarShineItemImage(isStarShine: true, item: item2)
            isStarShineItemImage(isStarShine: true, item: item3)
            isStarShineItemImage(isStarShine: true, item: item4)
            isStarShineItemImage(isStarShine: false, item: item5)
            break
        case 5:
            isStarShineItemImage(isStarShine: true, item: item1)
            isStarShineItemImage(isStarShine: true, item: item2)
            isStarShineItemImage(isStarShine: true, item: item3)
            isStarShineItemImage(isStarShine: true, item: item4)
            isStarShineItemImage(isStarShine: true, item: item5)
            break
        default:
            break
        }
    }
    //MARK:-----属性-----
    lazy var item1: UIButton = {
        let item1 = UIButton(type: .custom)
        item1.setImage(self.normalImage, for: .normal)
        item1.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
        item1.tag = 1
        return item1
    }()
    lazy var item2: UIButton = {
        let item2 = UIButton(type: .custom)
        item2.setImage(self.normalImage, for: .normal)
        item2.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
        item2.tag = 2
        return item2
    }()
    lazy var item3: UIButton = {
        let item3 = UIButton(type: .custom)
        item3.setImage(self.normalImage, for: .normal)
        item3.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
        item3.tag = 3
        return item3
    }()
    lazy var item4: UIButton = {
        let item4 = UIButton(type: .custom)
        item4.setImage(self.normalImage, for: .normal)
        item4.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
        item4.tag = 4
        return item4
    }()
    lazy var item5: UIButton = {
        let item5 = UIButton(type: .custom)
        item5.setImage(self.normalImage, for: .normal)
        item5.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
        item5.tag = 5
        return item5
    }()
}







