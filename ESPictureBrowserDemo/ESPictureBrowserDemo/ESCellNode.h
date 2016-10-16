//
//  ESCellNode.h
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/16.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

@class ESPictureModel;
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ESCellNode : ASCellNode

@property (nonatomic, strong) NSArray<ESPictureModel *> *pictureModels;

@end
