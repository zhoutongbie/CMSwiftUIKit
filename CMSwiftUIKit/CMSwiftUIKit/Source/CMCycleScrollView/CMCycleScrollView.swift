
//
//  SDCycleScrollView.swift
//  YFStore
//
//  Created by I Mac on 16/12/22.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit
import Kingfisher

enum CMCycleScrollViewPageContolAliment : Int {
    case right
    case center
}
enum CMCycleScrollViewPageContolStyle : Int {
    case classic    // 系统自带经典样式
    case animated   // 动画效果pagecontrol
    case none       // 不显示pagecontrol
}

protocol CMCycleScrollViewDelegate {
    /** 点击图片回调 */
    func cycleScrollView(_ cycleScrollView: CMCycleScrollView, didSelectItemAt index: Int)
    /** 图片滚动回调 */
    func cycleScrollView(_ cycleScrollView: CMCycleScrollView, didScrollTo index: Int)
}

class CMCycleScrollView: UIView {
    
    fileprivate var flowLayout : UICollectionViewFlowLayout?
    fileprivate var _imageURLsGroup : Array<URL>?
    fileprivate var timer : Timer?
    fileprivate var totalItemsCount : Int?
    fileprivate var pageControl : UIControl?
    fileprivate var backgroundImageView : UIImageView?  // 当imageURLs为空时的背景图
    fileprivate var networkFailedRetryCount : Int?
    fileprivate let ID = "cycleCell"
    
    var delegate:CMCycleScrollViewDelegate?
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>>>>>  数据源接口
    /** 本地图片数组 */
    var _localizationImageNamesGroup : Array<String>?
    
    /** 网络图片 url string 数组 */
    var _imageURLStringsGroup : Array<Any>?
    
    /** 每张图片对应要显示的文字数组 */
    var titlesGroup : Array<String>?
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>>>>  滚动控制接口
    /** 自动滚动间隔时间,默认2s */
    var _autoScrollTimeInterval : CGFloat = 2.0
    
    /** 是否无限循环,默认Yes */
    var infiniteLoop : Bool = true
    
    /** 是否自动滚动,默认Yes */
    var _autoScroll : Bool = true
    
    /** block监听点击方式 */
    typealias ClickItemOperationBlock = (_ currentIndex:Int)->Void
    
    var didClickItemBlock:ClickItemOperationBlock?
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  自定义样式接口
    
    /** 轮播图片的ContentMode */
    var bannerImageViewContentMode : UIViewContentMode = .scaleToFill
    
    /** 占位图，用于网络未加载到图片时 */
    var _placeholderImage:UIImage?
 
    /** 是否显示分页控件 */
    var _showPageControl : Bool = true
    
    /** 是否在只有一张图时隐藏pagecontrol，默认为YES */
    var hidesForSinglePage : Bool = true
    
    /** pagecontrol 样式，默认为动画样式 */
    var _pageControlStyle : CMCycleScrollViewPageContolStyle = .classic
    
    /** 分页控件位置 */
    var pageControlAliment : CMCycleScrollViewPageContolAliment = .center
    
    /** 分页控件小圆标大小 */
    var _pageControlDotSize : CGSize = CGSize(width: 10, height: 10)
    
    /** 当前分页控件小圆标颜色 */
    var _currentPageDotColor : UIColor = UIColor.white
    
    /** 其他分页控件小圆标颜色 */
    var _pageDotColor : UIColor = .lightGray
    
    /** 当前分页控件小圆标图片 */
    var _currentPageDotImage : UIImage?
    
    /** 其他分页控件小圆标图片 */
    var _pageDotImage : UIImage?
    
    /** 轮播文字label字体颜色 */
    var titleLabelTextColor : UIColor = .white
    
    /** 轮播文字label字体大小 */
    var titleLabelTextFont : UIFont = UIFont.systemFont(ofSize: 14)
    
    /** 轮播文字label背景颜色 */
    var titleLabelBackgroundColor : UIColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.5)
    
    /** 轮播文字label高度 */
    var titleLabelHeight : CGFloat = 30.0

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.lightGray
         self.addSubview(mainView)
        mainView.register(CMCollectionViewCell.self, forCellWithReuseIdentifier: ID)
    }
    override func awakeFromNib() {
    }
    public class func cycleScrollView(withFrame frame: CGRect, imageNamesGroup: [String]) -> CMCycleScrollView {
        let cycleScrollView = CMCycleScrollView.init(frame: frame)
        cycleScrollView.localizationImageNamesGroup = imageNamesGroup
        return cycleScrollView
    }
    public class func cycleScrollView(withFrame frame: CGRect, imageURLStringsGroup imageURLsGroup: [Any]) -> CMCycleScrollView {
        let cycleScrollView = CMCycleScrollView.init(frame: frame)
        cycleScrollView.imageURLStringsGroup = [Any](arrayLiteral: imageURLsGroup)
        return cycleScrollView
    }
    public class func cycleScrollView(withFrame frame: CGRect, delegate: CMCycleScrollViewDelegate, placeholderImage: UIImage) -> CMCycleScrollView {
        let cycleScrollView = CMCycleScrollView.init(frame: frame)
        cycleScrollView.delegate = delegate
        cycleScrollView.placeholderImage = placeholderImage
        return cycleScrollView
    }
    // 设置显示图片的collectionView
    lazy var mainView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.flowLayout = flowLayout
        let mainView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsHorizontalScrollIndicator = false
        mainView.showsVerticalScrollIndicator = false
        mainView.dataSource = self
        mainView.delegate = self
        return mainView
    }()
    //MARK: ----setter----
    override var frame:CGRect{
        didSet {
            let newFrame = frame
            self.flowLayout?.itemSize = self.frame.size
            super.frame = newFrame
        }
    }
    var placeholderImage : UIImage{
        set{
            _placeholderImage = newValue
            if self.backgroundImageView == nil {
                let bgImageView = UIImageView()
                self.insertSubview(bgImageView, belowSubview: self.mainView)
                self.backgroundImageView = bgImageView
            }else{
                self.backgroundImageView?.image = _placeholderImage
            }
        }
        get{
            return _placeholderImage!
        }
    }
    var pageControlDotSize : CGSize{
        set{
            _pageControlDotSize = newValue
            self.setupPageControl()
            if self.pageControl is CMPageControl {
                let page = self.pageControl as! CMPageControl
                page.dotSize = _pageControlDotSize
            }
        }
        get{
            return _pageControlDotSize
        }
    }
    var showPageControl : Bool{
        set{
            _showPageControl = newValue
            self.pageControl?.isHidden = _showPageControl
        }
        get{
            return  _showPageControl
        }
    }
    var currentPageDotColor: UIColor {
        set{
            _currentPageDotColor = newValue
            if self.pageControl is CMPageControl {
                let page = self.pageControl as! CMPageControl
                page.dotColor = _currentPageDotColor
            }else {
                let page = self.pageControl as? UIPageControl
                page?.currentPageIndicatorTintColor = _currentPageDotColor
            }
        }
        get{
            return _currentPageDotColor
        }
    }
    var pageDotColor: UIColor{
        set{
            _pageDotColor = newValue
        }
        get{
            return _pageDotColor
        }
    }
    var currentPageDotImage: UIImage{
        set{
            _currentPageDotImage = newValue
            self.setCustomPageControlDotImage(_currentPageDotImage!, isCurrentPageDot: true)
        }
        get{
            return _currentPageDotImage!
        }
    }
    var pageDotImage : UIImage{
        set{
            _pageDotImage = newValue
            self.setCustomPageControlDotImage(_pageDotImage!, isCurrentPageDot: true)
        }
        get{
            return _pageDotImage!
        }
    }
    func setCustomPageControlDotImage(_ image: UIImage, isCurrentPageDot: Bool) {
        if (self.pageControl is CMPageControl) {
            let page = self.pageControl as! CMPageControl
            if isCurrentPageDot {
                page.currentDotImage = image
            }
            else {
                page.dotImage = image
            }
        }
        else {
            let page = (self.pageControl as! UIPageControl)
            if isCurrentPageDot {
                page.setValue(image, forKey: "_currentPageImage")
            }
            else {
                page.setValue(image, forKey: "_pageImage")
            }
        }
    }
    var autoScroll: Bool{
        set{
            _autoScroll = newValue
            timer?.invalidate()
            timer = nil;
            if _autoScroll {
                self.setupTimer()
            }
        }
        get{
            return _autoScroll
        }
    }
    var autoScrollTimeInterval : CGFloat{
        set{
            _autoScrollTimeInterval = newValue
            self.autoScroll = _autoScroll
        }
        get{
            return _autoScrollTimeInterval
        }
    }
    var pageControlStyle: CMCycleScrollViewPageContolStyle{
        set{
            _pageControlStyle = newValue
            setupPageControl()
        }
        get{
            return _pageControlStyle
        }
    }
    var imageURLsGroup : Array<URL>?{
        set{
            _imageURLsGroup = newValue
            self.totalItemsCount = self.infiniteLoop ? (_imageURLsGroup?.count)!*100 : (_imageURLsGroup?.count)!
            if (_imageURLsGroup?.count != 1) {
                self.mainView.isScrollEnabled = true
                self.autoScroll = _autoScroll
            } else {
                self.mainView.isScrollEnabled = false
            }
            setupPageControl()
            self.mainView.reloadData()
        }
        get{
            return _imageURLsGroup!
        }
    }
    var imageURLStringsGroup: Array<Any>{
        set{
            _imageURLStringsGroup = newValue
            self.backgroundImageView?.isHidden = _imageURLStringsGroup!.count > 0 ? true : false
            var temp = [URL]()
            for (_,obj) in (_imageURLStringsGroup?.enumerated())!{
                var url:URL?
                if obj is String.Type{
                    url = URL(string:obj as! String)
                }else if obj is URL.Type{
                    url = obj as?URL
                }
                if let url  = url {
                    temp.append(url)
                }
            }
            self.imageURLsGroup = temp
        }
        get{
            return _imageURLStringsGroup!
        }
    }
    var localizationImageNamesGroup : Array<String>{
        set{
            _localizationImageNamesGroup = newValue
            var temp = [URL]()
            for (_,obj) in (_localizationImageNamesGroup?.enumerated())!{
                var url : URL?
            url = Bundle.main.url(forResource: obj , withExtension: nil)
            if (url != nil) {
                    temp.append(url!)
                }
            }
            self.imageURLsGroup = temp
        }
        get{
            return _localizationImageNamesGroup!
        }
    }
    //MARK: ----properties---
    
    func setupPageControl() {
        if (self.pageControl != nil) {    // 重新加载数据时调整
            self.pageControl?.removeFromSuperview()
        }
        if (self.imageURLsGroup?.count)! <= 1 && self.hidesForSinglePage {
            return
        }
        switch self.pageControlStyle {
        case .animated:
            let page = CMPageControl()
            page.numberOfPages = (self.imageURLsGroup?.count)!
            page.dotColor = self.currentPageDotColor
            page.isUserInteractionEnabled = false
            self.addSubview(page)
            self.pageControl = page
            
        case .classic:
            let pageControl = UIPageControl()
            pageControl.numberOfPages = (self.imageURLsGroup?.count)! == 0 ? 0 : (self.imageURLsGroup?.count)!
            pageControl.pageIndicatorTintColor = self.pageDotColor
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor
            pageControl.isUserInteractionEnabled = false
            self.addSubview(pageControl)
            self.pageControl = pageControl
            
        default:
            break
        }
    }
    func automaticScroll() {
        if 0 == totalItemsCount {
            return
        }
        let currentIndex = mainView.contentOffset.x / (flowLayout?.itemSize.width)!
        var targetIndex = currentIndex + 1
        if Int(targetIndex) == totalItemsCount {
            if self.infiniteLoop {
                targetIndex = CGFloat(totalItemsCount!) * 0.5
            }
            else {
                return
            }
            mainView.scrollToItem(at: IndexPath(item: Int(targetIndex), section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0) , animated: false)
        }
        mainView.scrollToItem(at: IndexPath(item: Int(targetIndex), section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0) , animated: true)
    }
    func setupTimer() {
        let timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.autoScrollTimeInterval), target: self, selector: #selector(self.automaticScroll), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
   func clearCache(){
        self.clearCache()
    }
    //MARK:  -----life circles-----
    override func layoutSubviews(){
        super.layoutSubviews()
        self.flowLayout?.itemSize = self.frame.size
        self.mainView.frame = self.bounds
        if mainView.contentOffset.x == 0 && (totalItemsCount != nil) {
            var targetIndex : CGFloat = 0
            if self.infiniteLoop {
                targetIndex = CGFloat(totalItemsCount!) * 0.5
            }
            else {
                targetIndex = 0
            }
            mainView.scrollToItem(at: IndexPath(item: Int(targetIndex), section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0) , animated: false)
        }
        var size = CGSize.zero
        if (self.pageControl is CMPageControl) {
            let pageControl = (self.pageControl as! CMPageControl)
            size = pageControl.sizeForNumberOfPages(pageCount: (self.imageURLsGroup?.count)!)
        }else {
            size = CGSize(width: CGFloat((self.imageURLsGroup?.count)!) * self.pageControlDotSize.width * 1.2, height:self.pageControlDotSize.height)
        }
        var x: CGFloat = (self.cm_width - size.width) * 0.5
        if self.pageControlAliment == .right {
            x = self.mainView.cm_width - size.width - 10
        }
        let y: CGFloat = self.mainView.cm_height - size.height - 10
        if (self.pageControl is CMPageControl) {
            let pageControl = (self.pageControl as! CMPageControl)
            pageControl.sizeToFit()
        }
        self.pageControl?.frame = CGRect(x: x, y: y, width: size.width, height:size.height)
        self.pageControl?.isHidden = !showPageControl
        if (self.backgroundImageView != nil) {
            self.backgroundImageView?.frame = self.bounds
        }
    }
    //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
    override func willMove(toSuperview newSuperview: UIView?) {
        if (newSuperview == nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    //解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
    deinit {
        self.mainView.delegate = nil
        self.mainView.dataSource = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension CMCycleScrollView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! CMCollectionViewCell
        let itemIndex = indexPath.item % (self.imageURLsGroup?.count)!
        let url = self.imageURLsGroup?[itemIndex]
        cell.imageView!.backgroundColor = UIColor.white
        cell.imageView!.kf.setImage(with: url,
                              placeholder: self.placeholderImage,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        if !(cell.imageView!.image != nil) {
            cell.imageView!.image = self.placeholderImage
        }
        if (titlesGroup?.count != nil) {
            cell.title = (self.titlesGroup?[itemIndex])!
        }
        if !cell.hasConfigured {
            cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor
            cell.titleLabelHeight = self.titleLabelHeight
            cell.titleLabelTextColor = self.titleLabelTextColor
            cell.titleLabelTextFont = self.titleLabelTextFont
            cell.hasConfigured = true
            cell.imageView!.contentMode = self.bannerImageViewContentMode
        }
        return cell
    }
}
extension CMCycleScrollView:UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemIndex = (scrollView.contentOffset.x + self.mainView.cm_width * 0.5) / self.mainView.cm_width
        if self.imageURLsGroup?.count == 0{   // 解决清除timer时偶尔会出现的问题
            return
        }
        let indexOnPageControl = Int(itemIndex) % (self.imageURLsGroup?.count)!
        if (self.pageControl is CMPageControl) {
            let page = self.pageControl as! CMPageControl
            page.currentPage = indexOnPageControl
        } else {
            let pageControl = self.pageControl as! UIPageControl
            pageControl.currentPage = indexOnPageControl
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            timer?.invalidate()
            self.timer = nil
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.setupTimer()
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let itemIndex = (scrollView.contentOffset.x + self.mainView.cm_width * 0.5) / self.mainView.cm_width
        if self.imageURLsGroup?.count == 0 { // 解决清除timer时偶尔会出现的问题
            return
        }
        let indexOnPageControl = Int(itemIndex) % (self.imageURLsGroup?.count)!
        delegate?.cycleScrollView(self, didScrollTo: indexOnPageControl)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cycleScrollView(self, didSelectItemAt: indexPath.item % (self.imageURLsGroup?.count)!)
        if didClickItemBlock != nil {
            didClickItemBlock!(indexPath.item % (self.imageURLsGroup?.count)!)
        }
    }

    
}












