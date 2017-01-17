//
//  CMCyclingLabel.swift
//  YFStore
//
//  Created by I Mac on 17/1/11.
//  Copyright © 2017年 yfdyf. All rights reserved.
//

import UIKit

/*
class CMCyclingLabelTransitionEffect {
    var Custom :      UInt32 { return 0 }
    var FadeIn :      UInt32 { return 1 << 0 }
    var FadeOut :     UInt32 { return 1 << 1 }
    var CrossFade :   UInt32 { return FadeIn | FadeOut }
    var ZoomIn  :     UInt32 { return 1<<2 }
    var ZoomOut  :    UInt32 { return 1<<3 }
    var ScaleFadeOut: UInt32 { return FadeIn | FadeOut | ZoomOut }
    var ScaleFadeIn : UInt32 { return FadeIn | FadeOut | ZoomIn}
    var ScrollUp  :   UInt32 { return 1<<4 }
    var ScrollDown :  UInt32 { return 1<<5 }
    var Default :     UInt32 { return 1<<2 }
}
 */

enum CMCyclingLabelTransitionEffect : Int {
    case Custom
    case FadeIn
    case FadeOut
    case CrossFade
    case ZoomIn
    case ZoomOut
    case ScaleFadeOut
    case ScaleFadeIn
    case ScrollUp
    case ScrollDown
    case Default
}

//MARK:Custom types
var CMCyclingLabelPreTransitionBlock: ((_ labelToEnter: UILabel) -> Void)? = nil
var CMCyclingLabelTransitionBlock: ((_ labelToExit: UILabel, _ labelToEnter: UILabel) -> Void)? = nil

class CMCyclingLabel: UIView {

    fileprivate let kBBCyclingLabelDefaultTransitionDuration = 0.3
    fileprivate var _currentLabelIndex : Int = 0
    fileprivate var _labels : Array<UILabel>!
    fileprivate var _currentLabel : UILabel?
    
    var _transitionEffect : CMCyclingLabelTransitionEffect = .Default
    var _text : String = " "
    var _font : UIFont = UIFont.systemFont(ofSize: 17)
    var _textColor : UIColor = .clear
    var _shadowColor : UIColor = .clear
    var _shadowOffset : CGSize = CGSize(width: 50, height: 50)
    var _textAlignment : NSTextAlignment = .center
    var _lineBreakMode : NSLineBreakMode?
    var _numberOfLines : Int = 1
    var _adjustsFontSizeToFitWidth : Bool = true
    var _minimumScaleFactor : CGFloat = 0
    var _baselineAdjustment : UIBaselineAdjustment?
    
    //MARK:Properties
    var transitionEffect : CMCyclingLabelTransitionEffect{
        set{
            _transitionEffect = newValue
            prepareTransitionBlocks()
        }get{
            return _transitionEffect
        }
    }
    var text : String{
        set{
            _text = newValue
            _currentLabel?.text = _text
            setText(text, animated:true)
        }
        get{
            return _text
        }
    }
    var font : UIFont{
        set{
            _font = newValue
            _currentLabel?.font = _font
            for label: UILabel in _labels! {
                label.font = _font
            }
        }
        get{
            return _font
        }
    }
    var textColor : UIColor{
        set{
            _textColor = newValue
            _currentLabel?.textColor = _textColor
            for label: UILabel in _labels! {
                label.textColor = _textColor
            }
        }
        get{
            return _textColor
        }
    }
    var shadowColor : UIColor{
        set{
            _shadowColor = newValue
            _currentLabel?.shadowColor = _shadowColor
            for label: UILabel in _labels! {
                label.shadowColor = _shadowColor
            }
        }
        get{
            return _shadowColor
        }
    }
    var shadowOffset : CGSize{
        set{
            _shadowOffset = newValue
            _currentLabel?.shadowOffset = _shadowOffset
            for label: UILabel in _labels! {
                label.shadowOffset = _shadowOffset
            }
        }
        get{
            return _shadowOffset
        }
    }
    var textAlignment : NSTextAlignment{
        set{
            _textAlignment = newValue
            _currentLabel?.textAlignment = _textAlignment
            for label: UILabel in _labels! {
                label.textAlignment = _textAlignment
            }
        }
        get{
            return _textAlignment
        }
    }
    var lineBreakMode : NSLineBreakMode{
        set{
            _lineBreakMode = newValue
            _currentLabel?.lineBreakMode = _lineBreakMode!
            for label: UILabel in _labels! {
                label.lineBreakMode = _lineBreakMode!
            }
        }
        get{
            return _lineBreakMode!
        }
    }
    var numberOfLines : Int{
        set{
            _numberOfLines = newValue
            _currentLabel?.numberOfLines = _numberOfLines
            for label: UILabel in _labels! {
                label.numberOfLines = _numberOfLines
            }
        }
        get{
            return _numberOfLines
        }
    }
    var adjustsFontSizeToFitWidth : Bool{
        set{
            _adjustsFontSizeToFitWidth = newValue
            _currentLabel?.adjustsFontSizeToFitWidth = _adjustsFontSizeToFitWidth
            for label: UILabel in _labels! {
                label.adjustsFontSizeToFitWidth = _adjustsFontSizeToFitWidth
            }
        }
        get{
            return _adjustsFontSizeToFitWidth
        }
    }
    var minimumScaleFactor : CGFloat{
        set{
            _minimumScaleFactor = newValue
            _currentLabel?.minimumScaleFactor = _minimumScaleFactor
            for label: UILabel in _labels! {
                label.minimumScaleFactor = _minimumScaleFactor
            }
        }
        get{
            return _minimumScaleFactor
        }
    }
    var baselineAdjustment : UIBaselineAdjustment{
        set{
            _baselineAdjustment = newValue
            _currentLabel?.baselineAdjustment = _baselineAdjustment!
            for label: UILabel in _labels! {
                label.baselineAdjustment = _baselineAdjustment!
            }
        }
        get{
            return _baselineAdjustment!
        }
    }
    var transitionDuration : TimeInterval = 0.3
    var preTransitionBlock = CMCyclingLabelPreTransitionBlock
    var transitionBlock = CMCyclingLabelTransitionBlock

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWith(effect: .Default, andDuration: kBBCyclingLabelDefaultTransitionDuration)
    }
    init(frame : CGRect,andTransitionType transitionEffect:CMCyclingLabelTransitionEffect) {
         super.init(frame: frame)
        setupWith(effect: transitionEffect, andDuration: kBBCyclingLabelDefaultTransitionDuration)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:Interface
    func setText(_ text: String, animated: Bool) {
        let nextLabelIndex = self.nextLabelIndex()
        let nextLabel = _labels[nextLabelIndex]
        let previousLabel = _currentLabel
        nextLabel.text = text
        resetLabel(label: nextLabel)
        _currentLabel = nextLabel
        _currentLabelIndex = nextLabelIndex
        if preTransitionBlock != nil {
            preTransitionBlock!(nextLabel)
        }
        else {
            nextLabel.alpha = 0
        }
        nextLabel.isHidden = false
        let changeBlock: (() -> Void)? = {() -> Void in
            if self.transitionBlock != nil {
                self.transitionBlock!(previousLabel!, nextLabel)
            }
            else {
                previousLabel?.alpha = 0
                nextLabel.alpha = 1
            }
        }
        let completionBlock: ((_: Bool) -> Void)? = {(_ finished: Bool) -> Void in
            if finished {
                previousLabel?.isHidden = true
            }
        }
        if animated {
            UIView.animate(withDuration: transitionDuration, animations: changeBlock!, completion: completionBlock)
        }
        else {
            changeBlock!()
            completionBlock!(true)
        }
    
    }
    
    //MARK:Private helpers
    func setupWith(effect: CMCyclingLabelTransitionEffect, andDuration duration: TimeInterval) {
        let size = 2
        var labels = [UILabel]()
        for _ in 0..<size {
            let label = UILabel(frame: self.bounds)
            self.addSubview(label)
            label.backgroundColor = UIColor.clear
            label.isHidden = true
            label.numberOfLines = 0
            labels.append(label)
        }
        _currentLabelIndex = 0
        _currentLabel = labels[0]
        _labels = labels
        _currentLabel?.isHidden = false
        self.transitionEffect = effect
        self.transitionDuration = duration
    }
    func prepareTransitionBlocks() {
        if self.transitionEffect == .Custom {
            return
        }
        let type = transitionEffect
        let currentHeight : CGFloat = self.bounds.size.height
        self.preTransitionBlock = {(_ labelToEnter: UILabel) -> Void in
            if type == .FadeIn {
                labelToEnter.alpha = 0
            }
            if type == .ZoomIn {
                labelToEnter.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            if type == .ScrollUp || type == .ScrollDown {
                var frame = labelToEnter.frame
                if type == .ScrollUp {
                    frame.origin.y = currentHeight
                }
                if type == .ScrollDown {
                    frame.origin.y = 0 - frame.size.height
                }
                labelToEnter.frame = frame
            }
        }
        self.transitionBlock = {(_ labelToExit: UILabel, _ labelToEnter: UILabel) -> Void in
            if type == .FadeIn {
                labelToEnter.alpha = 1
            }
            if type == .FadeOut {
                labelToExit.alpha = 0
            }
            if type == .ZoomOut {
                labelToExit.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            if type == .ZoomIn {
                labelToEnter.transform = CGAffineTransform.identity
            }
            if type == .ScrollUp ||  type == .ScrollDown {
                var frame = labelToExit.frame
                var enterFrame = labelToEnter.frame
                if type == .ScrollUp {
                    frame.origin.y = 0 - frame.size.height
                    enterFrame.origin.y = CGFloat(roundf(Float((currentHeight / 2) - (enterFrame.size.height / 2))))
                }
                if type == .ScrollDown {
                    frame.origin.y = currentHeight;
                    enterFrame.origin.y = CGFloat(roundf(Float((currentHeight / 2) - (enterFrame.size.height / 2))))
                }
                labelToExit.frame = frame
                labelToEnter.frame = enterFrame
            }
        }
    }
    
    func  nextLabelIndex() -> Int {
        return (_currentLabelIndex + 1) % (_labels?.count)!
    }
    func resetLabel(label : UILabel) {
        label.alpha = 1
        label.transform = CGAffineTransform.identity
        label.frame = self.bounds
    }
}
