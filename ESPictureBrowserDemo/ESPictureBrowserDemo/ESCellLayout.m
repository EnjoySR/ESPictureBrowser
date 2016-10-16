//
//  ESCellLayout.m
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/16.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

#import "ESCellLayout.h"


@implementation ESCellLayout

+ (ASLayoutSpec *)pictureLayoutSpecWithPictureImageNodes:(NSArray<ASNetworkImageNode *> *)pictureImageNodes {
    if (pictureImageNodes.count == 0) {
        return nil;
    }
    
    NSUInteger count = pictureImageNodes.count;
    ASLayoutSpec *contentSpec;
    switch (count) {
        case 1:
        case 2:
        case 3:
            contentSpec = [self pictureLayoutSpec123WithPictureImageNodes:pictureImageNodes];
            break;
        case 4:
        case 5:
        case 6:{
            ASLayoutSpec *topSpec = [self pictureLayoutSpec123WithPictureImageNodes: [pictureImageNodes subarrayWithRange:NSMakeRange(0, count - 3)]];
            ASLayoutSpec *bottomSpec = [self pictureLayoutSpec123WithPictureImageNodes: [pictureImageNodes subarrayWithRange:NSMakeRange(count - 3, 3)]];
            contentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[topSpec, bottomSpec]];
            break;
        }
        case 7:
        case 8:
        case 9:{
            ASLayoutSpec *topSpec = [self pictureLayoutSpec123WithPictureImageNodes: [pictureImageNodes subarrayWithRange:NSMakeRange(0, count - 6)]];
            ASLayoutSpec *middleSpec = [self pictureLayoutSpec123WithPictureImageNodes: [pictureImageNodes subarrayWithRange:NSMakeRange(count - 6, 3)]];
            ASLayoutSpec *bottomSpec = [self pictureLayoutSpec123WithPictureImageNodes: [pictureImageNodes subarrayWithRange:NSMakeRange(count - 3, 3)]];
            contentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[topSpec, middleSpec, bottomSpec]];
            break;
        }
        default:
            contentSpec = [ASLayoutSpec new];
            break;
    }
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:contentSpec];
    return insetSpec;
}

+ (ASLayoutSpec *)pictureLayoutSpec123WithPictureImageNodes:(NSArray<ASNetworkImageNode *> *)pictureImageNodes {
    NSUInteger count = pictureImageNodes.count;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 20 * 2 - 5 * (count - 1)) / count;
    CGFloat height = count == 1 ? 188 : width;
    
    for (ASNetworkImageNode *node in pictureImageNodes) {
        node.preferredFrameSize = CGSizeMake(width, height);
    }
    
    ASStackLayoutSpec *spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:pictureImageNodes];
    
    return spec;
}


@end
