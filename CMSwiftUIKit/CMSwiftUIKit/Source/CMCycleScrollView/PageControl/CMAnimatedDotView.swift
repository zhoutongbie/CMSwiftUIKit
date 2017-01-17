//
//  CMAnimatedDotView.swift
//  YFStore
//
//  Created by Fang on 2016/12/20.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

class CMAnimatedDotView: CMAbstractDotView {

    let kAnimateDuration = 1
    
    
    var dotColor: UIColor? {
        didSet {
            self.layer.borderColor = dotColor?.cgColor
        }
    }
    
    override init() {
        super.init()
        initialization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialization()  {
        self.dotColor = .white
        self.backgroundColor = .clear
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor  = UIColor.white.cgColor
        self.layer.borderWidth  = 2
    }
    
    override func changeActivityState(active: Bool) {
        if active{
            self.animateToActiveState()
        }else{
            self.animateToDeactiveState()
        }
    }
    
    func animateToActiveState()  {
        UIView.animate(withDuration: TimeInterval(kAnimateDuration), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -20, options: .curveLinear, animations: { 
            self.backgroundColor = self.dotColor
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: nil)
    }
    
    func animateToDeactiveState()  {
        UIView.animate(withDuration: TimeInterval(kAnimateDuration), delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.backgroundColor = .clear
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }

}
