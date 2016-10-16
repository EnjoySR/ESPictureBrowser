//
//  ESPictureView.h
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/16.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ESPictureView;
@protocol ESPictureViewDelegate <NSObject>

- (void)pictureViewTouch:(ESPictureView *)pictureView;

- (void)pictureView:(ESPictureView *)pictureView scale:(CGFloat)scale;

@end

@interface ESPictureView : UIScrollView

// 当前视图所在的索引
@property (nonatomic, assign) NSUInteger index;
// 图片的大小
@property (nonatomic, assign) CGSize pictureSize;
// 当前显示图片的控件
@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, weak) id<ESPictureViewDelegate> pictureDelegate;
/**
 长按图片要执行的事件，将长按的索引回调
 */
@property (nonatomic, copy) void(^longPressBlock)(NSUInteger);

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
