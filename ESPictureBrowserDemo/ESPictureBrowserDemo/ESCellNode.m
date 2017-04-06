//
//  ESCellNode.m
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/16.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

#import "ESCellNode.h"
#import "ESPictureModel.h"
#import "ESCellLayout.h"
#import <AsyncDisplayKit.h>
#import "ESPictureBrowser.h"
#import <YYImage/YYAnimatedImageView.h>
#import <YYWebImage/YYWebImage.h>

@interface ESCellNode()<ESPictureBrowserDelegate>

@property (nonatomic, strong) NSMutableArray<ASNetworkImageNode *> *pictureImageNodes;

@property (nonatomic, weak) ASTextNode *textNode;

@end

@implementation ESCellNode

- (NSMutableArray<ASNetworkImageNode *> *)pictureImageNodes {
    if (_pictureImageNodes == nil) {
        _pictureImageNodes = [NSMutableArray array];
    }
    return _pictureImageNodes;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ASTextNode *textNode = [[ASTextNode alloc] init];
        textNode.maximumNumberOfLines = 1;
        [self addSubnode:textNode];
        self.textNode = textNode;
    }
    return self;
}


- (void)setPictureModels:(NSArray<ESPictureModel *> *)pictureModels {
    _pictureModels = pictureModels;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd 张图片", pictureModels.count] attributes:attributes];
    self.textNode.attributedText = attr;
    
    for (ESPictureModel *pictureModel in pictureModels) {
        
        ASNetworkImageNode *node = [[ASNetworkImageNode alloc] init];
        NSURL *imageUrl = [NSURL URLWithString:pictureModel.smallPicUrl];
        if ([pictureModel.format isEqualToString:@"gif"]) {
            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
            imageView.clipsToBounds = true;
            [node.view addSubview:imageView];
            [imageView yy_setImageWithURL:imageUrl placeholder:nil];
        }else {
            node.URL = [NSURL URLWithString:pictureModel.middlePicUrl];
        }
        node.shouldRenderProgressImages = false;
        node.clipsToBounds = true;
        node.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        [node addTarget:self action:@selector(imageClick:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:node];
        [self.pictureImageNodes addObject:node];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *pictureSpec = [ESCellLayout pictureLayoutSpecWithPictureImageNodes:self.pictureImageNodes];
    ASStackLayoutSpec *contentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.textNode, pictureSpec]];
    ASInsetLayoutSpec *result = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(20, 20, 20, 20) child: contentSpec];
    return result;
}

- (void)layout {
    [super layout];
    
    for (ASNetworkImageNode *imageNode in self.pictureImageNodes) {
        YYAnimatedImageView *imageView = imageNode.view.subviews.firstObject;
        if (imageView != nil) {
            imageView.frame = imageNode.view.bounds;
        }
    }
}


- (void)imageClick:(ASNetworkImageNode *)imageNode {
    ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
    [browser setDelegate:self];
    [browser setLongPressBlock:^(NSInteger index) {
        NSLog(@"%zd", index);
    }];
    [browser showFromView:imageNode.view picturesCount:self.pictureModels.count currentPictureIndex:[self.pictureImageNodes indexOfObject:imageNode]];
}

#pragma mark - ESPictureBrowserDelegate


/**
 获取对应索引的视图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 视图
 */
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    return [self.pictureImageNodes objectAtIndex:index].view;
}

/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
    
    ESPictureModel *model = self.pictureModels[index];
    CGSize size = CGSizeMake(model.width, model.height);
    return size;
}

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片
 */
- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index {
    UIImage *image;
    ASNetworkImageNode *imageNode =  [self.pictureImageNodes objectAtIndex:index];
    if (imageNode.view.subviews.count == 1) {
        image = ((YYAnimatedImageView *)imageNode.view.subviews.firstObject).image;
    }else {
        image = imageNode.image;
    }
    return image;
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    ESPictureModel *model = self.pictureModels[index];
    return model.picUrl;
}

- (void)pictureView:(ESPictureBrowser *)pictureBrowser scrollToIndex:(NSInteger)index {
    NSLog(@"%ld", index);
}

@end
