//
//  ESCellLayout.swift
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/15.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ESCellLayout: NSObject {

    class func pictureLayoutSpec(pictureImageNodes: [ASNetworkImageNode]) -> ASLayoutSpec? {
        
        if pictureImageNodes.count == 0 {
            return nil
        }
        let count = pictureImageNodes.count
        var contentSpec: ASLayoutSpec
        switch count {
        case 1, 2, 3:
            contentSpec = self.pictureLayoutSpec123(pictureImageNodes: pictureImageNodes)
        case 4, 5, 6:
            let topSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropLast(3)))
            let bottomSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropFirst(count - 3)))
            contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 5, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topSpec, bottomSpec])
        case 7, 8, 9:
            let topSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropLast(6)))
            let middleSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropLast(3).dropFirst(count - 6)))
            let bottomSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.suffix(3)))
            contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 5, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topSpec, middleSpec, bottomSpec])
        default:
            contentSpec = ASLayoutSpec()
            break
        }
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: contentSpec)
        return insetSpec
    }
    
    private class func pictureLayoutSpec123(pictureImageNodes: [ASNetworkImageNode]) -> ASLayoutSpec {
        let count = pictureImageNodes.count
        let width = ((UIScreen.main.bounds.width) - 20 * 2 - 5 * CGFloat(count - 1)) / CGFloat(count)
        let height = count == 1 ? 188 : width
        pictureImageNodes.forEach({ (node) in
            node.preferredFrameSize = CGSize(width: width, height: height)
        })
        let contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 5, justifyContent: ASStackLayoutJustifyContent.spaceBetween, alignItems: ASStackLayoutAlignItems.stretch, children: pictureImageNodes)
        return contentSpec
    }
}
