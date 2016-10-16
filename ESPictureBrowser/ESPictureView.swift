//
// MIT License
//
// Copyright (c) 2016 EnjoySR (https://github.com/EnjoySR/ESPictureBrowser)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

protocol ESPictureViewDelegate: NSObjectProtocol {
    
    func pictureView(touch pictureView: ESPictureView)
    
    func pictureView(contentOffsetChange pictureView: ESPictureView, scale: CGFloat)
    
}

class ESPictureView: UIScrollView {
    
    override var contentSize: CGSize {
        didSet {
            if zoomScale == 1 {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.imageView.center.x = self.contentSize.width * 0.5
                })
            }
        }
    }
    
    weak var pictureDelegate: ESPictureViewDelegate?
    
    fileprivate var offsetY: CGFloat = 0
    
    fileprivate var doubleClicks: Bool = false
    
    // 拖动距离与屏高度的比例
    fileprivate var scale: CGFloat = 0
    
    fileprivate var lastContentOffset: CGPoint = CGPoint.zero {
        didSet {
            if self.isDragging == false && scale > 0.15 {
                lastContentOffset = oldValue
            }
        }
    }
    
    // 图片真实大小
    var pictureSize: CGSize = CGSize.zero {
        didSet {
            if pictureSize.equalTo(CGSize.zero) {
                return
            }
            
            // 计算显示的大小
            // 640 / 500
            // 320 / 250
            let screenW = UIScreen.main.bounds.width
            let scale = screenW / pictureSize.width
            let height = scale * pictureSize.height
            showPictureSize = CGSize(width: screenW, height: height)
        }
    }
    // 显示的大小
    fileprivate var showPictureSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) {
        didSet {
            self.imageView.frame = self.getImageActualFrame(imageSize: showPictureSize)
            self.contentSize = self.imageView.frame.size
        }
    }
    
    // 当前视图所在的 page
    var index: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置一些属性
        delegate = self
        alwaysBounceVertical = true
        backgroundColor = UIColor.clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        maximumZoomScale = 2
        addSubview(imageView)
        
        // 添加监听事件
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(longPress(ges:)))
        addGestureRecognizer(longGes)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapPress(ges:)))
        addGestureRecognizer(tapGes)
        
        let doubleTapGes = UITapGestureRecognizer(target: self, action: #selector(doubleClick(ges:)))
        doubleTapGes.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGes)
        tapGes.require(toFail: doubleTapGes)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 外部方法
    
    func animationShow(fromRect: CGRect, animationBlock: @escaping ()->(), complectionBlock: @escaping ()->()) {
        imageView.frame = fromRect
        UIView.animate(withDuration: 0.25, animations: {
            animationBlock()
            self.imageView.frame = self.getImageActualFrame(imageSize: self.showPictureSize)
        }) { (_) in
            complectionBlock()
        }
    }
    
    func animationDismiss(toRect: CGRect , animationBlock: @escaping ()->(), complectionBlock: @escaping ()->()) {
        UIView.animate(withDuration: 0.25, animations: {
            animationBlock()
            var rect = toRect
            rect.origin.y += self.offsetY
            // 这一句话用于在放大的时候去关闭
            rect.origin.x += self.contentOffset.x
            self.imageView.frame = rect
            
        }) { (stop) in
            if stop {
                complectionBlock()
            }
        }
    }
    
    // MARK: - 私有方法
    private func getImageActualFrame(imageSize: CGSize) -> CGRect {
        
        let x: CGFloat = 0
        var y: CGFloat = 0
        if imageSize.height < UIScreen.main.bounds.height {
            y = (UIScreen.main.bounds.height - imageSize.height) / 2
        }
        
        return CGRect(x: x, y: y, width: imageSize.width, height: imageSize.height)
    }

    // MARK: - 事件监听
    @objc private func longPress(ges: UILongPressGestureRecognizer) {
        // TODO
    }
    
    @objc private func tapPress(ges: UITapGestureRecognizer) {
        self.pictureDelegate?.pictureView(touch: self)
    }
    
    @objc private func doubleClick(ges: UITapGestureRecognizer) {
        var newScale: CGFloat = 2
        if doubleClicks {
            newScale = 1
        }
        let zoomRect = self.zoomRect(forScale: newScale, center: ges.location(in: ges.view))
        zoom(to: zoomRect, animated: true)
        doubleClicks = !doubleClicks
    }
    
    private func zoomRect(forScale scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect:CGRect = CGRect.zero
        zoomRect.size.height = self.frame.size.height / scale;
        zoomRect.size.width  = self.frame.size.width / scale;
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
        return zoomRect
    }
    
    
    // MARK: - 懒加载控件
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.bounds
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
}

extension ESPictureView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
        // 求出 offsetY
        offsetY = scrollView.contentOffset.y
        
        // 解决长图在缩放时候改变 contentOffset 执行后面计算 scale 的bug
        if isZoomBouncing || isZooming {
            print("返回返回")
            return
        }
        
        scale = abs(lastContentOffset.y) / UIScreen.main.bounds.height
        
        // 如果内容高度 > 屏幕高度
        // 并且偏移量 > 内容高度 - 屏幕高度
        // 那么就代表滑动到最底部了
        if scrollView.contentSize.height > UIScreen.main.bounds.height && lastContentOffset.y > scrollView.contentSize.height - UIScreen.main.bounds.height {
            scale = (scrollView.contentOffset.y - (scrollView.contentSize.height - UIScreen.main.bounds.height)) / UIScreen.main.bounds.height
        }
        
        
        // 条件1：拖动到顶部再继续往下拖
        // 条件2：拖动到顶部再继续往上拖
        // 两个条件都满足才去设置 scale -> 针对于长图
        if scrollView.contentSize.height > UIScreen.main.bounds.height {
            // 长图
            if scrollView.contentOffset.y < 0 || lastContentOffset.y > scrollView.contentSize.height - UIScreen.main.bounds.height {
                pictureDelegate?.pictureView(contentOffsetChange: self, scale: scale)
            }
        }else {
            pictureDelegate?.pictureView(contentOffsetChange: self, scale: scale)
        }
        
        // 如果用户松手
        if scrollView.isDragging == false {
            if scale > 0.15 && scale <= 1 {
                // 关闭
                pictureDelegate?.pictureView(touch: self)
                // 设置contentOffset
                scrollView.setContentOffset(lastContentOffset, animated: false)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        imageView.center.y = scrollView.contentSize.height * 0.5 + offsetY
        
        // 如果是缩小，保证在屏幕中间
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
            imageView.center.x = scrollView.contentSize.width * 0.5 + offsetX
        }
    }
    
}
