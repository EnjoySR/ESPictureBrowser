//
// MIT License
//
// Copyright (c) 2016 EnjoySR <https://github.com/EnjoySR/ESPictureBrowser>
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

#import <UIKit/UIKit.h>
@class ESPictureBrowser;
@protocol ESPictureBrowserDelegate <NSObject>

@required

/**
 获取对应索引的视图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 视图
 */
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index;


@optional
/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index;

// 以下两个代理方法必须要实现一个

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图

 @param pictureBrowser 图片浏览器
 @param index          索引

 @return 图片
 */
- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index;


/**
 获取对应索引的高质量图片地址字符串

 @param pictureBrowser 图片浏览器
 @param index          索引

 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index;

@end

@interface ESPictureBrowser : UIView

@property (nonatomic, weak) id<ESPictureBrowserDelegate> delegate;

/**
 图片之间的间距，默认： 20
 */
@property (nonatomic, assign) CGFloat betweenImagesSpacing;

/**
 页数文字中心点，默认：居中，中心 y 距离底部 20
 */
@property (nonatomic, assign) CGPoint pageTextCenter;

/**
 页数文字字体，默认：系统字体，16号
 */
@property (nonatomic, strong) UIFont *pageTextFont;

/**
 页数文字颜色，默认：白色
 */
@property (nonatomic, strong) UIColor *pageTextColor;

/**
 长按图片要执行的事件，将长按图片索引回调
 */
@property (nonatomic, copy) void(^longPressBlock)(NSInteger);

/**
 显示图片浏览器

 @param fromView            用户点击的视图
 @param picturesCount       图片的张数
 @param currentPictureIndex 当前用户点击的图片索引
 */
- (void)showFormView:(UIView *)fromView picturesCount:(NSInteger)picturesCount currentPictureIndex:(NSInteger)currentPictureIndex;

/**
 让图片浏览器消失
 */
- (void)dismiss;


@end
