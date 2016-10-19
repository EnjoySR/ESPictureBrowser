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
#import <YYImage/YYAnimatedImageView.h>


@class ESPictureView;
@protocol ESPictureViewDelegate <NSObject>

- (void)pictureViewTouch:(ESPictureView *)pictureView;

- (void)pictureView:(ESPictureView *)pictureView scale:(CGFloat)scale;

@end

@interface ESPictureView : UIScrollView

// 当前视图所在的索引
@property (nonatomic, assign) NSInteger index;
// 图片的大小
@property (nonatomic, assign) CGSize pictureSize;
// 显示的默认图片
@property (nonatomic, strong) UIImage *placeholderImage;
// 图片的地址 URL
@property (nonatomic, strong) NSString *urlString;
// 当前显示图片的控件
@property (nonatomic, strong, readonly) UIImageView *imageView;
// 代理
@property (nonatomic, weak) id<ESPictureViewDelegate> pictureDelegate;

/**
 动画显示

 @param rect            从哪个位置开始做动画
 @param animationBlock  附带的动画信息
 @param completionBlock 结束的回调
 */
- (void)animationShowWithFromRect:(CGRect)rect animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;


/**
 动画消失

 @param rect            回到哪个位置
 @param animationBlock  附带的动画信息
 @param completionBlock 结束的回调
 */
- (void)animationDismissWithToRect:(CGRect)rect animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;

@end
