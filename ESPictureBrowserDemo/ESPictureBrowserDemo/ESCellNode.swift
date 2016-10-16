//
//  ESCellNode.swift
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/15.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ESCellNode: ASCellNode {

    var pictureModels: [ESPictureModel]?
    
    lazy var pictureImageNodes: [ASNetworkImageNode] = [ASNetworkImageNode]()
    
    /// 配置数据
    func configurModel(pictureModels: [ESPictureModel]) {
        self.pictureModels = pictureModels
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor(red: 58/255, green: 143/255, blue: 183/255, alpha: 1)
        ]
        let attr = NSMutableAttributedString(string: "\(pictureModels.count) 张图片~~", attributes: attributes)
        textNode.attributedText = attr
        
        self.addSubnode(textNode)
        for pictureModel in pictureModels {
            let node = ASNetworkImageNode()
            node.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
            node.url = URL(string: pictureModel.middlePicUrl ?? "")
            node.addTarget(self, action: #selector(showPhotoBrowser(imageNode:)), forControlEvents: ASControlNodeEvent.touchUpInside)
            self.addSubnode(node)
            self.pictureImageNodes.append(node)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let pictureSpec = ESCellLayout.pictureLayoutSpec(pictureImageNodes: pictureImageNodes)!
        let contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 10, justifyContent: .start, alignItems: .start, children: [textNode, pictureSpec])
        let result = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(20, 20, 13, 20), child: contentSpec)
        return result
    }
    
    // MARK: - 监听方法
    @objc private func showPhotoBrowser(imageNode: ASNetworkImageNode) {
        let photoBrowser = ESPictureBrowser()
        photoBrowser.delegate = self
        photoBrowser.show(imageNode.view, picturesCount: self.pictureImageNodes.count, currentPictureIndex: pictureImageNodes.index(of: imageNode) ?? 0)
    }
    
    // 话题名字
    lazy var textNode: ASTextNode = {
        let textNode = ASTextNode()
        textNode.maximumNumberOfLines = 1
        return textNode
    }()
}

// 实现代理方法
extension ESCellNode: ESPictureBrowserDelegate {
    
    func pictureBrowser(_ browser: ESPictureBrowser, imageSize forIndex: Int) -> CGSize {
        if let pictureModel = pictureModels?[forIndex]{
            return CGSize(width: pictureModel.width, height: pictureModel.height)
        }
        return CGSize.zero
    }
    
    func pictureBrowser(_ browser: ESPictureBrowser, view forIndex: Int) -> UIView {
        return self.pictureImageNodes[forIndex].view
    }
    
    func pictureBrowser(_ browser: ESPictureBrowser, defaultImage forIndex: Int) -> UIImage? {
        return self.pictureImageNodes[forIndex].image
    }
    
    func pictureBrowser(_ browser: ESPictureBrowser, highQualityUrl forIndex: Int) -> String? {
        let pictureModel = pictureModels?[forIndex]
        return pictureModel?.picUrl
    }
}

