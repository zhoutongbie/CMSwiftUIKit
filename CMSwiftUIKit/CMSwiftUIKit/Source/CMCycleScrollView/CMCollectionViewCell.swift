
//
//  SDCollectionViewCell.swift
//  YFStore
//
//  Created by I Mac on 16/12/21.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

class CMCollectionViewCell: UICollectionViewCell {
    
    fileprivate var _title:String = ""
    
    var imageView :UIImageView?
    var titleLabelHeight : CGFloat?
    var hasConfigured : Bool = false
    var titleLabel: UILabel!
    
    var title: String {
        set{
            _title = "   \(newValue)"
            self.titleLabel?.text = _title
        }
        get{
            return _title
        }
    }
    var titleLabelBackgroundColor : UIColor {
        set{
            self.titleLabel.backgroundColor = newValue
        }
        get{
            return self.titleLabel.backgroundColor!
        }
    }
    var titleLabelTextColor : UIColor{
        set{
            self.titleLabel.textColor = newValue
        }
        get{
            return self.titleLabel.textColor
        }
    }
    var titleLabelTextFont : UIFont{
        set{
            self.titleLabel.font = newValue
        }
        get{
            return self.titleLabel.font
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupImageView()
        self.setupTitleLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupImageView() {
        let imageView = UIImageView()
        self.imageView = imageView
        self.addSubview(imageView)
    }
    
    func setupTitleLabel() {
        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        self.titleLabel.isHidden = true
        self.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = self.bounds
        let titleLabelW: CGFloat = self.cm_width
        let titleLabelH: CGFloat = titleLabelHeight!
        let titleLabelX: CGFloat = 0
        let titleLabelY: CGFloat = self.cm_height - titleLabelH
        self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        self.titleLabel.isHidden = !(titleLabel.text != nil)
    }

}
