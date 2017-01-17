//
//  CMPageControl.swift
//  YFStore
//
//  Created by Fang on 2016/12/20.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

/**
 *  Default number of pages for initialization
 */
fileprivate let kDefaultNumberOfPages = 0

/**
 *  Default current page for initialization
 */
fileprivate let kDefaultCurrentPage = 0

/**
 *  Default setting for hide for single page feature. For initialization
 */
fileprivate let kDefaultHideForSinglePage = false

/**
 *  Default setting for shouldResizeFromCenter. For initialiation
 */
fileprivate let kDefaultShouldResizeFromCenter = true

/**
 *  Default spacing between dots
 */
fileprivate let kDefaultSpacingBetweenDots = 8

/**
 *  Default dot size
 */
fileprivate let kDefaultDotSize =  CGSize(width: 8, height: 8)

protocol CMPageControlDelegate {
    
    func pageControl(_ pageControl:CMPageControl, didSelectPageAt index:Int)
}

class CMPageControl: UIControl {
    
    var delegate:CMPageControlDelegate?
    
    fileprivate var _dotViewClass:AnyClass = CMAnimatedDotView.self
    
    fileprivate var _dotImage:UIImage?
    
    fileprivate var _currentDotImage:UIImage?
    
    fileprivate var _dotSize:CGSize?
    
    var currentDotSize:CGSize?
    
    var dotColor:UIColor?

    fileprivate var _spacingBetweenDots:Int = kDefaultSpacingBetweenDots

    fileprivate var _numberOfPages:Int = kDefaultNumberOfPages
    
    fileprivate var _currentPage:Int = kDefaultCurrentPage
    
    var hidesForSinglePage:Bool = kDefaultHideForSinglePage
    
    fileprivate var shouldResizeFromCenter:Bool = kDefaultShouldResizeFromCenter
    
    lazy fileprivate var dots: NSMutableArray = {
        let dots = NSMutableArray()
        return dots
    }()

    var numberOfPages : Int {
        set{
            _numberOfPages = newValue
            resetDotViews()
        }
        get{
            return _numberOfPages
        }
    }
    var spacingBetweenDots :Int {
        set{
            _spacingBetweenDots = newValue
            resetDotViews()
        }
        get{
            return _spacingBetweenDots
        }
    }
    var currentPage : Int{
        set{
            if self.numberOfPages == 0 || newValue == _currentPage {
                _currentPage = newValue
                return
            }
            self.changeActivity(false, index: _currentPage)
             _currentPage = newValue
            self.changeActivity(true, index: _currentPage)
        }
        get{
            return _currentPage
        }
    }
    var dotImage : UIImage? {
        set{
            _dotImage = newValue
            resetDotViews()
            self.dotViewClass = nil
        }
        get{
            return _dotImage   
        }
    }
    var currentDotImage : UIImage?{
        set{
            _currentDotImage = newValue
            resetDotViews()
            self.dotViewClass = nil
        }
        get{
            return _currentDotImage!
        }
    }
    var dotViewClass : AnyClass? {
        set{
            _dotViewClass = newValue!
            self.dotSize = CGSize.zero
            resetDotViews()
        }
        get{
            return  _dotViewClass
        }
    }
    var dotSize : CGSize{
        set{
            _dotSize = newValue
        }
        get{
            if (self.dotImage != nil) && (_dotSize?.equalTo(CGSize.zero))! {
                _dotSize = self.dotImage?.size
            }else if _dotSize == nil {
                _dotSize = kDefaultDotSize
                return _dotSize!
            }
            return _dotSize!
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:Touch event
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch: AnyObject in touches {
            let t:UITouch = touch as! UITouch
            if t.view != self {
                let index = self.dots.index(of: t.view!)
                delegate?.pageControl(self, didSelectPageAt: index)
            }
        }
    }
    //MARK: Layout

    /**
     *  Resizes and moves the receiver view so it just encloses its subviews.
     */
    override func sizeToFit() {
        updateFrame(true)
    }
    func sizeForNumberOfPages(pageCount:Int) -> CGSize {
        return CGSize(width: (self.dotSize.width + CGFloat(self.spacingBetweenDots)) * CGFloat(pageCount) - CGFloat(self.spacingBetweenDots), height: self.dotSize.height)
    }
    /**
     *
     */
    func updateDots() {
        if numberOfPages == 0 {
            return
        }
        for i in 0..<self.numberOfPages {
            var dot: UIView?
            if i < self.dots.count {
                dot = self.dots[i] as? UIView
            }
            else {
                dot = self.generateDotView()
            }
            self.updateDotFrame(dot!, index: i)
        }
        self.changeActivity(true, index: self.currentPage)
        self.hideForSinglePage()
    }
    
    
    /**
     *  Update frame control to fit current number of pages. It will apply required size if authorize and required.
     *
     *  @param overrideExistingFrame BOOL to allow frame to be overriden. Meaning the required size will be apply no mattter what.
     */
    func updateFrame(_ overrideExistingFrame: Bool) {
        let center = self.center
        let requiredSize = self.sizeForNumberOfPages(pageCount: self.numberOfPages)
        if overrideExistingFrame || ((self.frame.width < requiredSize.width || self.frame.height < requiredSize.height) && !overrideExistingFrame) {
            self.frame = CGRect(x: CGFloat(self.frame.minX), y: CGFloat(self.frame.minY), width: CGFloat(requiredSize.width), height: CGFloat(requiredSize.height))
            if self.shouldResizeFromCenter {
                self.center = center
            }
        }
        self.resetDotViews()
    }
    
    
    /**
     *  Update the frame of a specific dot at a specific index
     *
     *  @param dot   Dot view
     *  @param index Page index of dot
     */
    func updateDotFrame(_ dot: UIView, index: Int) {
        let x: CGFloat = (self.dotSize.width + CGFloat(self.spacingBetweenDots)) * CGFloat(index) + ((self.frame.width - self.sizeForNumberOfPages(pageCount:numberOfPages).width) / 2)
        
        let y: CGFloat = (self.frame.height - self.dotSize.height) / 2
        dot.frame = CGRect(x: x, y: y, width: self.dotSize.width, height: self.dotSize.height)
    }
    
//MARK: - Utils
    /**
     *  Generate a dot view and add it to the collection
     *
     *  @return The UIView object representing a dot
     */
    func generateDotView() -> UIView? {
        var dotView :  UIView?
        if self.dotViewClass != nil {
            
            if self.dotViewClass is CMAnimatedDotView.Type{
                dotView = CMAnimatedDotView(frame: CGRect(x: 0, y: 0, width: self.dotSize.width, height: self.dotSize.height))
            }else{
                dotView = UIView(frame: CGRect(x: 0, y: 0, width: self.dotSize.width, height: self.dotSize.height))

            }
            if (dotView! is CMAnimatedDotView) && (self.dotColor != nil) {
                (dotView as! CMAnimatedDotView).dotColor = self.dotColor
            }
        }
        else {
            dotView = UIImageView(image: self.dotImage)
            dotView!.frame = CGRect(x: 0, y: 0, width:self.dotSize.width, height:self.dotSize.height)
        }
        if dotView != nil {
            self.addSubview(dotView!)
            self.dots.add(dotView!)
        }
        dotView!.isUserInteractionEnabled = true
        return dotView
    }
    /**
     *  Change activity state of a dot view. Current/not currrent.
     *
     *  @param active Active state to apply
     *  @param index  Index of dot for state update
     */
    func changeActivity(_ active: Bool,index: Int) {
        if self.dotViewClass != nil {
            let abstractDotView = self.dots[index] as? CMAbstractDotView
            abstractDotView?.changeActivityState(active: active)
        }else if (self.dotImage != nil) && (self.currentDotImage != nil) {
            let dotView = (self.dots[index] as! UIImageView)
            dotView.image! = ((active) ? self.currentDotImage : self.dotImage)!
            dotView.size = (active) ? self.currentDotSize! : kDefaultDotSize
        }
        
    }
    
    func resetDotViews() {
        for dotView in self.dots {
            ((dotView as AnyObject) as AnyObject).removeFromSuperview()
        }
        self.dots.removeAllObjects()
        self.updateDots()
    }
    
    
    func hideForSinglePage() {
        if self.dots.count == 1 && self.hidesForSinglePage {
            self.isHidden = true
        }
        else {
            self.isHidden = false
        }
    }
    
    //MARK: - Getters
    //MARK: - Setters
    
}
