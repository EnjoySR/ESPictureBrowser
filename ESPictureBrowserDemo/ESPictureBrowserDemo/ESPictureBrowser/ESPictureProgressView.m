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

#import "ESPictureProgressView.h"

@interface ESPictureProgressView()

// 外界圆形
@property (nonatomic, strong) CAShapeLayer *circleLayer;
// 内部扇形
@property (nonatomic, strong) CAShapeLayer *fanshapedLayer;
// 错误
@property (nonatomic, strong) CAShapeLayer *errorLayer;

@end

@implementation ESPictureProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        rect.size = CGSizeMake(50, 50);
        self.frame = rect;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    circleLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    circleLayer.path = [self circlePath].CGPath;
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    CAShapeLayer *fanshapedLayer = [CAShapeLayer layer];
    fanshapedLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    [self.layer addSublayer:fanshapedLayer];
    self.fanshapedLayer = fanshapedLayer;
    
    CAShapeLayer *errorLayer = [CAShapeLayer layer];
    errorLayer.frame = self.bounds;
    // 旋转 45 度
    errorLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
    errorLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    errorLayer.path = [self errorPath].CGPath;
    [self.layer addSublayer:errorLayer];
    self.errorLayer = errorLayer;
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateProgressLayer];
}

- (void)showError {
    self.errorLayer.hidden = false;
    self.fanshapedLayer.hidden = true;
}

- (void)updateProgressLayer {
    self.errorLayer.hidden = true;
    self.fanshapedLayer.hidden = false;

    self.fanshapedLayer.path = [self pathForProgress:self.progress].CGPath;
}

- (UIBezierPath *)errorPath {
    CGFloat width = 30;
    CGFloat height = 5;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width * 0.5 - height * 0.5, (self.frame.size.width - width) * 0.5, height, width)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - width) * 0.5, self.frame.size.width * 0.5 - height * 0.5, width, height)];
    [path2 appendPath:path1];
    return path2;
}

- (UIBezierPath *)circlePath {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:true];
    path.lineWidth = 1;
    return path;
}

- (UIBezierPath *)pathForProgress:(CGFloat)progress {
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = self.frame.size.height * 0.5 - 2.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: center];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5, center.y - radius)];
    [path addArcWithCenter:center radius: radius startAngle: -M_PI / 2 endAngle: -M_PI / 2 + M_PI * 2 * progress clockwise:true];
    [path closePath];
    path.lineWidth = 1;
    return path;
}

@end
