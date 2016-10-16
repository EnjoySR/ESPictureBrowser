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
import PINRemoteImage


@objc protocol ESPictureBrowserDelegate: NSObjectProtocol {
    
    
    /// 获取对应索引的View
    ///
    /// - parameter browser:  图片浏览器
    /// - parameter forIndex: 索引
    ///
    /// - returns: view
    func pictureBrowser(_ browser: ESPictureBrowser, view forIndex: Int) -> UIView
    
    
    /// 获取对应索引的图片大小
    ///
    /// - parameter browser:  图片浏览器
    /// - parameter forIndex: 索引
    ///
    /// - returns: 图片大小
    func pictureBrowser(_ browser: ESPictureBrowser, imageSize forIndex: Int) -> CGSize
    
    // 以下两个可选方法必须要实现一个
    
    /// 获取默认图片，可以是占位图，可以是缩略图
    ///
    /// - parameter browser:  图片浏览器
    /// - parameter forIndex: 索引
    ///
    /// - returns: 默认图片
    @objc optional func pictureBrowser(_ browser: ESPictureBrowser, defaultImage forIndex: Int) -> UIImage?
    
    
    /// 获取高质量的图片地址
    ///
    /// - parameter browser:  图片浏览器
    /// - parameter forIndex: 索引
    ///
    /// - returns: 图片 url 地址
    @objc optional func pictureBrowser(_ browser: ESPictureBrowser, highQualityUrl forIndex: Int) -> String?
}

class ESPictureBrowser: UIView {
    
    weak var delegate: ESPictureBrowserDelegate?
    
    /// 图片数组，3个 UIImageView。进行复用
    fileprivate lazy var pictureViews: [ESPictureView] = [ESPictureView]()
    /// 准备待用的图片视图（缓存）
    fileprivate lazy var readyToUsePictureViews: [ESPictureView] = [ESPictureView]()
    
    var picturesCount: Int = 0
    
    var currentPage: Int = 0 {
        didSet {
            if oldValue == currentPage || self.pictureViews.count == 0 {
                return
            }
            
            setPageText()
            if currentPage > oldValue {
                // 往右滑，设置右边视图
                if currentPage + 1 < picturesCount {
                    setPictureView(index: currentPage + 1)
                }else {
                    removiewViewToReUse()
                }
            }else {
                // 往左滑，设置左边视图
                if currentPage > 0 {
                    setPictureView(index: currentPage - 1)
                }else {
                    removiewViewToReUse()
                }
            }
        }
    }
    
    // MARK: - 初始化
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.clear
        self.frame = UIScreen.main.bounds
        
        self.addSubview(scrollView)
        self.addSubview(pageTextLabel)
    }
    
    // MARK: - 外界方法
    func show(_ fromView: UIView, picturesCount: Int, currentPictureIndex: Int) {
        if picturesCount <= 0 || currentPictureIndex >= picturesCount {
            print("Parameter is not correct \(picturesCount), \(currentPictureIndex)")
            return
        }
        if delegate == nil {
            print("Please set up delegate for pictureBrowser")
            return
        }
        // 计算图片张数
        self.picturesCount = picturesCount
        // 设置显示文件
        setPageText()
        // 添加到最后一个window上去
        UIApplication.shared.keyWindow!.addSubview(self)
        // 计算 scrollView 的 contentSize
        scrollView.contentSize = CGSize(width: CGFloat(picturesCount) * scrollView.frame.width, height: scrollView.frame.height)
        // 滚动到对应位置
        scrollView.contentOffset = CGPoint(x: CGFloat(currentPictureIndex) * scrollView.frame.width, y: 0)
        self.currentPage = currentPictureIndex
        // 设置第1个view的位置以及大小
        let imageView = setPictureView(index: currentPictureIndex)
        // 获取来源图片在屏幕上的位置
        let rect = fromView.convert(fromView.bounds, to: nil)

        imageView.animationShow(fromRect: rect, animationBlock: { 
            self.backgroundColor = UIColor.black
            self.pageTextLabel.alpha = 1
        }) {
            // 设置左边与右边的 imageView
            if currentPictureIndex != 0 && picturesCount > 1{
                // 设置左边
                self.setPictureView(index: currentPictureIndex - 1)
            }
            
            // 设置右边
            if currentPictureIndex < picturesCount - 1 {
                self.setPictureView(index: currentPictureIndex + 1)
            }
        }
    }
    
    func dismiss() {
        let endView = delegate!.pictureBrowser(self, view: currentPage)
        let rect = endView.convert(endView.bounds, to: nil)
        // 取到当前显示的 pictureView
        let pictureView = pictureViews.filter({
            return $0.index == currentPage
        }).first
        pictureView?.animationDismiss(toRect: rect, animationBlock: {
            self.backgroundColor = UIColor.clear
            self.pageTextLabel.alpha = 0
        }) {
            self.removeFromSuperview()
        }
    }
    
    
    /// 获取图片控件：如果缓存里面有，那就从缓存里面取，没有就创建
    ///
    /// - returns: <#return value description#>
    fileprivate func getPhotoView() -> ESPictureView {
        if readyToUsePictureViews.count == 0 {
            // 创建新的View，最多创建3个
            let view = ESPictureView()
            view.pictureDelegate = self
            self.scrollView.addSubview(view)
            self.pictureViews.append(view)
            return view
        }
        let view = readyToUsePictureViews.removeFirst()
        self.scrollView.addSubview(view)
        self.pictureViews.append(view)
        return view
    }
    
    /// 设置页数
    private func setPageText() {
        pageTextLabel.text = "\(currentPage + 1) / \(picturesCount)"
        pageTextLabel.sizeToFit()
        pageTextLabel.center.x = bounds.size.width / 2
        pageTextLabel.frame.origin.y = bounds.height - 30
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: -10, y: 0, width: self.frame.width + 20, height: self.frame.height))
        // 隐藏滚动条
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    fileprivate lazy var pageTextLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
}

// MARK: - UIScrollViewDelegate
extension ESPictureBrowser: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        self.currentPage = page
    }
    
    /// 设置pitureView到指定位置
    @discardableResult func setPictureView(index: Int) -> ESPictureView {
        
        removiewViewToReUse()
        let view = self.getPhotoView()
        // 设置当前view的index
        view.index = index
        view.frame.size = self.frame.size
        view.pictureSize = delegate!.pictureBrowser(self, imageSize: index)
        
        // 设置图片
        let placeholderImage = delegate?.pictureBrowser?(self, defaultImage: index)
        let url = URL(string: delegate?.pictureBrowser?(self, highQualityUrl: index) ?? "")
        view.imageView.pin_setImage(from: url, placeholderImage: placeholderImage)
        
        view.center.x = CGFloat(index) * scrollView.frame.width + scrollView.frame.width * 0.5
        return view
    }
    
    func removiewViewToReUse() {
        
        for view in self.pictureViews {
            // 判断某个view的页数与当前页数相差值为2的话，那么让这个view从视图上移除
            if abs(Int32(view.index - currentPage)) == 2 {
                let index = pictureViews.index(of: view)!
                view.removeFromSuperview()
                pictureViews.remove(at: index);
                readyToUsePictureViews.append(view)
                break
            }
        }
    }
}

extension ESPictureBrowser: ESPictureViewDelegate {
    
    func pictureView(touch pictureView: ESPictureView) {
        dismiss()
    }
    
    func pictureView(contentOffsetChange pictureView: ESPictureView, scale: CGFloat) {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1 - scale)
    }
}
