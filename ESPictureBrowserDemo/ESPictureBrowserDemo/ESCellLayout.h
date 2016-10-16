//
//  ESCellLayout.h
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/16.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit.h>

@interface ESCellLayout : NSObject


/**
 通过图片 node 获取图片布局

 @param pictureImageNodes 图片 node 集合

 @return 布局
 */
+ (ASLayoutSpec *)pictureLayoutSpecWithPictureImageNodes:(NSArray<ASNetworkImageNode *> *)pictureImageNodes;

@end
