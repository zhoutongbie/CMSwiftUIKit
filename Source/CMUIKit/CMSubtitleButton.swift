//
//  CMSubtitleButton.swift
//  YFStore
//
//  Created by Fang on 2016/12/2.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit
import SnapKit

class CMSubtitleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addSubview(primaryLabel)
        addSubview(subtitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        primaryLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(primaryLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
   
    lazy public var primaryLabel:UILabel = {
        let primaryTitle = UILabel()
        return primaryTitle
    }()
    
    lazy public var subtitleLabel:UILabel = {
        let primaryTitle = UILabel()
        return primaryTitle
    }()
}
